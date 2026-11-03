#!/usr/bin/env bash
# Pull each submodule's default branch (whatever origin/HEAD points at —
# main, master, or other), stage the pin bumps in the umbrella, and print
# what changed. Does NOT commit or push the umbrella — leaves you to
# write one umbrella commit message covering all bumps.
#
# Sibling-pin propagation. After every submodule is pulled, walk each
# consumer (a submodule with a .sibling-pins file) and, for each line
# `<dep>=<sha>` in that file, rewrite the SHA to whatever the matching
# submodule now points to. If anything changed, commit + push inside
# the consumer with a small `chore: bump <dep> sibling pin` message.
# This keeps standalone CI building against the same SHA the umbrella
# does — without it, ycode/outpost's .sibling-pins lag the umbrella
# and `go build` resolves a different sh/nadir than the rest of the
# monorepo.
set -euo pipefail

cd "$(dirname "$0")/.."

# Every submodule the umbrella tracks. Keep in sync with .gitmodules —
# a submodule missing from this list is never pulled, never has its
# .sibling-pins propagated, and never gets its pointer staged, so its
# changes silently vanish from `sync: bump submodule pins`. coreutils is
# the most-changed of these; leaving it off (as an earlier revision did)
# is the exact footgun the umbrella CLAUDE.md warns about.
SUBMODULES="appstore bashsharp bashsharp-tests bashsharp-tour bashy bonsai coreutils filebrowser gfy nadir outpost readline sh ycode yoke"

# Pass 1: pull each submodule to its origin default branch.
for sub in $SUBMODULES; do
  if [ ! -d "$sub" ]; then
    echo "skip: $sub (not initialized — run script/bootstrap.sh first)" >&2
    continue
  fi
  echo "== $sub =="
  (
    cd "$sub"
    git fetch --quiet origin
    # Resolve origin/HEAD → e.g. "origin/master" → "master"
    branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
    if [ -z "$branch" ]; then
      echo "  (no origin/HEAD; skipping)" >&2
      exit 0
    fi
    git checkout --quiet "$branch"
    git pull --ff-only --quiet origin "$branch"
    # yoke carries nested submodules that bashy's go.mod path-replaces.
    git submodule update --quiet --init --recursive
  )
done

# Pass 2: propagate sibling SHAs into consumers' .sibling-pins. Walks
# every submodule that contains a .sibling-pins file, rewrites each
# `<dep>=<sha>` line to the dep's current submodule HEAD, and (if
# anything changed) commits + pushes inside the consumer.
for sub in $SUBMODULES; do
  pins="$sub/.sibling-pins"
  [ -f "$pins" ] || continue

  bumped=()
  while IFS= read -r line; do
    case "$line" in
      ''|'#'*) continue ;;
    esac
    name=${line%%=*}
    pinned=${line#*=}
    if [ -z "$name" ] || [ -z "$pinned" ] || [ "$name" = "$pinned" ]; then
      continue
    fi

    # Only propagate pins for deps the umbrella mounts as siblings.
    if [ ! -d "$name" ]; then
      continue
    fi
    current=$(git -C "$name" rev-parse HEAD)
    if [ "$current" = "$pinned" ]; then
      continue
    fi

    # In-place rewrite of `<name>=<old>` → `<name>=<new>`. BSD sed (macOS)
    # and GNU sed both accept `-i ''`.
    sed -i.bak "s|^$name=.*|$name=$current|" "$pins"
    rm -f "$pins.bak"
    bumped+=("$name:${current:0:12}")
  done < "$pins"

  if [ ${#bumped[@]} -gt 0 ]; then
    echo "-- $sub: bumping ${bumped[*]} in .sibling-pins"
    (
      cd "$sub"
      git add .sibling-pins
      # Compact one-line message lists each bumped dep.
      summary=$(IFS=,; echo "${bumped[*]}")
      git commit --quiet -m "chore: bump sibling pin(s) $summary"
      git push --quiet origin HEAD
    )
  fi
done

# Pass 3: stage every submodule pointer (catches both the direct
# default-branch pulls from pass 1 AND the .sibling-pins follow-up
# commits from pass 2).
for sub in $SUBMODULES; do
  [ -d "$sub" ] || continue
  git add "$sub"
done

echo
echo "Pin bumps staged. Review:"
git diff --cached --stat
echo
echo "Commit when ready:"
echo "  git commit -m 'sync: bump submodule pins'"
