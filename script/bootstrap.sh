#!/usr/bin/env bash
# Hydrate the committed public submodule pins, including nested source
# dependencies, then install provenance and public-content hooks.
set -euo pipefail

cd "$(dirname "$0")/.."

# Do not overwrite local edits, including edits in initialized nested modules.
# A missing checkout is handled by submodule update; an interrupted or edited
# checkout requiring repair must be reviewed rather than force-reset here.
git submodule foreach --quiet --recursive '
  test -z "$(git status --porcelain --untracked-files=all --ignore-submodules=all)" || {
    echo "bootstrap: $displaypath has local changes; preserve them before retrying" >&2
    exit 1
  }
  if test "$(git rev-parse HEAD)" != "$sha1" &&
     test -z "$(git for-each-ref --contains HEAD --format="%(refname)" refs/heads refs/remotes)"; then
    echo "bootstrap: $displaypath has an unreferenced detached commit; preserve it before retrying" >&2
    exit 1
  fi
'
git submodule update --init --recursive

# Hooks: provenance guard (commit-msg, via bashy) + public-repo scrub gate
# (pre-commit). bashy sets core.hooksPath to .git/bashy-hooks; the scrub
# gate is dropped into the same directory so both run.
if command -v bashy >/dev/null 2>&1; then
  bashy sprint hooks install
else
  echo "bootstrap: bashy not on PATH — commit-msg provenance guard NOT installed" >&2
fi
hooks=$(git config core.hooksPath || true)
if [ -z "$hooks" ]; then
  hooks=.git/hooks
fi
mkdir -p "$hooks"
cat > "$hooks/pre-commit" <<'HOOK'
#!/bin/sh
exec "$(git rev-parse --show-toplevel)/script/scrub-gate.sh"
HOOK
chmod +x "$hooks/pre-commit" 2>/dev/null || true   # no mode bits on Windows; git runs hooks by shebang there

echo
echo "umbrella ready. Subprojects:"
git submodule status

cat <<'EOF2'

Go 1.27 with toolchain go1.27.2 is required.
The root go.work selects live sibling modules for development.
Use GOWORK=off to verify each module's published dependency pins independently.
Heavy builds and full suites belong on prepared test hosts. Commands there:
  cd bashy     && make test && make test-bash
  cd bashsharp && go test ./...
  cd sh        && go test -short ./...
  cd coreutils && go test ./...
  cd yoke      && go test $(go list ./... | grep -v /external/)
  cd outpost   && go test -short ./...   # shell tests need a TTY
  cd ycode     && go test -short ./...
EOF2
