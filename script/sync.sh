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
SUBMODULES="agent-bench appstore bashsharp bashsharp-tests bashsharp-tour bashy bonsai coreutils filebrowser gfy gotreesitter nadir outpost readline sh yamux ycode yoke"

usage() {
  cat <<'USAGE'
usage: script/sync.sh [--check | -h | --help]

  (no arguments)  SYNC — mutates: fast-forwards every submodule to its
                  origin default branch, rewrites consumers' .sibling-pins
                  and COMMITS + PUSHES those inside the consumer repos, then
                  stages the umbrella gitlinks (it does not commit the
                  umbrella).
  --check         READ-ONLY drift report (fetches remotes, changes nothing):
                  per submodule, the umbrella pin vs origin's default
                  branch, the checkout vs the pin, unpushed commits and
                  uncommitted changes; for the umbrella, unpushed commits
                  and uncommitted tracked files. Exit 0 = in sync,
                  1 = drift found.
  -h, --help      this text.

Any other argument is refused, so a mistyped flag never starts a sync.
USAGE
}

# check reports drift without changing any working tree, branch or ref
# other than remote-tracking refs (git fetch).
check() {
  local drift=0 sub pin head branch obranch originsha behind ahead dirty unpushed
  for sub in $SUBMODULES; do
    [ -d "$sub" ] || { echo "$sub: not initialized"; continue; }
    git -C "$sub" fetch --quiet origin || { echo "$sub: fetch failed"; drift=1; continue; }
    pin=$(git ls-tree HEAD "$sub" | awk '{print $3}')
    head=$(git -C "$sub" rev-parse HEAD)
    obranch=$(git -C "$sub" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true)
    originsha=$(git -C "$sub" rev-parse "${obranch:-origin/HEAD}" 2>/dev/null || true)
    local notes=()
    if [ -n "$originsha" ] && [ "$pin" != "$originsha" ]; then
      behind=$(git -C "$sub" rev-list --count "$pin..$originsha" 2>/dev/null || echo "?")
      ahead=$(git -C "$sub" rev-list --count "$originsha..$pin" 2>/dev/null || echo "?")
      [ "$behind" != 0 ] && notes+=("pin ${pin:0:8} is $behind behind $obranch")
      [ "$ahead" != 0 ] && notes+=("pin ${pin:0:8} is $ahead ahead of $obranch (unpushed?)")
    fi
    if [ "$head" != "$pin" ]; then
      if git -C "$sub" merge-base --is-ancestor "$head" "$pin" 2>/dev/null; then
        notes+=("checkout ${head:0:8} is BEHIND the pin — do not commit this gitlink (it would move the pin backwards)")
      elif git -C "$sub" merge-base --is-ancestor "$pin" "$head" 2>/dev/null; then
        notes+=("checkout ${head:0:8} is ahead of the pin (bump forward once pushed)")
      else
        notes+=("checkout ${head:0:8} has diverged from the pin")
      fi
    fi
    branch=$(git -C "$sub" branch --show-current)
    if [ -n "$branch" ] && git -C "$sub" rev-parse --verify --quiet "origin/$branch" >/dev/null; then
      unpushed=$(git -C "$sub" rev-list --count "origin/$branch..HEAD")
      [ "$unpushed" != 0 ] && notes+=("$unpushed unpushed commit(s) on $branch")
    fi
    dirty=$(git -C "$sub" status --porcelain --untracked-files=no | wc -l | tr -d ' ')
    [ "$dirty" != 0 ] && notes+=("$dirty uncommitted tracked change(s)")
    if [ ${#notes[@]} -gt 0 ]; then
      drift=1
      echo "$sub:"
      printf '  - %s\n' "${notes[@]}"
    fi
  done
  git fetch --quiet origin || true
  branch=$(git branch --show-current)
  unpushed=$(git rev-list --count "origin/$branch..HEAD" 2>/dev/null || echo 0)
  if [ "$unpushed" != 0 ]; then drift=1; echo "umbrella: $unpushed unpushed commit(s) on $branch"; fi
  dirty=$(git status --porcelain --untracked-files=no --ignore-submodules=all | awk '{print $2}')
  if [ -n "$dirty" ]; then
    drift=1
    echo "umbrella: uncommitted tracked files:"
    printf '  - %s\n' $dirty
  fi
  [ "$drift" = 0 ] && echo "in sync: every pin matches origin, checkouts match pins, nothing unpushed or uncommitted"
  return "$drift"
}

case "${1:-}" in
  "") ;;
  -h|--help) usage; exit 0 ;;
  --check) [ $# -eq 1 ] || { usage >&2; exit 2; }; check; exit $? ;;
  *) echo "sync.sh: unknown argument: $1 (nothing was changed)" >&2; usage >&2; exit 2 ;;
esac

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
