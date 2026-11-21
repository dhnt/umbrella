# Release failure ledger

One row per test failure met while preparing a release. Each row has the last
green and first red commit, so a future regression can be bisected from a known
point. A failure is closed only with a recorded cause; venue failures are kept
apart from product and test defects.

A test that passes alone but fails inside a full suite is usually timing:
re-run it 5 times in isolation and record both counts before changing
anything. The full yoke suite surfaced a different such test on almost every
run until the races below were fixed.

How to use it: before treating a red test as new, look it up here by test name.
To bisect, use the green and red commits below with `git bisect run` and a
script that exits 0 (pass), 1 (this test failed) or 125 (did not build). Use
the system git (`/usr/bin/git`): the pure-Go `git` in the bashy shell lacks
some flags (`checkout -q`, `bisect start -q`). An earlier comparison here ran
the same revision every time because of that.

## bashy rc.37 / cloudbox v0.18.75 (2026-11-16 .. 2026-11-17)

### Product and test defects

| Test (repo) | Symptom | Last green → first red | Cause | Class | Fix |
|---|---|---|---|---|---|
| `TestCensusCoversEveryPackage` (yoke `pkg/atlas`) | `pkg/<x> has no atlas census entry` for boundary, nativepath, nfthelper, outpostagent, pagecontrol | `d820b289^` → `d820b289` (2026-10-30, pkg/nfthelper); then `a38244a8`, `8d294b62`, `4bbb57fb`, `2b74a473` added one package each | Packages added without a row in `pkg/atlas/packages.go`. Package-scoped test runs never ran `./pkg/atlas`. | metadata defect | yoke `b01a6445` |
| `TestTypedMCPDbLifecycleRequiresDestroyGrant` (yoke `cmds/db`) | `exit=0 stderr=""` | `6a43f159` (test added 2026-10-17) → `979150de` (bisect run) | Sprint 646 O3 changed the policy answer for privileged effects from an exit-126 denial to the gated pull-route handoff `{state: "gated", effects}`. The call is still refused and never executes. The test kept decoding the old shape. | test defect | yoke `f86d1d7f` |
| `TestVecCollectionsAndItemsBothModes` (yoke `pkg/dbvec`) | `deleted vector still searchable: <hex>a@…,b@…` about 1 run in 16 | flaky since the generated-id put was added; not tied to a dependency revision | `strings.Contains(hits, "a@")` matched a random hex id ending in `a`. Misdiagnosed at first as a bonsai migration-A regression, because two consecutive failures looked deterministic. | test defect (flake) | yoke `b783a91f`; 30/30 runs pass |
| `TestCapacityAuthorizedSSHDispatchVerifiesResult` (yoke `pkg/dag`) | `remote inspection: null registered target unreachable or capacity endpoint unavailable` after about 6 s, only inside the full suite | not tied to a commit: load-dependent; passes 5/5 in isolation | The fixture's remote end re-execs the whole test binary through a shim ssh; under full-suite load that exceeds the client's fixed 5 s observe deadline | test-timing defect | yoke `e0e226eb` (`CapacityClient.ExchangeTimeout`; the fixture allows a minute) |
| `TestTSRemoteIngestRendersPrometheusText` (yoke `pkg/dbts`) | the same series rendered with labels `{path,job}` and `{job,path}` | random, not commit-bound: Go map iteration order | `promLabels` collected label keys from a map and never sorted them | product defect | yoke `b2e671f9` (sorted keys; 20/20 runs pass) |
| `TestAttachedClaimDiesWithParentAndDoesNotLeakFD` (yoke `pkg/policy/coord`) | `strconv.Atoi: parsing "": invalid syntax`, only under full-suite load | load-dependent; 5/5 in isolation | The test waited for the pid file to exist, then read it once; `echo $$ > file` creates the file before writing it | test race | yoke `5c7f1d54` (poll for a complete pid; 10/10 runs pass) |
| `TestE2EInviteASecondAgentMidConversationAndBothReply` (yoke `pkg/meet`) | `TempDir RemoveAll cleanup: unlinkat …/seen: directory not empty`, only under load | load-dependent; 5/5 in isolation | A turn is visible before its async job stops writing; the test returned and TempDir cleanup raced the job | test race | yoke `f3d22fd2` (`address` waits on the job's completion at cleanup) |
| `TestGatewayRunEffectGate/destroy` (yoke `pkg/weave`) | `gated run emitted no approval event`, only under load | load-dependent; 5/5 in isolation | The test waited for the needs-approval state, then read the events once; the approval event is posted after the state is written | test race | yoke `e1741231`; 10/10 runs pass |
| `TestAuditFileCarriesCostFields` (yoke `pkg/broker`) | `audit file: 1 priced, 0 unpriced; want 1 and 1`, only under load | load-dependent; 5/5 in isolation | The audit record is written after the response is sent; the test read the file once, right after the second response | test race | yoke `0b2ced9e` (re-read until both records; 10/10 runs pass) |
| `TestSQLVerbsBothModes` (yoke `cmds/db`) | `TempDir RemoveAll cleanup: unlinkat …/sessions: directory not empty`, only under load | load-dependent; 5/5 in isolation | `db session stop` was answered before the owner wrote its final "ended" record, so whatever followed raced that write (a real `session list` too) | product defect | yoke `9c0598b2` (`stop` waits for "ended"; new `TestSessionStopWaitsForEnded` fails on the old code) |
| `TestSeededBuiltinInternalAndCustomShareOneMachinery` (outpost `internal/agent/svcunit`) | `seeded unit "bashy-mcp" default Enabled=true, want false` | red from the first outpost pin of a yoke containing `514b209f` | yoke `514b209f` (Sprint 646 O0) made `bashy-mcp` default-on, as the gateway sync route needs; outpost's default-on golden was not updated | test defect | outpost `1c01a36` |
| `TestStartupImportPublishesOnlyAfterVerification` (cloudbox `internal/server`, `-tags cloudbox_satellite`) | `unknown table "desktop_…"` | red since `243b8a0` (desktop tables added) | The desktop tables were missing from `export.KnownTables`, so satellite import and restore refused desktop rows (live in v0.18.73) | product defect | cloudbox `52d4d20`, then `9e54738` for the policy table |
| `TestSchemaFingerprintGolden` (cloudbox `internal/db`, `-tags cloudbox_satellite`) | golden `26 …`, binary `27 …` | `670c64b` (G1b raised SchemaRevision, primary golden only) | The satellite golden was not regenerated with the revision bump | test defect | cloudbox `3bf20d3` |
| `TestUndoStepsBackRepeatedly` (cloudbox `internal/desktop`, new) | a second undo re-applied the change the first removed | defect present since the desktop store landed in `243b8a0` | Undo restored `expected-1`, not the revision before the restored one | product defect | cloudbox `b56ad83` (test fails on the old code, passes on the new) |
| `TestServeRoundTrip` (bashy `internal/agentos/session`) | `session never came up`, every in-image run | passes on the dev box (per-user TMPDIR) | The socket went into `os.TempDir()` = `/tmp`, owned by root; `Serve` rightly refuses a socket directory owned by another uid, and the test discarded the error. | test defect | bashy `78708960` |
| `TestProvidersCLIAndMCPDiscovery` (bashy `internal/agentos`) | `provider "claude:plan" is unavailable: vendor CLI is not installed` | passes where the claude CLI is installed | The vendor route is offered only when its CLI is on PATH; the test assumed the host had it. | test defect | bashy `78708960` (stand-in on PATH) |
| `TestFixtureTerminalControl/{timeout,cancel}` (bashy `tools/bash53suite`) | `fixture did not publish pid`, 2 of 2 full in-image runs | passes in isolation | The fixture was stopped after a fixed 100 ms and the test then required its pid files; under full-suite load the fixture shell had not written them yet. | test race | bashy `09c32548` |
| `TestClientReconnectResumesFromOffsetWithoutDuplicates` (yoke `pkg/dagrun/attach`) | hung 10 min in `Stream.Wait`, 1 of 2 in-image runs | load-dependent; first seen in the official image | After a reconnect with the same client id, the server noticed the old socket's break late; its cleanup called `Hub.Detach(clientID)`, which dropped the new attachment, and the new stream ended without a frame. | product defect | yoke `c9057f1e` (`Hub.DetachAttachment`) |
| `TestServerRoutesBandByHeadroomAndStampsRoutedHeader` (yoke `pkg/cligw`) | `usage.jsonl decisions=2 usage=1`, 1 of 4 in-image runs | load-dependent; first seen in the official image | The usage line is written by the audit tail's `onClose`, which runs in its own goroutine after the body closes; closing the test server does not wait for it, and the test read the log once. | test race | yoke `d4cd37be` |
| `TestTheGuardIsRealWithoutReadOnly` (yoke `pkg/meet`) | `an uncontained host must refuse to strip claude's approval gate`, every in-image run | passes on hosts; fails in any container | The test is about an uncontained host but used the real containment probe; inside a container the host is contained and may strip the gate. | test defect | yoke `d4cd37be` (both guard tests set `agentlaunch.Containerized`) |
| `TestRolesForBoard_HolderUUIDAndLegacyName` (yoke `pkg/steward`) | `cannot establish a stable machine identity`, every in-image run | passes on hosts; fails with no `/etc/machine-id` | Open rightly refuses to guess a machine identity; the CLI tests set `BASHY_HOST_ID`, this one did not. | test defect | yoke `d4cd37be` |

The dag capacity fixture (`e0e226eb`) and the quotaobs success path
(`9da4fa3c`) add test seams only: production keeps its 3-5 s exchange
deadlines and its 25 ms journal budget, and only the tests raise them.

Possibly the same as `TestSQLVerbsBothModes` above: one earlier run of yoke
`./cmds/db` failed with the test name not captured (3 later reruns passed).
If a `./cmds/db` failure recurs, capture `go test -v` output first.

### Venue failures (fixed in the venue, never in code)

| Failure | Where | Cause | Remedy |
|---|---|---|---|
| `TestFeed{ComposeSignJS,GroupCrypt,ViewerJS}_CrossCheck` (cloudbox handlers) | first Windows test host, WSL | node v18 has no global `crypto` | use a venue with a newer node, or one where node is absent so the tests skip |
| process-group kill tests: yoke `agentpty` TestParentExitKillsPTYTree, `chat` TestCancelKillsDescendants (+2), `cligw` TestWorkerCancelKillsProcessGroup, `dag` TestDagSignalCancelsFenceProcessGroup | official build image without an init | PID 1 was bashy, which does not reap orphans; killed descendants stayed as zombies and looked alive. Same tests pass with `--init` (PID 1 = podman-init) | `tools/bashy-build/run.sh` passes `--init` (bashy `d0216c56`) |
| yoke `dag` TestCommandFleetRunsCommittedChunks: `--json envelope leaked username "bashy"` | official build image | the image account was named `bashy`, the product's own name, which appears in every envelope; the host-fact probe flagged it | the account is `builder` (bashy `17e5be3d`) |
| bashy `internal/cli` TestVSCInteractiveAutoMonitorSurvivesGroupTTIN: backgrounded child never stopped | official build image with `--init` | podman-init starts its child with SIGTSTP/SIGTTIN/SIGTTOU blocked (SigBlk 0x380000); bashy, like bash, keeps an inherited mask, so a background terminal read got EIO instead of stopping | `run.sh` forks bashy from dash, which starts forked commands with an empty mask (bashy `09632b4b`; an exec in `0d043a45` kept the mask); removed with Sprint 653 R9 |
| Bash 5.3 gate: `symlink external/bash-5.3 … permission denied` | gate with `GO=tools/bashy-build/go.sh` | the fixture fetch ran inside the container with the host checkout path | the gate host fetches the SHA-verified corpus with `FIXTURES_GO="bashy go"` (bashy `09632b4b`) |
| every cloudbox package `[build failed]` with `no space left on device` | second Windows test host, podman machine | `/tmp` is a 3.9 GB tmpfs; the k3s dependency build fills it | set `GOTMPDIR` to a disk directory |
| `internal/api`, `internal/handlers` and `internal/server` do not build | macOS dev box | they import k3s, which builds only on Linux | run them on a Linux venue |

## rc.37 candidate verdict (bashy `7d906572`, tag `v1.0.0-rc.37-dev`)

All runs in the official build image on the gate host
(`bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2`, fresh runs, 2026-11-17):

| Check | Result |
|---|---|
| Self-hosting roll (R1 by previous lock, R2 by R1) | fixed point, bashy sha256 `3452109f…0d0f` |
| yoke short suite (`c9057f1e`) | 189/189 packages |
| bashy Go tests (`bashy dag test`) | pass (results from `611bedc9`; Go sources unchanged to `7d906572`) |
| Bash 5.3 gate, `BASH53_BASHPP=0` and `=1` | 86/86 each, per-fixture evidence written |
| make test script checks: meet-spa-fresh, isolated-lanes, release-qa-lane, build-tag-matrix, startup-linux | pass |
| make test checks that call make: build-fail-closed, bash-container-mode, verify-bashy-scratch | not run in this venue, by operator decision; Makefile removal todo `42d05687` |

## rc.38 candidate verdict (bashy `944f5931`, tag `v1.0.0-rc.38-dev`)

All runs in the official build image on the gate host, fresh, 2026-11-20.
Candidate pins: yoke `0fd24d08`, coreutils `c6569352`, bash `7855c2f0`,
readline `df59d4e2`, outpost `931c696` (tool directive, not linked).
Umbrella candidate commit `e09df316`.

| Check | Result |
|---|---|
| Self-hosting roll (R1 by the rc.37 lock, R2 by R1) | fixed point, bashy sha256 `a452834a…69f0`; R2 image `bashy-build:v1.0.0-rc.38-go1.27.2-367e08b44898` (`sha256:367e08b4…9804`) |
| yoke short suite (`0fd24d08`, submodules hydrated) | 188/189; `pkg/acp TestAskRoundTripsThroughQueue` failed under load only (below) |
| bashy Go tests (`bashy dag test`) | pass |
| Bash 5.3 gate, `BASH53_BASHPP=0` and `=1` | 86/86 each; no NEW, RECOVERED or changed fixture by name against rc.37's evidence. Evidence sha256: mode 0 `edbc60b6…f904`, mode 1 `431bfdaa…48a9` |
| make test script checks: meet-spa-fresh, isolated-lanes, release-qa-lane, build-tag-matrix, startup-linux | pass |

### Defects found while gating rc.38

| Test (repo) | Symptom | Cause | Class | Fix |
|---|---|---|---|---|
| yoke `cmds/all`, `pkg/ollm` (setup failed), `pkg/mplfree TestLinuxEngineSecureJoinIsPermissive` | `missing go.sum entry` for `github.com/bashsharp/bashsharp v0.0.0-20261118040926-59ce327a5e01` | `79fe8f90` (Sprint 575) added the require without its go.sum lines | build metadata defect | yoke `b7167ebe` |
| bashy `TestToolShortcutE2E`: `chat steer agy PING` | `mb: a post needs a sender` | `pkg/chat principalName` read only `BASHY_PRINCIPAL`, `USER` and `LOGNAME`; the build image sets none, and queued steers need a board sender | product gap, exposed by the venue | yoke `4719335d` (falls back to `USERNAME`, the OS user, then `uid-<n>`) |
| bashy `TestToolShortcutE2E`: `agy --no-yolo argv still carries the yolo flag` | `--no-yolo` ignored in a container | containment counted as explicit unsafe acceptance and outranked the flag; operator decision: an explicit `--no-yolo` always wins | product defect | yoke `0fd24d08`, bashy `944f5931` |
| yoke `pkg/broker TestPeerPrincipalEvictsOwnerResidentModels` | `peer turn audited as "owner"`, 1 of 5 runs in isolation | the test read the audit before `finish()` appended the record | test race | yoke `5d888598` |
| yoke `pkg/acp TestAskRoundTripsThroughQueue` | `TempDir RemoveAll cleanup: … directory not empty`, full suite only; 5/5 in isolation | `decideSoon`'s `ask.Decide` goroutine was never joined and could still write into the queue TempDir at cleanup | test race (same family as rc.37's `pkg/meet`) | yoke `3d634294` (test only; after the pinned `0fd24d08`, no shipped code affected) |

### Venue failures (fixed in the venue, never in code)

| Failure | Cause | Remedy |
|---|---|---|
| bashy tests `._*.yaml` subtests and a different rolled binary | the source tarball was made with macOS `tar`, which adds AppleDouble `._*` files; `//go:embed all:` embeds them | `COPYFILE_DISABLE=1`, `--no-xattrs --no-mac-metadata`; the driver asserts zero `._*` files before rolling |
| yoke `cmds/all`, `pkg/ollm`, `pkg/mplfree` (setup failed) after the go.sum fix | the fresh yoke clone had no hydrated submodules (`external/ollama/src`, `external/podman/src`) | the driver hydrates them from the rc.37 tree after checking the submodule commits match |
| Bash gate mode 1 never started: `failed to chown recursively … bashy-build-cache/_data/tmp/…` | podman re-owned the cache volume all parallel runs share while the concurrent bashy test run deleted its temp dirs | mode 1 rerun alone: 86/86, NEW none; gate runs should not share the cache volume with the test runs |
| yoke `cmds/db TestIndependentDocClientsBothModes/persistent` (`hold did not become active`) | known load-only race, seen once on `cac9297e`; 3/3 in isolation; did not recur on `944f5931` | none needed for this candidate |

Build evidence for rc.38 is this local gate (operator decision: the GitHub
release build is triggered but not watched; the build pipeline will be
refactored). Promotion, tier smoke and QA refs wait until after the agy
sprints.

## rc.39 candidate verdict (bashy `732eb770`, tag `v1.0.0-rc.39-dev`)

All runs in the official build image on the gate host, 2026-11-20 .. 2026-11-21.
Candidate pins: yoke `299a502d` (nested modules aligned), coreutils `c6569352`,
bash `7855c2f0`, readline `df59d4e2`, outpost `f066eaf` (tool directive).
The first candidate `33c90247` was gated fresh. `732eb770` adds only the four
test-side fixes below (`_test.go` and `testdata` only; the driver refuses any
other change), so its product inputs are those of `33c90247`. The roll, yoke
suite and Bash 5.3 gate results are reused as unchanged-input evidence;
`bashy dag test` and the leaking pair ran fresh on `732eb770`.

| Check | Result |
|---|---|
| Self-hosting roll (R1 by the rc.38 lock, R2 by R1), `33c90247` | fixed point, bashy sha256 `9e366cfd…971a`; R2 image `bashy-build:v1.0.0-rc.39-go1.27.2-c7e19f271086` (`sha256:c7e19f27…e3a2`) |
| yoke short suite (`299a502d`, submodules hydrated) | 189/189 |
| Bash 5.3 gate, `BASH53_BASHPP=0` and `=1`, `33c90247` | 86/86 each; no NEW, RECOVERED or changed fixture by name against rc.38's evidence. Evidence sha256: mode 0 `365ab01e…f243`, mode 1 `2f059ded…e9b5` |
| make-free script checks (extra-in) | pass |
| bashy Go tests (`bashy dag test`), `33c90247` | 4 failures (below) |
| bashy Go tests (`bashy dag test`), `732eb770`, fresh | pass |
| subreaper + tool-shortcut pair, `-count=3`, `732eb770`, fresh | 3/3 pass (failed every time as a pair on `33c90247`) |

### Defects found while gating rc.39

| Test (repo) | Symptom | Cause | Class | Fix |
|---|---|---|---|---|
| bashy `TestCommonOptionsVocabularyReport` | unreviewed short option `dag -o --output` | the generated-Makefile work added `dag -o` without adding it to the reviewed baseline | test baseline not updated | bashy `3776c50b` |
| bashy `TestSkillHelpGoldens/sprint`, `TestSkillHelpClassicSnapshots/sprint` | golden mismatch | the 2026-11-20 sprint help changes did not regenerate the goldens | test goldens not updated | bashy `3776c50b` (sprint subtests only, diff reviewed line by line) |
| bashy `TestToolShortcutCleanupKillsProcessGroup` | `still alive: grandchild` when run after `TestServiceMonitorReapsOrphansAsSubreaper`; passes alone | the subreaper test sets `PR_SET_CHILD_SUBREAPER` on the test binary and never clears it; later orphans reparent to the test process and stay as unreaped zombies, which `ps -p` reports as alive | test isolation defect | bashy `732eb770` (clears the flag in `t.Cleanup`) |

Build evidence for rc.39 is this local gate. The tag push starts the
tag-triggered `airgap-image` and `conformance` workflows; `release.yml` is
dispatch-only, so nothing is published. rc.38 stays unpromoted.

### rc.39 publication attempt (2026-11-21): automated e2e green, security gate blocks

First run of the publish-only path (local dist → local security receipt →
draft → `release.yml` dispatch).

| Check | Result |
|---|---|
| `bashy dag dist` in the locked rc.37 image | 34 assets, 5th run. Runs 1–4 exceeded the 300-second budget on cold per-target build caches (51 → 67 → 82 stages → packaging); run 1 of the driver also lost its container to SIGHUP when the launching ssh session closed (venue: launch detached with `setsid`) |
| Hello World shaping smoke on the dist `linux/amd64` bashy (`134f1a63…`) | 27/27 including both browser checkpoints; regression (`SHAPING_SMOKE_BREAK=greeting`) fails as required. First try failed at verify because the harness named the candidate `bashy-bin` while the verifier execs `bashy` from PATH (venue) |
| cloudbox desktop-journey (`E2E_LOCAL=1`, bashy `4f0ce3d3` = tag + one docs commit) | PASS. Venue note: run the script under a host bash; bashy's built-in pure-Go `git` cannot serve its pathspec `git status` |
| local release gate: license | pass, 388 modules |
| local release gate: govulncheck (bashy, outpost, yoke; yoke needs its ollama/podman submodule sources hydrated) | **FAIL**: reachable advisories. stdlib GO-2026-6809 (x509, fixed go1.27.3) and GO-2026-6859 (net/http, fixed go1.27.4) on the go1.27.2 toolchain; module advisories in golang.org/x/net, x/crypto, grpc, excelize, klauspost/compress, otel exporters, quic-go, pion, moby/buildkit, runc, fulcio, frp |

Class: new advisories against the pinned toolchain and dependencies (not an
rc.39 code regression). The gate has no exception path; publication waits
for an operator decision.

### rc.39 publication stopped (2026-11-21, operator decision)

`v1.0.0-rc.39-dev` was moved (operator: rc.39 is not a formal release) to
bashy `7ddc31c9`, which adds the logged vulnerability override (Sprint 656
story d91599c2). On `7ddc31c9`: dist 34 assets; shaping smoke 27/27 on the dist
`linux/amd64` bytes with the regression failing as required; the override
recorded the reachable ids. The receipt step then failed with `KeyError:
'GoMod'`: `local-release-evidence.py collect` requires a `go.mod` digest for
every module in `go list -m all`, and about 380 modules per scope are never
downloaded by a build (bashy 383/1068, outpost 276/786, yoke 369/895). First
time this step ran. Class: release tooling defect. Publication is deferred
to the release-pipeline work in Sprint 677; no tooling fix in this attempt.
