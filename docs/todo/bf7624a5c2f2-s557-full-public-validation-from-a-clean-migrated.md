---
id: bf7624a5c2f2
kind: test
title: S557 full public validation from a clean migrated umbrella checkout
seq: 6
status: done
priority: p1
created: 2026-11-01T09:25:51.180429Z
weave: 1
assignee: s557-manager
sprint: 557
sprint_id: f5ccf563-f5d1-5b94-8be4-9388e51ef86d
sprint_title: 'Bashy v1.0.0 preparation: split private/public development and retire qiangli/dhnt'
closed: 2026-11-04T00:20:40.331775Z
closed_by: s557-manager
---

## Current operator acceptance — supersedes earlier plans (2026-11-03)

The operator narrowed this story to **reference-only migration with no
regression from the frozen baseline**. This section supersedes every earlier
implementation assignment, unchecked repair checklist and pending full-matrix
plan below. Those entries are historical evidence, not active authorization
to modify the interpreter, POSIX Coreutils or Bash# implementation. Preserved
repair branches remain recoverable; broader preexisting issues belong to
followup Sprint 560. Lifecycle acceptance is performed by the manager, not by
manually changing this record's status.

The published public integration reviewed for closure is umbrella
`d99602557b7a3b60c38e0b1d03068fffce39f8c2`. Validation used the pure Stage B
content at `927df5400e89e2041a148c5b5e0fc6f0dec6b6e9`, with Bashy
`5a4bd03ffb28eea556ab2486c6f0f4f51f9da301`. Subsequent integration identities
must be interpreted through the reviewed source-equivalence record, not as
claims that each published commit was separately executed. Protected runtime
sources, dependency versions and original test contracts remain at the frozen
baseline; necessary checkout references are the migration changes. The two
separately validated C metadata/inventory repairs are excluded from this
migration acceptance and retained for post-migration followup.

### Final public outcomes and their limits

- [Run 41705603801](https://github.com/dhnt/umbrella/actions/runs/41705603801):
  Linux and macOS each passed all **86 named Bash 5.3 cases**, matching the
  frozen baseline. Both original module comparison lanes retained every
  previously green test stage: **4 workspace + 6 standalone = 10**, plus
  **2 grammar-preparation stages**. Known Gotreesitter failures and workspace
  Yamux setup failures remain visible; the original module jobs are not
  reported as wholly passing.
- The first Windows attempt ran zero cases because an orchestration helper
  was omitted. Its failure remains recorded. Restoring the exact original
  helper produced [run 41708335900](https://github.com/dhnt/umbrella/actions/runs/41708335900):
  **84 PASS / 2 FAIL / 0 SKIP / 0 TIMEOUT**, with the baseline `glob-test`
  failure and a `printf` timestamp mismatch. The raw 84/86 result is retained;
  it is not rewritten as a green suite or replaced by a later diagnostic.
- A bounded native Windows diagnostic compared the original frozen and pure B
  binaries with the same original `printf` fixture, harness, userland and
  60-second fixture bound. The initial ten pairs yielded frozen **10 PASS**
  and B **9 PASS / 1 FAIL**. A predetermined crossover used the same executable
  path, reversed arm order and fixed launch phases: frozen **8 PASS / 2 FAIL**,
  B **7 PASS / 3 FAIL**, with no skips or timeouts. Every failure added the
  same three diagnostic lines: the external date sample was one second later
  than the stored shell-start timestamp. Frozen occurrence is therefore
  established. These small samples do **not** establish equal failure rates.
  The original Windows failure remains evidence of a preexisting timing
  mechanism, assigned to followup rather than repaired during migration.

The relevant source and dependency comparison is exact. The inspected
`printf` formatting, runner initialization and command entrypoint disassemblies
contain 7,121 identical symbolic rows after removing addresses and relocated
bytes. This is scoped evidence, not whole-binary identity: executable build
paths, debug data and relocations differ. The fleet diagnostic used Windows
binaries cross-built with Go 1.27.2 and isolated locale prerequisites, so it
is not a byte-identical replay of the hosted build.

Acceptance combines these fresh measurements with explicitly reviewed
**unchanged-input evidence reuse** for unaffected baseline contracts. Original
nonverbose package logs do not enumerate every individual passing or skipped
test; no such pass set is invented. Known baseline failures, unavailable
prerequisites and informational measurements retain their original
classification. No assertion, expected output, timeout, oracle or skip was
changed to obtain closure. This is migration acceptance, not an all-tests-pass
claim, official certification, release approval or authorization to resume
historical implementation repairs. Prefer established self-hosted validation
venues for subsequent followup work.

## Historical scope and execution record — superseded

Provide reproducible manual CI validation on public hosted runners for the migrated umbrella, using existing subproject test entrypoints and exact gitlink candidate identities. Cover independent GOWORK=off build resolution plus workspace unit suites and Bashy make test, Bash compatibility, Bash# corpus and relevant public conformance runners. Linux/macOS/Windows native coverage must report real results with explicit platform applicability. Run foreign suites only in existing containment runners. Licensed VSC remains private and separate. No release tags or publishing. Keep all paths/host references public-safe. Manager will dispatch and inspect actual results.

2026-11-01 SDK prerequisite repair: focused run 41333468936 exposed raw
`go mod download` leaving the toolchain module non-executable with `_go.mod`
files. `script/initialize-reviewed-sdk.py` now initializes the exact Go1.27.2
coordinate following `src/cmd/go/internal/toolchain/select.go`: authenticate
bin/go using the public build-toolchains.tsv pin before changing modes, enable
pkg/tool and matching lib helpers before gofmt/bin/go, then copy nested module
files before src/go.mod. Payload bytes and original directory modes are
preserved. The download JSON is retained; bounded SDK `version` and compiler
`-V` checks must match before validation proceeds. Synthetic initialization,
idempotence, byte/mode preservation, hash/coordinate rejection, and symlink
rejection tests passed (3 tests); bash syntax and ShellCheck passed. No full
SDK copy, build, or local suite was run. Hosted Linux/macOS rerun remains the
acceptance requirement; no test exclusions or product SDK policy changes.

2026-11-02 candidate matrix binding: hosted run 41371336485 authenticated the
native candidate and completed Go by Example 255/255, literal-byte transports
60/60, and Go delta 26/26, then stopped because the executable matrix defaulted
to an absent `bin/bash`. The bundle intentionally contains only `bin/bashy`.
After candidate authentication, validation now exports `BASH_ENGINE_BIN` as
the same `BASHY_BIN` for the matrix's existing selector and plain/POSIX checks.
No second binary, shim, rebuilt payload, assertion change, or skip is added.
Shell syntax and a bounded mock of the actual authentication/environment
handoff passed. Full hosted replay remains required; this does not close the
overall corpus or migration gate.

Modernish diagnostic lane now opts into a separate bounded self-test trace
from the producer runner. The original suite command, counters and verdict
remain authoritative and unchanged. The trace has independent setup/run/copy
statuses and per-test files, and is not enabled by full free-POSIX validation.
Run 41380385436 completed initialization/version but terminated the self-test
with SIGALRM before any summary; partial execution counts are unknown.
The added trace is diagnostic evidence, not a passing conformance result.
Shell syntax and diff checks passed; four producer mocks verified opt-out,
success, signal failure and timeout without modifying original evidence.
Hosted trace execution remains pending manager integration and dispatch.

## Consolidated acceptance ownership — 2026-11-02

Operator-directed triage: implementation mistakes, review corrections and failed tests belong to this existing deliverable, not new stories. Superseded child records retain their original scope and evidence. Their decision closure means responsibility transferred here, NOT fixed, passed, waived or feature retirement. Keep this parent open until its acceptance is verified. New stories require genuinely independent scope.

Release constraint: RC tags only, using the existing format. Official v1.0.0 requires completed official POSIX certification and separate explicit operator approval even if every test passes. Formal certification is deferred; the migration still requires its shell-only conformance gate.

Remaining acceptance: verify full native/standalone/workspace, full Bashy and shell, race/confirmation, Bash 5.3, authenticated Bash# corpus, and applicable free-POSIX results against exact candidates. Record skips/applicability and preserved failures; do not equate workflow success or missing tests with a passing suite.

Known actionable blocker: older candidate's Linux TestGoSourceNativeMemberCancellation race fixture fails net import admission requiring cgo (all three repetitions); repair and verify within this parent. Both ordinary shell suites passed on that older candidate, not automatically on later bytes. Current candidate cd91b04 Bash53 workflows are green on all three platforms and free-POSIX workflow is green; retain/check raw target totals before final acceptance. Current full suites remain subject to completed-result review. Candidate preparation success is not artifact approval or corpus completion.

Pre-existing informational limitation: Modernish NONFORKSUBSH fails the same external-parent probe on frozen and current engines. Keep the raw failure and INFO classification; no architectural redesign or blanket pass claim. Previously resolved focused regressions (including fc10/10 on each Unix host) retain their scoped evidence. Final Windows glob/redirection coverage and full corpus still require exact-result reconciliation; do not silently waive historical failures.

### Transferred implementation and verification checklist

Every row retains its original acceptance and evidence in the named source record; verify disposition within this parent before closure. These rows are tasks, not additional stories.

- [ ] `c81387d7f6c1` (bashy #3040): S557 measure strict POSIX profile separately from Bash compatibility. Reconcile existing evidence and any remaining verification.
- [ ] `0f8ecab1247b` (bashy #3036): S557 restore full-gate session and path fixtures. Reconcile existing evidence and any remaining verification.
- [ ] `1bae7aa7aebd` (bashy #3041): S557 repair Desk full-suite timeout without weakening behavioral coverage. Reconcile existing evidence and any remaining verification.
- [ ] `455135314fb4` (bashy #3039): S557 bound native CI stages independently of cumulative compile time. Reconcile existing evidence and any remaining verification.
- [ ] `cebf026837c7` (bashsharp-tests #112): S557 repair literal-byte transport test accounting prerequisite. Reconcile existing evidence and any remaining verification.
- [ ] `4acedd8ee5b9` (bashsharp-tests #111): S557 enable exact migrated candidate in full Bashsharp corpus gate. Reconcile existing evidence and any remaining verification.
- [ ] `da4959013114` (sh #184): S557 preserve compound alias parsing for Modernish test-runner control flow. Reconcile existing evidence and any remaining verification.
- [ ] `efd2bd0ddffd` (sh #182): S557 repair Modernish readonly variable unexport probe. Reconcile existing evidence and any remaining verification.
- [ ] `bc2580329a94` (sh #178): S557 preserve variable-prefix expansion under nounset for Modernish. Reconcile existing evidence and any remaining verification.
- [ ] `7a887d4056ea` (sh #174): S557 repair shell native fixture preparation and race audit coverage. Reconcile existing evidence and any remaining verification.
- [ ] `d59ea3c8b6c7` (sh #175): S557 preserve parse-time aliases in sourced compound commands. Reconcile existing evidence and any remaining verification.
- [ ] `3ea2aafcb341` (sh #166): S557 update shell race gate bounds for the current package inventory. Reconcile existing evidence and any remaining verification.
- [ ] `6988fd06e87a` (sh #179): S557 join replacement signal forwarders after process completion. Reconcile existing evidence and any remaining verification.
- [ ] `de21afd1cbc8` (sh #187): S557 diagnose Windows command-substitution redirection ambiguity. Reconcile existing evidence and any remaining verification.
- [ ] `50c64b10fca7` (sh #177): S557 repair full-shell toolchain fixture and channel timeout evidence. Reconcile existing evidence and any remaining verification.
- [ ] `a554eec72b20` (sh #183): S557 isolate asynchronous process substitution from history reader replay. Reconcile existing evidence and any remaining verification.
- [ ] `4fafab8c629a` (sh #185): S557 avoid repeated alias ancestry scans for ordinary sourced command words. Reconcile existing evidence and any remaining verification.
- [ ] `7b0044a95807` (sh #176): S557 restore Bash fixture fidelity after let shell-word parsing. Reconcile existing evidence and any remaining verification.
- [ ] `f8fcd72802bd` (sh #172): S557 verify strict asynchronous EXIT trap redirection lifetime. Reconcile existing evidence and any remaining verification.
- [ ] `32c55b3b4bb3` (sh #170): S557 bound unset operand scanning across escaped line endings. Reconcile existing evidence and any remaining verification.
- [ ] `74b5b0a013a8` (sh #180): S557 parse parameter expansion as arithmetic operands in sourced conditions. Reconcile existing evidence and any remaining verification.
- [ ] `b7426d360392` (sh #171): S557 verify and correct strict getopts readonly assignment status. Reconcile existing evidence and any remaining verification.
- [ ] `ca1e33f51032` (sh #173): S557 restore Bash let shell-word and redirection parsing for Modernish. Reconcile existing evidence and any remaining verification.
- [ ] `61b1156f9de1` (sh #168): S557 repair interpreter regressions exposed by full migrated shell suite. Reconcile existing evidence and any remaining verification.
- [ ] `aea9087c173c` (sh #169): S557 dispatch explicit EXIT traps in command substitution for modernish initialization. Reconcile existing evidence and any remaining verification.
- [ ] `d952dda0e568` (bonsai #5): S557 restore GraphQL add then exact-person query contract. Reconcile existing evidence and any remaining verification.
- [ ] `b8be36ceabd7` (bonsai #4): S557 synchronize Bonsai database GC shutdown with Close. Reconcile existing evidence and any remaining verification.
- [ ] `4b920a28f726` (bonsai #3): S557 repair GraphQL subscription update delivery timeout. Reconcile existing evidence and any remaining verification.
- [ ] `8ca06fe246d8` (ycode #63): S557 restore portable file and process contracts in native Windows tests. Reconcile existing evidence and any remaining verification.
- [ ] `a724a4808b5f` (ycode #64): S557 isolate native session controls and diagnose Windows latency gate. Reconcile existing evidence and any remaining verification.
- [ ] `d16a4ff5691c` (ycode #65): S557 repair recall time-window fast-path regression. Reconcile existing evidence and any remaining verification.
- [ ] `d56152607dff` (outpost #2764): S557 isolate pairing service unit fixture from host config paths. Reconcile existing evidence and any remaining verification.
- [ ] `0feb99d2fc7c` (yoke #3050): S557 join independent KV session ownership before temporary cleanup. Reconcile existing evidence and any remaining verification.
- [ ] `7bc5d2685915` (yoke #3046): S557 use portable temporary homes in native test entrypoints. Reconcile existing evidence and any remaining verification.
- [ ] `38ba61f3e8f5` (yoke #3051): S557 stabilize semantic Prometheus label assertions. Reconcile existing evidence and any remaining verification.
- [ ] `f15099d20dc3` (yoke #3048): S557 repair native census and chat cleanup ownership. Reconcile existing evidence and any remaining verification.
- [ ] `6848aa300e5f` (yoke #3049): S557 isolate macOS delegate timing and Linux graph fixture environments. Reconcile existing evidence and any remaining verification.

## Historical bounded worker assignment — 2026-11-02 (inactive)

Immediate bounded assignment: repair current shell validation failures, not the entire public matrix. Candidatecd91b04/Sh81f16692; current canonicalShd816fd72 differs bytriage docs. Read /tmp/s557-current-shell-failed.log and /tmp/s557-full64995c0-monitor/linux-review.md. (1) macOS TestBackgroundSelfSignalSurvivesExecReplacement carrier_term/carrier_usr2/carrier_handled_term replacement timeout; identify real semantic/fixturecause, preserve exactsignal assertions/deadlines. (2) raceoracle audit rejects plain buffers interp/virtual_self_signal_test.go108/118; prove ownership/synchronization and choose legitimate fix, no blanketannotation. (3) olderLinux TestGoSourceNativeMemberCancellation rejects net import asrequiringcgo; isolate prerequisite/admissionissue, preserve cancellationassertions. Work only onSh source/tests/racegate directlyneeded. Use isolated Sh worktree from $PUBLIC_ROOT/sh at publishedHEAD, e.g /tmp/s557-claude-shell-round2; do not modify canonical or frozen dhnt. Do not hydrate/build entireumbrella. Short authoredgo tests on the development host limitedGOMAXPROCS2 GOFLAGS=-p=2 GOWORK=off. No fullsuite/container/foreignsuite locally. Report source worktree and baselineprobe within five minutes, commitSHA+focusedgates within thirty minutes or exactblocker. Commits Sprint#557 Story#6 Story-IDbf7624a5c2f2 actualAgent. No newstories, push/merge, deadline/assertionweakening or testskips. Parent remainsopen. Root will independentlyreview/merge andrunhostedmatrix. Preserve failed logs.

All agents: subscription-backed route only; no metered/API fallback. Do not create stories for corrections; append evidence to this parent. Manager checks concrete progress every five minutes, steers and reassigns stalled work.

### 2026-11-03 07:13 UTC — remaining validation and exec repair plan

Mac workspace native41586231575 passed all20 stages. Standalone failed the
embedded source-revision guard; Bashy8f20a0f corrects metadata against unchanged
runtime dependencies and adds a fail-closed generator. Yoke7e051e9 corrects DOM
readiness fixtures and adds a focused20-result hosted gate; no browser pass is
claimed yet. Normal Linux full-Sh41577969558 passed3921 top-level cases; its
broad race phase exceeded60m, with an image callback exceeding its120s context.
The diagnostic lane preserves that context and full-size image. Complete race
sharding must reconcile every discovered case and retain all failures.

An authored Linux probe reproduces runtime epoll corruption when true exec
places shell redirects over runtime descriptors before syscall.Exec allocates.
Plan under this existing parent: isolate the executing thread's descriptor
table, snapshot/stage sources and rollback targets inside that isolated table,
then use a prevalidated allocation-free, nosplit/norace syscall tail. Preserve
same process PID, owned handoff, closed descriptors and CLOEXEC. On failure,
restore the isolated table before resuming Go and retire the locked thread.
Preserve Go's existing exec/thread-creation lock via its published runtime
hooks. Prefer close_range's file-table-only isolation for modern containers;
older kernels may use CLONE_FILES unshare. Denial fails closed, never falls
back to unsafe shared-table mutation. Darwin/Windows/cgo paths remain unchanged.

The proposed pure-Go Linux path preserves current kernel resource limits;
this deliberately differs from Go's startup-soft-limit restoration in ordinary
exec.Cmd. Verify and report this explicitly; shell ulimit setters are cosmetic,
so use actual kernel limits and a native child for evidence. Independent source
review permits bounded testing only. Required before integration: actual Linux
success/rollback/descriptor/signal tests, compiler critical-section audit,
original authored stress replay, and fresh exact-payload licensed493. No
production acceptance, official certification or release is implied.
