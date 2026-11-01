#!/usr/bin/env bash
# Fast-forward public subprojects and stage their gitlinks for review.
# Dependency versions, commits and pushes remain explicit developer actions.
set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "sync: $*" >&2; exit 1; }

# Refuse unrelated root edits and an existing staged change. Submodule HEADs
# are checked separately, so a previously checked-out pin need not be current.
git diff --quiet --ignore-submodules=all || fail "umbrella files have local changes"
git diff --cached --quiet || fail "the umbrella index has staged changes"
[ -z "$(git ls-files --others --exclude-standard)" ] || fail "umbrella has untracked files"

submodules=()
branches=()
while IFS=' ' read -r key sub; do
  [ -n "$sub" ] || continue
  [ -e "$sub/.git" ] || fail "$sub is not initialized; run script/bootstrap.sh"
  [ -z "$(git -C "$sub" status --porcelain --untracked-files=all)" ] || fail "$sub has local changes"
  # Include initialized nested repositories before any checkout changes.
  git -C "$sub" submodule foreach --quiet --recursive '
    test -z "$(git status --porcelain --untracked-files=all)" || {
      echo "sync: nested submodule $displaypath has local changes" >&2
      exit 1
    }
  ' || fail "$sub has dirty nested submodules"
  submodules+=("$sub")
done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$')
[ "${#submodules[@]}" -gt 0 ] || fail "no submodules found"

# Fetch and validate every target before changing any checkout. Do not let
# fetch recurse through obsolete nested gitlinks from the old candidate.
for sub in "${submodules[@]}"; do
  git -C "$sub" fetch --no-recurse-submodules origin
  remote_head=$(git -C "$sub" symbolic-ref --quiet --short refs/remotes/origin/HEAD) || fail "$sub has no origin/HEAD"
  branch=${remote_head#origin/}
  case "$branch" in main|master) ;; *) fail "$sub default branch is $branch; review it explicitly" ;; esac
  git -C "$sub" rev-parse --verify "refs/remotes/origin/$branch" >/dev/null || fail "$sub has no origin/$branch"
  current=$(git -C "$sub" symbolic-ref --quiet --short HEAD || true)
  [ -z "$current" ] || [ "$current" = "$branch" ] || fail "$sub is on $current; finish that work first"
  # A detached checkout is safe to advance only if its work is already in
  # the selected integration branch. Never strand a unique detached commit.
  git -C "$sub" merge-base --is-ancestor HEAD "origin/$branch" || fail "$sub HEAD has work not integrated in origin/$branch"
  if git -C "$sub" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$sub" merge-base --is-ancestor "$branch" "origin/$branch" || fail "$sub local $branch has unpushed or divergent work"
  fi
  branches+=("$branch")
done

for ((i=0; i<${#submodules[@]}; i++)); do
  sub=${submodules[$i]}
  branch=${branches[$i]}
  echo "sync: $sub -> origin/$branch"
  if git -C "$sub" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$sub" switch "$branch"
  else
    git -C "$sub" switch --create "$branch" --track "origin/$branch"
  fi
  git -C "$sub" merge --ff-only "origin/$branch"
  git -C "$sub" submodule update --init --recursive
  [ -z "$(git -C "$sub" status --porcelain --untracked-files=all)" ] || fail "$sub is not clean after synchronization"
done

# Stage only gitlinks, and only after all projects have synchronized.
git add -- "${submodules[@]}"
echo "Pin bumps staged; review and commit with Sprint/Story/Story-ID trailers:"
git diff --cached --stat
