#!/usr/bin/env bash
# Fresh-clone setup: fetch every submodule at its pinned SHA (including
# yoke's nested external/{ollama,podman}/src, which bashy's go.mod
# path-replaces), then install the git hooks. Idempotent — safe to re-run.
set -euo pipefail

cd "$(dirname "$0")/.."

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
chmod +x "$hooks/pre-commit"

echo
echo "umbrella ready. Subprojects:"
git submodule status

cat <<'EOF2'

Each subproject builds from its own root (no umbrella go.work). Quick checks:
  cd bashy     && go build ./... && make test
  cd bashsharp && go test ./...
  cd sh        && go test -short ./...
  cd coreutils && go test ./...
  cd yoke      && go test $(go list ./... | grep -v /external/)
  cd outpost   && go test -short ./...   # shell tests need a TTY
  cd ycode     && go test -short ./...
EOF2
