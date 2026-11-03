#!/usr/bin/env bash
# Independent invocations of original frozen contracts. Never replaces a failed gate.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
export EVIDENCE_DIR="${RUNNER_TEMP:?}/baseline-extra/${1:?contract required}"
mkdir -p "$EVIDENCE_DIR"
export GOWORK=off DEPENDENCY_MODE=standalone VALIDATION_LANE="baseline-extra-$1"
python3 script/validation-manifest.py > "$EVIDENCE_DIR/candidate.log"
printf '%s\n' 'Frozen-source supplemental invocation. Original failed gates remain failed. No implementation, assertion, oracle, skip or per-test deadline changes.' > "$EVIDENCE_DIR/scope.txt"
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
case "$1" in
focused-1|focused-2|focused-4)
  printf '%s\n' 'Independent diagnostic execution after the original gate failed preflight. Oracle-audit failure remains a failure even if selected tests execute; this is not a successful original prerequisite chain.' >> "$EVIDENCE_DIR/scope.txt"
  procs=${1#focused-}
  export GOMEMLIMIT=2GiB
  # Match original race wrapper: append its full tag to the workflow flags.
  export GOFLAGS="${GOFLAGS:-} -tags=full"
  go_bin=$(command -v go)
  export PATH="$(dirname "$go_bin"):/bin:/usr/bin:$PATH"
  awk -F '|' '/^#/ {next} NF==3 {print;next} NF==4 && $4=="linux" {print $1 "|" $2 "|" $3}' sh/scripts/bashpp-race-manifest.txt > "$EVIDENCE_DIR/manifest.resolved"
  python3 - "$EVIDENCE_DIR/manifest.resolved" "$EVIDENCE_DIR" <<'PY'
import pathlib,re,sys
rows=[line.split('|') for line in pathlib.Path(sys.argv[1]).read_text().splitlines()]
packages={'./syntax','./syntax/typedjson','./interp'}
if not rows or any(len(r)!=3 or r[0] not in packages or not re.fullmatch(r'Test[A-Za-z0-9_]+',r[2]) for r in rows):raise SystemExit('invalid original manifest')
if len({(r[0],r[2]) for r in rows})!=len(rows):raise SystemExit('duplicate original manifest member')
if {r[0] for r in rows}!=packages:raise SystemExit('missing original manifest package')
root=pathlib.Path(sys.argv[2]); names=sorted({r[2] for r in rows})
(root/'selector.txt').write_text('^('+'|'.join(names)+')$\n')
for package in packages:(root/(package.removeprefix('./').replace('/','-')+'.names')).write_text('\n'.join(sorted(r[2] for r in rows if r[0]==package))+'\n')
PY
  selector=$(cat "$EVIDENCE_DIR/selector.txt")
  for package in ./syntax ./syntax/typedjson ./interp; do
    name=${package#./}; name=${name//\//-}
    # Original discovery bound:60s per package. Keep stdout separate from diagnostics.
    (cd sh && timeout -k 5s 60s go test -list "$selector" "$package") > "$EVIDENCE_DIR/$name.discovery" 2> "$EVIDENCE_DIR/$name.discovery.stderr"
    grep '^Test' "$EVIDENCE_DIR/$name.discovery" | sort -u > "$EVIDENCE_DIR/$name.observed"
    diff -u "$EVIDENCE_DIR/$name.names" "$EVIDENCE_DIR/$name.observed"
  done
  run oracle-self sh timeout -k 5s 60s ./scripts/bashpp-test-oracle-audit.sh --self-test
  run oracle-audit sh timeout -k 5s 60s ./scripts/bashpp-test-oracle-audit.sh
  # Keep original compile300s, execution900s, per-package14m and count3.
  run race-build sh timeout -k 5s 300s go test -race -run '^$' ./syntax ./syntax/typedjson ./interp
  if [ "$(tail -1 "$EVIDENCE_DIR/results.tsv" | cut -f2)" = 0 ]; then
    run focused sh timeout -k 5s 900s env GOMAXPROCS="$procs" go test -race -timeout=14m -count=3 -run "$selector" ./syntax ./syntax/typedjson ./interp
  else
    printf '%s\n' 'BLOCKED: original 300s race compilation failed; focused execution not run.' > "$EVIDENCE_DIR/blocked.txt"
  fi
  ;;
filebrowser-race) run race filebrowser go test --race ./... ;;
gotreesitter-race)
  run grammar-fixtures . python3 script/provision-grammar-fixtures.py gotreesitter
  run race gotreesitter go test ./... -race -count=1
  ;;
yamux)
  run root-build yamux go build ./...
  run root-race yamux go test -race ./...
  run fuzz yamux go test -run '^$' -fuzz '^FuzzDecodeHeader$' -fuzztime 60s .
  run v5-build yamux/v5 go build ./...
  run v5-race yamux/v5 go test -race ./...
  run interop yamux/interop go test -race -skip TestSoak ./...
  run interop-v5 yamux/interop/v5replace go test -race ./...
  ;;
readline) run make-test readline make test; run examples readline make examples ;;
bonsai|gfy|nadir) run make-test "$1" make test ;;
nadir-onnx) run onnx nadir make test-onnx ;;
sh-cross)
  export GOFLAGS="${GOFLAGS:-} -tags=netgo"
  for pair in windows/amd64 windows/arm64 plan9/amd64 js/wasm; do
    run "${pair//\//-}" sh env GOOS="${pair%/*}" GOARCH="${pair#*/}" go build ./...
  done
  ;;
bashy-cross)
  for pair in linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64 windows/arm64; do
    run "bashy-${pair//\//-}" bashy env CGO_ENABLED=0 GOOS="${pair%/*}" GOARCH="${pair#*/}" ./scripts/go-product.sh build -o /dev/null ./cmd/bashy
    run "sh-${pair//\//-}" bashy env CGO_ENABLED=0 GOOS="${pair%/*}" GOARCH="${pair#*/}" ./scripts/go-product.sh build -o /dev/null ./cmd/sh
  done
  run outpost bashy env CGO_ENABLED=0 go build -tags fb_archives -o /dev/null github.com/qiangli/outpost/cmd/outpost
  run windows-vet bashy env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go vet ./tools/bash53suite
  run windows-test-compile bashy env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go test -c -o /dev/null ./tools/bash53suite
  ;;
gotreesitter-cgo-smoke)
  run smoke gotreesitter/cgo_harness env GTS_PARITY_MODE=smoke go test . -tags treesitter_c_parity -run '^TestParityFreshParse$|^TestParityIncrementalParse$|^TestParityHasNoErrors$|^TestParityIssue3Repros$|^TestParityGLRCanaryGo$|^TestParityGLRCanarySet$|^TestParityGLRCapPressureTopLanguages$|^TestParityGateCoverageRatchet$|^TestParityHighlight$' -timeout=20m -count=1 -v
  ;;
gotreesitter-cgo-exhaustive)
  run fresh gotreesitter/cgo_harness env GTS_PARITY_MODE=exhaustive go test . -tags treesitter_c_parity -run '^TestParityFreshParse$|^TestParityHasNoErrors$|^TestParityIssue3Repros$' -timeout=30m -count=1 -v
  run incremental gotreesitter/cgo_harness env GTS_PARITY_MODE=exhaustive go test . -tags treesitter_c_parity -run '^TestParityIncrementalParse$|^TestParityGLRCanaryGo$|^TestParityGLRCanarySet$|^TestParityGLRCapPressureTopLanguages$|^TestParityGateCoverageRatchet$' -timeout=30m -count=1 -v
  run corpus gotreesitter/cgo_harness env GTS_PARITY_MODE=exhaustive go test . -tags treesitter_c_parity -run '^TestParityCorpusFreshParse$' -timeout=30m -count=1 -v
  run highlight gotreesitter/cgo_harness env GTS_PARITY_MODE=exhaustive go test . -tags treesitter_c_parity -run '^TestParityHighlight$|^TestParityHighlightAllGrammars$|^TestParityYAMLCorpus$|^TestParityYAMLCorpusStructural$|^TestParityYAMLCorpusSummary$' -timeout=30m -count=1 -v
  ;;
gotreesitter-report)
  run parity gotreesitter env GOTREESITTER_GRAMMAR_BLOB_DIR=grammars/grammar_blobs go run -tags grammar_blobs_external ./cmd/parity_report
  ;;
yoke-crossvet) run crossvet yoke scripts/crossvet.sh ;;
ycode-dag)
  # Exact frozen DAG.md build/test commands; no release/model/evaluation targets.
  run format ycode scripts/fmtcheck.sh
  run vet ycode go vet ./...
  run features ycode go test -count=1 ./internal/features/...
  run compile ycode bash -euo pipefail -c 'go build -trimpath -ldflags "-s -w -X main.version=$(git describe --tags --always --dirty 2>/dev/null || echo dev) -X main.commit=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" -o bin/ycode ./cmd/ycode/'
  run race ycode go test -short -race -count=1 ./...
  ;;
bashy-oci-policy) run policy bashy make test-bashy-oci-policy ;;
bashy-installed-stress) run stress bashy make test-awd-installed-stress ;;
bashy-self-container)
  # The original runner explicitly accepts an OCI executable. Keep its pinned
  # base image, resource limits, inner target, and original test timeouts.
  run self-container bashy env BASHY_TEST_OCI=podman make test-self-container
  ;;
confirm-verbose)
  run dockexec sh go install mvdan.cc/dockexec@latest
  # Output-only verbosity reveals PASS/SKIP. Keep original Bash5.2 comparator image.
  run confirm sh env CGO_ENABLED=0 'GOFLAGS=-p=2 -tags=netgo,full' go test -v -run TestRunnerRunConfirm -exec 'dockexec bash:5.2' ./interp
  ;;
*) echo "unknown supplemental contract: $1" >&2; exit 2 ;;
esac
printf '%s\n' "$failed" > "$EVIDENCE_DIR/exit-code.txt"
exit "$failed"
