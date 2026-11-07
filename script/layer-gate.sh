#!/bin/sh
# Layer ratchet gate: runs the shrink-only import-allowlist tests of sh,
# coreutils and bashy with GOWORK=off and prints one line per layer.
#
# Usage: script/layer-gate.sh      # from the umbrella root, submodules hydrated
# Exit:  0 all layers pass, 1 a ratchet failed, 2 BLOCKED (submodule missing)
set -eu

case "${1:-}" in
  -h|--help)
    sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

root=$(git rev-parse --show-toplevel)
cd "$root"

for d in sh coreutils bashy; do
  if [ ! -d "$d" ] || [ -z "$(ls -A "$d" 2>/dev/null)" ]; then
    echo "layer-gate: BLOCKED: submodule '$d' is missing or empty (run script/bootstrap.sh)" >&2
    exit 2
  fi
done

log=$(mktemp)
trap 'rm -f "$log"' EXIT
fail=0

run_layer() {
  name=$1
  shift
  if "$@" >"$log" 2>&1; then
    echo "layer-gate: $name: PASS"
  else
    echo "layer-gate: $name: FAIL"
    cat "$log" >&2
    fail=1
  fi
}

layer_sh() (
  cd sh && GOWORK=off go test ./interp/ -run 'GoSource|Layer|Import' -count=1
)
layer_coreutils() (
  cd coreutils && GOWORK=off go test ./cmd/coreutils/ -run Layer -count=1
)
layer_bashy() (
  cd bashy &&
    GOWORK=off go test ./internal/agentos/ -run ImportGraph -count=1 &&
    GOWORK=off go test -tags bashy_core ./cmd/bashy/ -run CoreImport -count=1 &&
    GOWORK=off go test -tags bashy_cert_base ./cmd/bashy/ -run CoreImport -count=1
)

run_layer sh layer_sh
run_layer coreutils layer_coreutils
run_layer bashy layer_bashy

if [ "$fail" -ne 0 ]; then
  echo "layer-gate: FAIL"
  exit 1
fi
echo "layer-gate: PASS"
