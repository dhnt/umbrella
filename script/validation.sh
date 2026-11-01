#!/usr/bin/env bash
# Manual validation orchestration; the subprojects own all test verdicts.
# Single-quoted programs below are deliberately expanded by their child Bash.
# shellcheck disable=SC2016
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
export EVIDENCE_DIR=${EVIDENCE_DIR:-${RUNNER_TEMP:?set RUNNER_TEMP or EVIDENCE_DIR}/umbrella-validation}
mkdir -p "$EVIDENCE_DIR"
export VALIDATION_LANE=${1:?select a validation lane}
export DEPENDENCY_MODE=${DEPENDENCY_MODE:-workspace}
# The full Sh runner enumerates its independent moreinterp module and invokes
# dockexec, whose module discovery expects one main module. Native quick tests
# retain workspace coverage; the full release contract uses standalone mode.
if [ "$VALIDATION_LANE" = shell-full ]; then
  export DEPENDENCY_MODE=standalone
fi
if [ "$DEPENDENCY_MODE" = standalone ]; then
  export GOWORK=off
else
  if [ "${RUNNER_OS:-}" = Windows ]; then
    GOWORK=$(cygpath -w "$root/go.work")
    export GOWORK
  else
    export GOWORK="$root/go.work"
  fi
fi
python "$root/script/validation-manifest.py" > "$EVIDENCE_DIR/manifest.log"
printf '%s\n' "Lane: $VALIDATION_LANE; mode: $DEPENDENCY_MODE. This is per-lane evidence, not an aggregate release verdict. Review all job statuses, raw logs and recorded coverage limitations." > "$EVIDENCE_DIR/coverage.md"
failed=0
run() {
  local name=$1 dir=$2 rc
  local -a statuses
  shift 2
  printf '\n>>> %s\n' "$name"
  set +e
  (cd "$root/$dir" && "$@") 2>&1 | tee "$EVIDENCE_DIR/$name.log"
  statuses=("${PIPESTATUS[@]}")
  rc=${statuses[0]}
  [ "${statuses[1]}" -eq 0 ] || rc=${statuses[1]}
  set -e
  printf '%s\t%s\n' "$name" "$rc" >> "$EVIDENCE_DIR/exit-codes.tsv"
  return "$rc"
}
check() { run "$@" || failed=1; }
# Invoked directly by run()'s subshell, never exported into test environments.
# shellcheck disable=SC2329
pty() {
  if [ "$RUNNER_OS" = Linux ]; then
    local command
    printf -v command '%q ' "$@"
    script -qefc "$command" /dev/null
  else
    # BSD script propagates the child exit code and accepts argv directly.
    script -q /dev/null "$@"
  fi
}
export -n -f pty

case "$VALIDATION_LANE" in
native)
  cat > "$EVIDENCE_DIR/coverage.md" <<'EOF'
Native build/unit/integration lane. Standalone runs resolve published module
pins; workspace runs use the recorded sibling candidate. Windows Sh is build
coverage, not execution of its unsupported full interpreter tests. Windows
Coreutils/Yoke follow their compile-plus-portable-test CI contract. Outpost's
PTY lane runs on Unix only. Full Bashy make, Sh full/race, Bash fixtures,
free POSIX suites and Bash# corpus are separate jobs; this lane alone is not
full validation. Baseline ratchets retain their raw failures in logs.
EOF
  check bashy-product bashy bash -euo pipefail -c 'mkdir -p bin; ext=; [ "$RUNNER_OS" != Windows ] || ext=.exe; scripts/go-product.sh build -o "bin/bashy$ext" ./cmd/bashy'
  export PATH="$root/bashy/bin:$PATH"
  check bashy-build bashy go build ./cmd/bash ./cmd/sh ./cmd/bashy ./internal/...
  check bashy-vet bashy go vet ./cmd/bash ./cmd/sh ./cmd/bashy ./internal/agentos
  if [ "$RUNNER_OS" = Windows ]; then
    check bashy-cli-portable bashy go test -count=1 -timeout 5m -run '^TestStrictPosixEngagedByArgv0Sh$' ./internal/cli
    check bashy-agentos bashy go test -count=1 -timeout 10m ./internal/agentos
    check bash53-runner bashy go test -count=1 -timeout 5m ./tools/bash53suite
  else
    check bashy-native bashy pty go test -count=1 -timeout 10m ./internal/cli ./internal/agentos
  fi
  check bashy-source-route bashy go test -count=1 -timeout 5m -run '^TestSourceRoute$' ./cmd/bashy
  check bashy-e2e bashy go test -count=1 -timeout 8m -tags e2e -run '^(TestE2EAllListedCommandsDispatch|TestE2ERegisteredAppFlow|TestE2ECustomLauncher)$' ./internal/agentos
  check coreutils-vet coreutils go vet ./...
  check yoke-vet yoke bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v /external/); if [ "$RUNNER_OS" = Windows ]; then pkgs=$(printf "%s\n" "$pkgs" | grep -vE "/pkg/weave$"); fi; go vet $pkgs github.com/qiangli/yoke/external/gotoolchain github.com/qiangli/yoke/external/act github.com/qiangli/yoke/external/gh'
  if [ "$RUNNER_OS" = Windows ]; then
    check coreutils-compile coreutils go test -run '^$' ./...
    check coreutils-owned-child coreutils bash -euo pipefail -c 'go test ./tool -run "^TestOwnedExecLargeArgumentsAndEnvironment$" -count=1 && go build -o coreutils-owned-proof.exe ./cmd/coreutils && python scripts/owned-exec-windows-proof.py coreutils-owned-proof.exe'
    check yoke-compile yoke bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v /external/ | grep -vE "/pkg/weave$"); go test -run "^$" $pkgs'
    check yoke-resources yoke go test -count=1 -timeout 3m ./pkg/resources -run 'Test(CollectLiveHost|CollectSingleSample|HostObservation|ResourceAlert|ResourcesObservationChild)'
    check yoke-budget yoke go test -count=1 -timeout 3m ./pkg/llmbudget
    check yoke-capacity yoke bash -euo pipefail -c 'go test ./pkg/dag -list "^TestCapacity(Executable|UnsupportedPlatforms)" > "$EVIDENCE_DIR/windows-capacity-tests.txt"; grep -Fx TestCapacityExecutablePlatformMode "$EVIDENCE_DIR/windows-capacity-tests.txt"; grep -Fx TestCapacityUnsupportedPlatformsNeverAdvertiseGuardedExecution "$EVIDENCE_DIR/windows-capacity-tests.txt"; go test -count=1 -timeout 3m ./pkg/dag -run "^TestCapacity(Executable|UnsupportedPlatforms)"'
    check sh-build sh go build ./...
    check sh-moreinterp-build sh/moreinterp env GOWORK=off go build ./...
    check outpost-build outpost go build -tags fb_archives ./...
  else
    check coreutils-ratchet coreutils scripts/ci-test-gate.sh
    check yoke-ratchet yoke scripts/ci-test-gate.sh
    check sh-quick sh make test-quick
    check sh-moreinterp sh/moreinterp env GOWORK=off go test -short -count=1 -timeout 10m ./...
    check outpost-headless outpost bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v "/internal/agent/shell$"); go test -tags fb_archives -short -count=1 -timeout 10m $pkgs'
    check outpost-pty outpost pty go test -tags fb_archives -count=1 -timeout 10m ./internal/agent/shell/...
  fi
  for module in bashsharp bonsai gfy nadir ycode; do
    check "$module-unit" "$module" go test -short -count=1 -timeout 10m ./...
  done
  check provider-unit yoke/pkg/provider env GOWORK=off go test -count=1 -timeout 5m ./...
  ;;
module-tests)
  run grammar-fixtures . python script/provision-grammar-fixtures.py gotreesitter
  printf '%s\n' 'Additional public module suites on Linux. Other platforms are not measured by this lane; the native job covers its explicitly listed portable product contracts.' > "$EVIDENCE_DIR/coverage.md"
  for module in agent-bench appstore filebrowser gotreesitter readline yamux; do
    check "$module-unit" "$module" go test -short -count=1 -timeout 15m ./...
  done
  check yamux-v5-unit yamux/v5 go test -short -count=1 -timeout 15m ./...
  ;;
bashy-full)
  check make-test bashy pty make test
  ;;
shell-full)
  printf '%s\n' 'Full Sh release suite, nested moreinterp, race and confirm gates use standalone module resolution (GOWORK=off). Workspace quick coverage remains in the native lane. No packages or tests excluded.' > "$EVIDENCE_DIR/coverage.md"
  check sh-full sh env 'GOFLAGS=-p=2 -tags=netgo,full' make test-full
  if [ "$RUNNER_OS" = Linux ]; then
    check sh-race sh make bashpp-race-gate
    check sh-confirm sh bash -euo pipefail -c 'go install mvdan.cc/dockexec@latest && CGO_ENABLED=0 go test -run TestRunnerRunConfirm -exec "dockexec bash:5.2" ./interp'
  fi
  ;;
bash53)
  run bash53-source . python script/provision-conformance-fixtures.py bash53 bashy
  if [ "$RUNNER_OS" = Windows ]; then
    check windows-locales bashy scripts/provision-windows-wsl-locales.sh
    check windows-containment bashy go test -count=1 -timeout 5m -run TestFixture ./tools/bash53suite
    check windows-measurement bashy scripts/ci-bash53-windows.sh
    printf '%s\n' 'Windows Bash fixture results are measurements, not an 86/86 acceptance gate. Inspect raw counts.' > "$EVIDENCE_DIR/coverage.md"
    # Existing Windows script sets -mod=mod; its supported mode is standalone.
  else
    check bash53-fixtures bashy make test-bash-fixtures
    check bash53-helpers bashy make test-bash-helpers
    check bash53-native bashy pty make test-bash
  fi
  ;;
free-posix)
  check bashy-build bashy make build
  export PATH="$root/bashy/bin:$PATH"
  export BASHY="$root/bashy/bin/bashy"
  export OCI="$root/script/validation-oci.sh" BASH53_OCI="$root/script/validation-oci.sh"
  run bash53-source . python script/provision-conformance-fixtures.py bash53 bashy
  run free-suite-sources . python script/provision-conformance-fixtures.py free-posix bashy
  check bash53-container bashy make test-bash-container
  check bash53-container-bashpp bashy make test-bash-container-bashpp
  mkdir -p "$EVIDENCE_DIR/free-suite-logs"
  check free-posix bashy env TMPDIR="$EVIDENCE_DIR/free-suite-logs" scripts/posix-certdryrun.sh
  printf '%s\n' 'Free POSIX suite runner verdicts preserved verbatim. INFO/PENDING are not PASS. Licensed certification is not covered by this public workflow.' > "$EVIDENCE_DIR/coverage.md"
  ;;
candidate-prepare)
  run candidate-build bashy make build-bashy
  python "$root/script/validation-manifest.py" --prepare-candidate
  printf '%s\n' 'PREPARED ONLY: artifact awaits independent review and registry approval; no corpus verdict.' > "$EVIDENCE_DIR/coverage.md"
  ;;
bashsharp)
  export SH_ROOT="$root/sh" BASHY_ROOT="$root/bashy"
  export BASHY_BIN="$root/bashy/bin/bashy" BASHY_AGENTOS_BIN="$root/bashy/bin/bashy"
  export NANOCHAT_ROOT="${RUNNER_TEMP:?}/bashsharp-fixtures/nanochat"
  export MINISWE_ROOT="$RUNNER_TEMP/bashsharp-fixtures/mini-swe-agent"
  export OPENCODE_ROOT="$RUNNER_TEMP/bashsharp-fixtures/opencode"
  export BASHPP_BUN BASHPP_NODE
  BASHPP_BUN=$(command -v bun)
  BASHPP_NODE=$(command -v node)
  export BASHPP_TYPESCRIPT_MODULE="$OPENCODE_ROOT/node_modules/typescript"
  # Exact upstream revisions are the existing corpus's fixture contracts.
  # Provision separately from the read-only gates, retaining every install log.
  run fixture-checkouts . bash -euo pipefail -c '
    mkdir -p "$(dirname "$NANOCHAT_ROOT")"
    checkout() {
      git init "$3"
      git -C "$3" remote add origin "$1"
      git -C "$3" fetch --depth=1 origin "$2"
      git -C "$3" checkout --detach FETCH_HEAD
      test "$(git -C "$3" rev-parse HEAD)" = "$2"
    }
    checkout https://github.com/karpathy/nanochat dc54a1a3077cab11d68fac4c5d1cd5c51f5d8c7a "$NANOCHAT_ROOT"
    checkout https://github.com/SWE-agent/mini-swe-agent 04d809ceab9df28f9adaed044884180159172930 "$MINISWE_ROOT"
    checkout https://github.com/anomalyco/opencode e03db9bc6908f75c9334d8aa997deeaac81c0298 "$OPENCODE_ROOT"
  '
  # nanochat.execution uses only Python stdlib; no model or GPU packages needed.
  run python-fixture-install . bash -euo pipefail -c '
    python -m venv "$MINISWE_ROOT/.venv"
    "$MINISWE_ROOT/.venv/bin/python" -m pip install "$MINISWE_ROOT"
    "$MINISWE_ROOT/.venv/bin/python" -m pip freeze > "$EVIDENCE_DIR/python-fixture-packages.txt"
  '
  run opencode-fixture-install . bash -euo pipefail -c '
    cd "$OPENCODE_ROOT"
    bun install --frozen-lockfile
    test -z "$(git status --porcelain=v1)"
    test -f "$BASHPP_TYPESCRIPT_MODULE/package.json"
    bun --version
    node --version
  '
  run go-corpus-source bashsharp-tests bash -euo pipefail -c '
    IFS="$(printf "\t")" read -r release kind filename url sha rest < <(awk "!/^#/ && NF {print; exit}" docs/go-corpus/pin.tsv)
    cache="$RUNNER_TEMP/bashsharp-fixtures/go-corpus"
    mkdir -p "$cache/$release"
    curl --fail --location --silent --show-error "$url" -o "$cache/$filename"
    printf "%s  %s\n" "$sha" "$cache/$filename" | sha256sum --check
    tar -xzf "$cache/$filename" -C "$cache/$release" --strip-components=1
    printf "%s" "$cache/$release" > "$EVIDENCE_DIR/go-corpus-root.txt"
  '
  export GO_CORPUS_ROOT
  GO_CORPUS_ROOT=$(cat "$EVIDENCE_DIR/go-corpus-root.txt")
  run sh-module-cache sh env GOWORK=off go mod download
  run bashy-module-cache bashy env GOWORK=off go mod download
  : "${CANDIDATE_BUNDLE:?download the reviewed candidate artifact first}"
  python - "$CANDIDATE_BUNDLE/candidate-binaries.tar" "$root/bashy" <<'PYRESTORE'
import pathlib, sys, tarfile
with tarfile.open(sys.argv[1]) as archive:
    members = archive.getmembers()
    if len(members) != 1 or members[0].name != "bin/bashy" or not members[0].isfile():
        raise SystemExit("Candidate archive must contain only the native bin/bashy file")
    target = pathlib.Path(sys.argv[2]) / "bin/bashy"
    if target.is_symlink() or target.parent.is_symlink():
        raise SystemExit("Candidate destination must not be a symlink")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(archive.extractfile(members[0]).read())
    target.chmod(0o755)
PYRESTORE
  export GBE_CANDIDATE="$CANDIDATE_BUNDLE/gbe-candidate.json"
  cp "$GBE_CANDIDATE" "$EVIDENCE_DIR/gbe-candidate.json"
  run authenticate-candidate bashsharp-tests env GOWORK=off bash tools/go-by-example/gbe.sh validate-candidate --candidate "$GBE_CANDIDATE" --bashy "$BASHY_BIN"
  check python-package-gate bashsharp-tests env GOWORK=off BASHY="$BASHY_BIN" bash tools/python-package-gate.sh
  check typescript-package-gate bashsharp-tests env GOWORK=off bash tools/sprint184-typescript-gate.sh
  # Keep structured failure details, progress journal, raw logs and retained
  # execution trees inside the uploaded evidence, including unsuccessful runs.
  export GBE_RESULTS="$EVIDENCE_DIR/go-by-example/results.jsonl"
  check bashsharp-corpus bashsharp-tests env GOWORK=off bash harness/run.sh
  python - "$GBE_RESULTS" <<'PYGBE'
import json, pathlib, sys
for path in pathlib.Path(sys.argv[1]).parent.glob("results.jsonl.*"):
    if not path.is_file() or path.name.endswith(".progress.jsonl"):
        continue
    for line in path.read_text().splitlines():
        record = json.loads(line)
        if record.get("type") == "attempt" and record.get("verdict", "").startswith("fail"):
            print(json.dumps({key: record.get(key) for key in
                ("path", "mode", "verdict", "state", "detail", "stages")}, sort_keys=True))
PYGBE
  printf '%s\n' 'Full existing Bash# harness invoked without exclusions. PLANNED is not PASS. Missing pinned foreign fixture environments or oracle prerequisites fail the lane; no tests are silently skipped or reclassified here.' > "$EVIDENCE_DIR/coverage.md"
  ;;
*) echo "unknown validation lane: $VALIDATION_LANE" >&2; exit 2 ;;
esac
python "$root/script/validation-manifest.py" --artifacts
printf 'lane_exit=%s\n' "$failed" | tee "$EVIDENCE_DIR/lane-result.txt"
exit "$failed"
