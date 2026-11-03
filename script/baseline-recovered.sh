#!/usr/bin/env bash
# Recovered immutable fixture inputs and explicitly separated build-configuration diagnostics.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
export EVIDENCE_DIR="${RUNNER_TEMP:?}/baseline-recovered/${1:?contract required}"
mkdir -p "$EVIDENCE_DIR"
export GOWORK=off DEPENDENCY_MODE=standalone VALIDATION_LANE="baseline-recovered-$1"
python3 script/validation-manifest.py > "$EVIDENCE_DIR/candidate.log"
failed=0
run() {
  local label=$1 directory=$2 rc
  shift 2
  printf '%q ' "$@" > "$EVIDENCE_DIR/$label.command"
  printf '\n' >> "$EVIDENCE_DIR/$label.command"
  if (cd "$root/$directory" && "$@") > "$EVIDENCE_DIR/$label.log" 2>&1; then rc=0; else rc=$?; fi
  printf '%s\t%s\n' "$label" "$rc" >> "$EVIDENCE_DIR/results.tsv"
  if [ "$rc" -ne 0 ]; then failed=1; fi
  return 0
}
fixture() {
  local label=$1 url=$2 sha=$3 directory=$4
  [ ! -e "$directory" ] || { echo "refusing existing fixture: $directory" >&2; exit 2; }
  git init -q "$directory"
  git -C "$directory" fetch --depth=1 "$url" "$sha"
  git -C "$directory" checkout -q --detach FETCH_HEAD
  [ "$(git -C "$directory" rev-parse HEAD)" = "$sha" ]
  [ -z "$(git -C "$directory" status --porcelain)" ]
  git -C "$directory" ls-tree -r HEAD > "$EVIDENCE_DIR/$label.tree"
  printf '%s %s\n' "$url" "$sha" > "$EVIDENCE_DIR/$label.source"
}
export OCI="$root/script/validation-oci.sh"
case "$1" in
uutils)
  fixture uutils https://github.com/uutils/coreutils.git a7551d77574266075f085d7db9add85e15dec7d6 coreutils/reference/uutils-coreutils
  export UUTILS_CAPTURE_WORK_ROOT="$EVIDENCE_DIR/owned-work"
  export UUTILS_CAPTURE_DIR="$EVIDENCE_DIR/raw"
  mkdir -p "$UUTILS_CAPTURE_WORK_ROOT"
  export TMPDIR="$UUTILS_CAPTURE_WORK_ROOT" UUTILS_OCI="$root/script/baseline-uutils-oci.py"
  run prepare bashy make prepare-uutils-image
  if [ "$(tail -1 "$EVIDENCE_DIR/results.tsv" | cut -f2)" = 0 ]; then
    run suite bashy make test-uutils "UUTILS_OUT=$EVIDENCE_DIR/uutils"
  else
    printf '%s\n' 'BLOCKED: original dependency image preparation failed; suite not run.' > "$EVIDENCE_DIR/blocked.txt"
  fi
  ;;
yash)
  fixture yash https://github.com/magicant/yash.git db0a8477dbb212842bad43e44c2273f18f854d81 bashy/.yash-tests
  printf '%s\n' 'All256 historical frozen tests match this revision. Original default build first; CGO0 followup is a separately labelled portable-build diagnostic, not unchanged CGO-default acceptance.' > "$EVIDENCE_DIR/scope.txt"
  run original-scoreboard bashy make test-yash "YASH_OUT=$EVIDENCE_DIR/original-scoreboard"
  run portable-scoreboard bashy env CGO_ENABLED=0 make test-yash "YASH_OUT=$EVIDENCE_DIR/portable-scoreboard"
  run panel-cli-build bashy make build-bashy
  if [ "$(tail -1 "$EVIDENCE_DIR/results.tsv" | cut -f2)" = 0 ]; then
    git -C bashy rev-parse HEAD > "$EVIDENCE_DIR/panel-cli-source.txt"
    sha256sum bashy/bin/bashy > "$EVIDENCE_DIR/panel-cli.sha256"
    for payload in bashy/bin/bashy.real bashy/bin/bash.real; do
      if [ -f "$payload" ]; then sha256sum "$payload" >> "$EVIDENCE_DIR/panel-cli.sha256"; fi
    done
    run portable-posix-panels bashy env CGO_ENABLED=0 BASHY="$root/bashy/bin/bashy" scripts/yash-posix-suite.sh "$EVIDENCE_DIR/portable-panels"
  else
    printf '%s\n' 'BLOCKED: original frozen Bashy CLI build failed; Yash panel runner not run.' > "$EVIDENCE_DIR/panels-blocked.txt"
  fi
  ;;
posix-loader)
  printf '%s\n' 'Original CGO-default cmd/bash build and ELF/container execution proof. CGO0 is a distinct portable-build configuration, never transferred to original-build acceptance. Frozen sources, corpora, oracle declarations and assertions unchanged.' > "$EVIDENCE_DIR/scope.txt"
  run build-environment bashy go env GOOS GOARCH CGO_ENABLED CC GOTOOLCHAIN
  run original-build bashy env GOOS=linux GOARCH=amd64 go build -o "$EVIDENCE_DIR/original-bash" ./cmd/bash
  [ -f "$EVIDENCE_DIR/original-bash" ] || exit 1
  run original-elf . readelf -l -d "$EVIDENCE_DIR/original-bash"
  run original-metadata . go version -m "$EVIDENCE_DIR/original-bash"
  sha256sum "$EVIDENCE_DIR/original-bash" > "$EVIDENCE_DIR/original-bash.sha256"
  interpreter=$(readelf -l "$EVIDENCE_DIR/original-bash" | sed -n 's/.*Requesting program interpreter: \(.*\)]/\1/p')
  printf '%s\n' "$interpreter" > "$EVIDENCE_DIR/original-interpreter.txt"
  for image in bash:5.3 debian:stable-slim; do
    label=${image%%:*}
    run "$label-pull" . docker pull "$image"
    run "$label-identity" . docker image inspect "$image"
    run "$label-original-exec" . docker run --rm -e "EXPECTED_INTERPRETER=$interpreter" -v "$EVIDENCE_DIR/original-bash:/bashy:ro" "$image" /bin/sh -c 'ls -l /bashy; if [ -n "$EXPECTED_INTERPRETER" ]; then ls -l "$EXPECTED_INTERPRETER"; fi; /bashy -c "printf original-executed"'
  done
  run portable-build bashy env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o "$EVIDENCE_DIR/portable-bash" ./cmd/bash
  run portable-elf . readelf -l -d "$EVIDENCE_DIR/portable-bash"
  run portable-metadata . go version -m "$EVIDENCE_DIR/portable-bash"
  sha256sum "$EVIDENCE_DIR/portable-bash" > "$EVIDENCE_DIR/portable-bash.sha256"
  run alpine-portable-exec . docker run --rm -v "$EVIDENCE_DIR/portable-bash:/bashy:ro" bash:5.3 /bin/sh -c '/bashy -c "printf portable-executed"'
  run portable-xcu bashy env CGO_ENABLED=0 scripts/posix-diff.sh
  run portable-multishell bashy env CGO_ENABLED=0 scripts/multishell-diff.sh
  fixture oils https://github.com/oils-for-unix/oils.git 15de8fd779569e6e3a9f5fcbfc00e7df0ebe0380 bashy/priorart/oils
  run portable-oils bashy env CGO_ENABLED=0 scripts/oils-diff.sh
  ;;
*) echo "unknown recovered contract: $1" >&2; exit 2 ;;
esac
printf '%s\n' "$failed" > "$EVIDENCE_DIR/exit-code.txt"
exit "$failed"
