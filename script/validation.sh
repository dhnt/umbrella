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
if [ "$VALIDATION_LANE" = shell-full ] || [ "$VALIDATION_LANE" = shell-repairs ] || [ "$VALIDATION_LANE" = shell-race-image ] || [ "$VALIDATION_LANE" = bashy-full ] || [ "$VALIDATION_LANE" = bashy-diagnostics ]; then
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

# Match yoke/scripts/embed-podman.sh: desktop platforms use Podman's
# supported remote client graph, including the pure-Go image signature backend.
# Invoked by run() in its subshell.
# shellcheck disable=SC2329
yoke_native() {
  if [ "$RUNNER_OS" = Windows ] || [ "$RUNNER_OS" = macOS ]; then
    env GOFLAGS="${GOFLAGS:-} -tags=remote,exclude_graphdriver_btrfs,containers_image_openpgp" "$@"
  else
    "$@"
  fi
}

# The trimpath and replacement-tool fixtures intentionally hide or mutate
# GOROOT. Their independent SDK must exist at the module-cache path authenticated
# by sh's reviewed toolchain table, not merely in setup-go's installation.
if [ "$VALIDATION_LANE" = shell-full ] || [ "$VALIDATION_LANE" = shell-repairs ] || [ "$VALIDATION_LANE" = shell-race-image ]; then
  run shell-reviewed-sdk . python script/initialize-reviewed-sdk.py "$EVIDENCE_DIR"
fi

case "$VALIDATION_LANE" in
native-repairs)
  printf '%s\n' 'Focused regression evidence only. Full native lanes remain required.' > "$EVIDENCE_DIR/coverage.md"
  check nadir-rotation nadir go test -race -count=1 -timeout 3m ./internal/store/jsonl ./internal/logmaint
  check sh-redirect-capture sh bash -euo pipefail -c 'go test -list "^TestCommandSubstitutionRedirectCapture$" ./interp > "$EVIDENCE_DIR/sh-redirect-tests.txt"; grep -Fx TestCommandSubstitutionRedirectCapture "$EVIDENCE_DIR/sh-redirect-tests.txt"; go test -count=1 -timeout 60s -run "^TestCommandSubstitutionRedirectCapture$" ./interp'
  if [ "$RUNNER_OS" != Windows ]; then
    check bashy-orphan-lifecycle bashy go test -race -count=3 -timeout 90s -run '^Test(Reclaim|ProcStartTime|ProcStatRejectsMalformed|ProcGroupIdentities|ProcessProviderOwnership|CapturedOrphanEscalation|ServiceMonitorReclaimsOrphanOfHardKilledMonitor)' ./internal/agentos
    check sh-fc-editor sh bash -euo pipefail -c 'go test -list "^TestFcS88EditorSessionThroughInteractivePTY$" ./interactive > "$EVIDENCE_DIR/sh-fc-tests.txt"; grep -Fx TestFcS88EditorSessionThroughInteractivePTY "$EVIDENCE_DIR/sh-fc-tests.txt"; go test -v -count=10 -timeout 120s -run "^TestFcS88EditorSessionThroughInteractivePTY$" ./interactive'
    check ycode-pty-steering ycode go test -race -count=3 -timeout 90s -run '^TestTUIOverPTY$' ./pkg/ycodecli
  fi
  check bonsai-import bonsai go test -count=1 -timeout 3m -run '^TestFeature(ImportStreamProducerErrors|ExportImportRoundtrip)$' ./pkg/bonsai
  check bonsai-fixtures bonsai go test -count=1 -timeout 3m -run 'TestLogWriter|TestFindDataFiles|TestInit' ./x
  check bonsai-schema bonsai go test -run '^$' ./schema
  check ycode-unattended ycode env CI=true go test -count=1 -timeout 1m ./internal/runtime/unattended
  check ycode-shared-session ycode go test -count=1 -timeout 3m -run '^TestWebAndTUIShareSessions$' ./pkg/ycodecli
  check ycode-session-isolation ycode go test -count=1 -timeout 3m -run '^(TestYAMLCLISessionGroupAndResume|TestYAMLCLITerminalSessionPointer|TestDeclaredSessionControlsExecuteAndDryRun|TestSessionSayAdmitsTextToTheCompiledSteeringQueue)$' ./pkg/ycodecli
  check ycode-memory-latency ycode go test -v -count=1 -timeout 3m -run '^(TestStore.*|TestCompetitive_LatencyComparison)$' ./pkg/memex/memory
  ;;
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
bashy-diagnostics)
  printf '%s\n' 'Focused Desk package diagnostics with the unchanged 10-minute package deadline and all fork/verify/activate/undo assertions. This does not replace the full Bashy release gate.' > "$EVIDENCE_DIR/coverage.md"
  run bashy-product bashy bash -euo pipefail -c 'mkdir -p bin; scripts/go-product.sh build -o bin/bashy ./cmd/bashy'
  export PATH="$root/bashy/bin:$PATH"
  check desk-package bashy pty go test -v -count=1 -timeout 10m ./examples/desk
  ;;
bashy-full)
  printf '%s\n' 'Full Bashy release gate uses standalone module resolution (GOWORK=off), including nested desk applications. Native jobs retain workspace coverage. Remote-install fixtures use the locally built candidate on PATH.' > "$EVIDENCE_DIR/coverage.md"
  run bashy-product bashy bash -euo pipefail -c 'mkdir -p bin; scripts/go-product.sh build -o bin/bashy ./cmd/bashy'
  export PATH="$root/bashy/bin:$PATH"
  # Desk provisions and verifies real isolated applications. Keep its existing
  # package deadline and subtest parallelism, but avoid competing package jobs.
  check make-test bashy pty env GOFLAGS="${GOFLAGS:-} -p=1" make test
  ;;
fc-diagnostics)
  check sh-fc-editor sh bash -euo pipefail -c 'go test -list "^TestFcS88EditorSessionThroughInteractivePTY$" ./interactive > "$EVIDENCE_DIR/sh-fc-tests.txt"; grep -Fx TestFcS88EditorSessionThroughInteractivePTY "$EVIDENCE_DIR/sh-fc-tests.txt"; go test -v -count=10 -timeout 120s -run "^TestFcS88EditorSessionThroughInteractivePTY$" ./interactive'
  printf '%s\n' 'Focused interactive fc regression with explicit discovery and ten unchanged executions. No full-suite claim.' > "$EVIDENCE_DIR/coverage.md"
  ;;
shell-repairs)
  # Measure this timing-sensitive test before the concurrent multi-package
  # selection. Keep its original ratio assertion and retain profiles even on
  # failure, so CPU/GC costs can be distinguished from competing package work.
  check spelling-scaling-profile sh env 'GOFLAGS=-p=2 -tags=netgo,full' go test -v -count=1 -timeout 60s -run '^TestSpellingShadowParseScaling$' -cpuprofile "$EVIDENCE_DIR/spelling.cpu" -memprofile "$EVIDENCE_DIR/spelling.mem" -o "$EVIDENCE_DIR/spelling.test" ./gosource
  printf '%s\n' 'Focused rerun of the seventeen observed Linux/macOS shell failures plus command-substitution EXIT-trap and unset-scanner guards. Full discovery and race gates remain separate requirements.' > "$EVIDENCE_DIR/coverage.md"
  check formatter-flags sh go test -count=1 -timeout 3m ./cmd/shfmt -run '^TestScript$/^flags$'
  check pragma-sdk sh go test -count=1 -timeout 3m ./lower -run '^TestGoSourcePragmaPosition$'
  check runtime-diagnostics sh env 'GOFLAGS=-p=2 -tags=netgo,full' go test -count=1 -timeout 3m ./interp -run '^(Example|TestPhaseDiagnostic.*|TestPrefix.*|TestLetExpandedArgumentsFidelity)$'
  check unset-regressions sh env 'GOFLAGS=-p=2 -tags=netgo,full' go test -count=1 -timeout 3m ./interp -run '^(TestScanUnsetOperandSourcesBoundaries|TestUnsetContinuedOperands|TestUnsetOperandSourcesDoesNotCopyScriptTail)$'
  # Timing assertions must not compete with another package's interpreter.
  # Keep every selected package/test and its existing deadlines.
  check shell-regressions sh env 'GOFLAGS=-p=1 -tags=netgo,full' go test -count=1 -timeout 20m ./gosource ./interp ./lower -run '^(TestMappedTypeNameKnownDifference|TestBashPPGoIdentityWithoutRuntimeGOROOT|TestGoSourceS281SelfReexecReplacementToolIsolation|TestGoTypesParserCheckNativeEquivalence|TestGoSourceS319UnsafeSizeofRuntimeUintptrArithmetic|TestGoSourceS319UnsafePointerAggregateValues|TestS374ImportedSliceHeaderLiteralInShortDeclaration|TestGoSourceBridgeSliceRetainedRefusal|TestGoSourceBridgeReflectRefusals|TestGoSourceLaunchBodilessCalleesThreeModes|TestGoSourceUnsafeSliceViewAllocator|TestGoSourceUnsafeSliceViewBytes|TestGoSourceUnsafeSliceViewRefusals|TestGoSourceNestedDirectionalChannel|TestBashPPImportBridgeDoesNotContaminatePackage|TestS243OriginalChannelDomainRegressions|TestSelectorResolutionScales|TestSpellingShadowParseScaling|TestConcurrencyLeakIdentity|TestCommandSubstitutionExitTrap(|Cancellation|Panic))$'
  ;;
shell-race-image)
  printf '%s\n' 'Diagnostic only: original full-size image callback and unchanged 120s Runner context, race instrumentation, isolated process. This is not complete broad-race coverage.' > "$EVIDENCE_DIR/coverage.md"
  check image-race-prepare sh bash scripts/prepare-test-oracle.sh
  check image-race-discovery sh env 'GOFLAGS=-p=2 -tags=netgo,full' bash -euo pipefail -c 'go test -race -list "^TestGoSourceImageEncodeCallbacks$" ./interp > "$EVIDENCE_DIR/image-race-discovery.log"; grep -Fx TestGoSourceImageEncodeCallbacks "$EVIDENCE_DIR/image-race-discovery.log"'
  check image-race sh env 'GOFLAGS=-p=2 -tags=netgo,full' go test -race -v -count=1 -timeout 3m -run '^TestGoSourceImageEncodeCallbacks$' -cpuprofile "$EVIDENCE_DIR/image-race.cpu" -memprofile "$EVIDENCE_DIR/image-race.mem" -o "$EVIDENCE_DIR/image-race.test" ./interp
  ;;
shell-full)
  printf '%s\n' 'Full Sh release suite, nested moreinterp, race and confirm gates use standalone module resolution (GOWORK=off). Workspace quick coverage remains in the native lane. No packages or tests excluded.' > "$EVIDENCE_DIR/coverage.md"
  check sh-full sh env 'GOFLAGS=-p=2 -tags=netgo,full' make test-full
  if [ "$RUNNER_OS" = Linux ]; then
    check sh-race sh make bashpp-race-gate
    check sh-confirm sh bash -euo pipefail -c 'go install mvdan.cc/dockexec@latest && CGO_ENABLED=0 go test -run TestRunnerRunConfirm -exec "dockexec bash:5.2" ./interp'
  fi
  ;;
bash53-redir-diagnostics)
  export BASH53_DEBUG_DIR="$EVIDENCE_DIR/bash53-diffs"
  run bash53-source . python script/provision-conformance-fixtures.py bash53 bashy
  check windows-runner bashy go test -count=1 -timeout 5m ./tools/bash53suite
  # Build once through the existing Windows measurement contract. Its raw
  # selected-fixture verdict remains independent of subsequent diagnostics.
  run windows-redir-measurement bashy env TESTS=redir scripts/ci-bash53-windows.sh
  run redir-binary-identity bashy bash -euo pipefail -c 'sha256sum bin/bash.exe bin/yoke.exe bin/bash53suite.exe; go version -m bin/bash.exe; go version -m bin/yoke.exe'
  check windows-redir-probes bashy bin/bash53suite.exe -tests-dir external/bash-5.3/tests -bash bin/bash.exe -userland bin/yoke.exe -redir-probe-dir "$EVIDENCE_DIR/redir-probes"
  printf '%s\n' 'One unchanged Windows redir fixture measurement plus separately bounded CLI diagnostics against the same binaries. Not a full Bash 5.3 or subfixture acceptance claim.' > "$EVIDENCE_DIR/coverage.md"
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
strict-posix-diagnostics)
  run bashy-build bashy make build
  export PATH="$root/bashy/bin:$PATH" BASHY="$root/bashy/bin/bashy"
  export OCI="$root/script/validation-oci.sh"
  run free-suite-sources . python script/provision-conformance-fixtures.py free-posix bashy
  check yash-strict bashy env YASH_PROFILE=strict POSIX_SUITE_EVIDENCE="$EVIDENCE_DIR/yash-strict" scripts/yash-posix-suite.sh
  printf '%s\n' 'Separate public cmd/sh strict-profile Yash measurement. Original Bash compatibility results remain separate; this is not licensed certification.' > "$EVIDENCE_DIR/coverage.md"
  ;;
modernish-diagnostics)
  export OCI="$root/script/validation-oci.sh"
  run free-suite-sources . python script/provision-conformance-fixtures.py free-posix bashy
  check modernish bashy env MODERNISH_SELFTEST_TRACE=1 POSIX_SUITE_EVIDENCE="$EVIDENCE_DIR/modernish" scripts/modernish-suite.sh
  printf '%s\n' 'Modernish initialization and separate bounded self-test traces only, with original suite verdicts retained. This is not full free-POSIX validation or certification.' > "$EVIDENCE_DIR/coverage.md"
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
tour)
  export SH_ROOT="$root/sh" BASHY_ROOT="$root/bashy"
  export BASHY_BIN="$root/bashy/bin/bashy"
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
  export BASHPP_BIN="$BASHY_BIN" TOUR_CANDIDATE_MANIFEST="$GBE_CANDIDATE"
  export TOUR_EXECUTOR_RESULTS="$EVIDENCE_DIR/tour/results.jsonl"
  export TOUR_EXECUTOR_EVIDENCE="$EVIDENCE_DIR/tour/raw"
  mkdir -p "$EVIDENCE_DIR/tour"
  unset TOUR_ONLY TOUR_INVENTORY TOUR_CORPUS_ROOT TOUR_ORACLE_REPEATS TOUR_STEP_TIMEOUT
  check tour-executor bashsharp-tests env GOWORK=off bash tools/tour/run-executor.sh
  check tour-verdict bashsharp-tests env GOWORK=off bash tools/tour/validate-executor.sh
  printf '%s\n' 'Complete existing Tour executor: 97 sources in all three modes, unchanged oracle repetitions and per-stage deadlines. Historical sealed evidence is not this replay.' > "$EVIDENCE_DIR/coverage.md"
  ;;
bashsharp)
  export SH_ROOT="$root/sh" BASHY_ROOT="$root/bashy"
  # The full corpus includes a GNU Bash 5.3 start-site/POSIX oracle.
  # Use the existing checksum-verified reference provisioner on hosted Linux.
  run bash53-oracle sh bash -euo pipefail -c '
    bash scripts/prepare-bash-reference.sh > "$EVIDENCE_DIR/bash53-oracle-path.txt"
    oracle=$(cat "$EVIDENCE_DIR/bash53-oracle-path.txt")
    test -x "$oracle"
    "$oracle" --version
    sha256sum "$oracle" > "$EVIDENCE_DIR/bash53-oracle-sha256.txt"
  '
  BASH53=$(cat "$EVIDENCE_DIR/bash53-oracle-path.txt")
  export BASH53
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
  # Matrix engine and front-door checks use the same authenticated payload.
  # The native candidate bundle contains bin/bashy, not a second bin/bash build.
  export BASH_ENGINE_BIN="$BASHY_BIN"
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
