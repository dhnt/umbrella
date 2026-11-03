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
# Full Sh enumerates moreinterp and invokes dockexec; full Bashy runs nested
# desk modules as independent applications. Native quick tests retain workspace
# coverage; these full release contracts use standalone module resolution.
if [ "$VALIDATION_LANE" = shell-full ] || [ "$VALIDATION_LANE" = shell-race ] || [ "$VALIDATION_LANE" = shell-confirm ] || [ "$VALIDATION_LANE" = shell-broad-race ] || [ "$VALIDATION_LANE" = shell-repairs ] || [ "$VALIDATION_LANE" = shell-race-image ] || [ "$VALIDATION_LANE" = bashy-full ] || [ "$VALIDATION_LANE" = bashy-diagnostics ]; then
  export DEPENDENCY_MODE=standalone
fi
if [ "$DEPENDENCY_MODE" = standalone ]; then
  export GOWORK=off
elif [ "$VALIDATION_LANE" = candidate-prepare ]; then
  # Keep the artifact's reviewed build recipe explicit.
  export GOWORK="$root/go.work"
else
  # Go discovers this workspace from each sibling's directory. Exporting an
  # absolute GOWORK also forces unrelated temporary modules created by tests
  # into this workspace, breaking their independent module contracts.
  unset GOWORK
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

# Preserve the frozen Yoke CI build tags; missing native prerequisites are
# measured as failures, never bypassed by selecting a different implementation.
# Invoked by run() in its subshell.
# shellcheck disable=SC2329
yoke_native() { "$@"; }

# Frozen baseline: do not inject later SDK/oracle provisioners or change tests.
# The original scripts own their oracle selection and prerequisite failures.

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
  if [ "$RUNNER_OS" = Windows ]; then
    check bashy-build bashy go build ./cmd/bash ./cmd/sh ./cmd/bashy
    check bashy-vet bashy go vet ./cmd/bash ./cmd/sh ./cmd/bashy ./internal/agentos
  else
    check bashy-build bashy go build ./cmd/bash ./cmd/sh ./cmd/bashy ./internal/...
    check bashy-vet bashy go vet ./cmd/bash ./cmd/sh ./cmd/bashy ./internal/...
  fi
  if [ "$RUNNER_OS" = Windows ]; then
    check bashy-cli-portable bashy go test -count=1 -run '^TestStrictPosixEngagedByArgv0Sh$' ./internal/cli
    check bashy-agentos bashy go test -count=1 -timeout 5m ./internal/agentos
    check bash53-runner bashy go test -count=1 -timeout 5m ./tools/bash53suite
  else
    check bashy-native bashy pty go test -count=1 -timeout 10m ./internal/cli ./internal/agentos
  fi
  check bashy-source-route bashy go test -count=1 -timeout 5m -run '^TestSourceRoute$' ./cmd/bashy
  check bashy-e2e bashy go test -count=1 -timeout 8m -tags e2e -run '^(TestE2EAllListedCommandsDispatch|TestE2ERegisteredAppFlow|TestE2ECustomLauncher)$' ./internal/agentos
  check coreutils-vet coreutils go vet ./...
  check yoke-vet yoke yoke_native bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v /external/); if [ "$RUNNER_OS" = Windows ]; then pkgs=$(printf "%s\n" "$pkgs" | grep -vE "/pkg/weave$"); fi; go vet $pkgs github.com/qiangli/yoke/external/gotoolchain github.com/qiangli/yoke/external/act github.com/qiangli/yoke/external/gh'
  if [ "$RUNNER_OS" = Windows ]; then
    check coreutils-compile coreutils go test -run '^$' ./...
    check coreutils-owned-child coreutils bash -euo pipefail -c 'go test ./tool -run "^TestOwnedExecLargeArgumentsAndEnvironment$" -count=1 && go build -o coreutils-owned-proof.exe ./cmd/coreutils && python scripts/owned-exec-windows-proof.py coreutils-owned-proof.exe'
    check yoke-compile yoke yoke_native bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v /external/ | grep -vE "/pkg/weave$"); go test -run "^$" $pkgs'
    check yoke-resources yoke go test -count=1 -timeout 3m ./pkg/resources -run 'Test(CollectLiveHost|CollectSingleSample|HostObservation|ResourceAlert|ResourcesObservationChild)'
    check yoke-budget yoke go test -count=1 -timeout 3m ./pkg/llmbudget
    check yoke-capacity yoke bash -euo pipefail -c 'go test ./pkg/dag -list "^TestCapacity(Executable|UnsupportedPlatforms)" > "$EVIDENCE_DIR/windows-capacity-tests.txt"; grep -Fx TestCapacityExecutablePlatformMode "$EVIDENCE_DIR/windows-capacity-tests.txt"; grep -Fx TestCapacityUnsupportedPlatformsNeverAdvertiseGuardedExecution "$EVIDENCE_DIR/windows-capacity-tests.txt"; go test -count=1 -timeout 3m ./pkg/dag -run "^TestCapacity(Executable|UnsupportedPlatforms)"'
    check sh-build sh go build ./...
    check sh-moreinterp-build sh/moreinterp env GOWORK=off go build ./...
    check outpost-build outpost go build -tags fb_archives ./...
  else
    check coreutils-ratchet coreutils scripts/ci-test-gate.sh
    check yoke-ratchet yoke yoke_native scripts/ci-test-gate.sh
    check sh-quick sh env 'GOFLAGS=-p=2 -tags=netgo' make test-quick
    check sh-moreinterp sh/moreinterp env GOWORK=off go test -short -count=1 -timeout 10m ./...
    check outpost-headless outpost bash -euo pipefail -c 'pkgs=$(go list ./... | grep -v "/internal/agent/shell$"); go test -tags fb_archives -short -count=1 -timeout 10m $pkgs'
    check outpost-pty outpost pty go test -tags fb_archives -count=1 -timeout 10m ./internal/agent/shell/...
  fi
  for module in bashsharp bonsai gfy nadir ycode; do
    check "$module-unit" "$module" go test -short -count=1 -timeout 10m ./...
  done
  check provider-vet yoke/pkg/provider env GOWORK=off go vet ./...
  check provider-unit yoke/pkg/provider env GOWORK=off go test -count=1 ./...
  if [ "$RUNNER_OS" != Windows ]; then
    check yoke-lifecycle yoke go test -json ./pkg/chat ./pkg/foreman -run 'Test(Cancel|HungChild|KillProcessTree|ServeControl|ControlStop|ApplyCancelled)' -count=10 -timeout 5m
    check yoke-web-e2e yoke go test ./pkg/webconsole -tags e2e -count=1 -timeout 10m
  fi
  if [ "$RUNNER_OS" = Linux ]; then
    check yoke-dom yoke go test ./pkg/webconsole -tags verifydom -count=1 -timeout 15m
    check coreutils-format coreutils scripts/fmtcheck.sh
    check yoke-format yoke scripts/fmtcheck.sh
    check bashy-format bashy scripts/fmtcheck.sh
    check sh-full-vet sh go vet -tags full ./...
  fi
  check sh-vet sh go vet ./...
  check ycode-ci ycode go test -short -count=1 -timeout 120s ./internal/eval/contract/... ./internal/features/...
  check bashy-release-qa bashy scripts/test-release-qa-lane.sh
  check bashy-permissive bashy scripts/verify-permissive-closure.sh
  if [ "$RUNNER_OS" = Linux ]; then
    check bashy-release-bar bashy python3 scripts/test-release-bar.py
    check bashy-scratch-policy bashy python3 scripts/test-bashy-scratch-release.py
    check bashy-build-failures bashy scripts/test-build-fail-closed.sh
  fi
  if [ "$RUNNER_OS" != Windows ]; then check bashy-release-evidence bashy scripts/test-dks-release-evidence.sh; fi
  ;;
module-tests)
  check grammar-fixtures . python script/provision-grammar-fixtures.py gotreesitter
  printf '%s\n' 'Additional public module suites on Linux. Other platforms are not measured by this lane; the native job covers its explicitly listed portable product contracts.' > "$EVIDENCE_DIR/coverage.md"
  for module in agent-bench appstore filebrowser gotreesitter readline yamux; do
    check "$module-unit" "$module" go test -count=1 ./...
  done
  check yamux-v5-unit yamux/v5 go test -count=1 ./...
  ;;
bashy-full)
  printf '%s\n' 'Full Bashy release gate uses standalone module resolution (GOWORK=off), including nested desk applications. Native jobs retain workspace coverage. Remote-install fixtures use the locally built candidate on PATH.' > "$EVIDENCE_DIR/coverage.md"
  check bashy-product bashy bash -euo pipefail -c 'mkdir -p bin; scripts/go-product.sh build -o bin/bashy ./cmd/bashy'
  export PATH="$root/bashy/bin:$PATH"
  # Desk provisions and verifies real isolated applications. Keep its existing
  # package deadline and subtest parallelism, but avoid competing package jobs.
  if ! run make-test bashy pty make test; then
    failed=1
    # Preserve the failed original Make verdict; still measure the exact final
    # command if a prerequisite stopped Make before it could execute it.
    check baseline-package-tests bashy pty go test ./...
  fi
  ;;
shell-full)
  printf '%s\n' 'Frozen original full suite: every original test/example/fuzz seed, original deadlines. Separate race/confirm jobs cannot be suppressed by this result.' > "$EVIDENCE_DIR/coverage.md"
  check sh-full sh env 'GOFLAGS=-p=2 -tags=netgo,full' make test-full
  ;;
shell-race)
  check sh-race sh env 'GOFLAGS=-p=2 -tags=netgo,full' make bashpp-race-gate
  ;;
shell-broad-race)
  printf '%s\n' 'Independent execution of the original broad-race command. Does not replace or waive the original lifecycle/discovery gate.' > "$EVIDENCE_DIR/coverage.md"
  check sh-broad-race sh env 'GOFLAGS=-p=2 -tags=netgo,full' go test -race -timeout=60m ./... -skip 'TestRunnerRunConfirm|TestParseConfirm'
  ;;
shell-confirm)
  check sh-confirm sh bash -euo pipefail -c 'go install mvdan.cc/dockexec@latest && CGO_ENABLED=0 GOFLAGS="-p=2 -tags=netgo,full" go test -run TestRunnerRunConfirm -exec "dockexec bash:5.2" ./interp'
  ;;

bash53)
  export BASH53_DEBUG_DIR="$EVIDENCE_DIR/bash53-diffs"
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
*) echo "unknown validation lane: $VALIDATION_LANE" >&2; exit 2 ;;
esac
python "$root/script/validation-manifest.py" --artifacts
printf 'lane_exit=%s\n' "$failed" | tee "$EVIDENCE_DIR/lane-result.txt"
exit "$failed"
