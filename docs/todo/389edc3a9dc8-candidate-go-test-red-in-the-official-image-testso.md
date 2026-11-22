---
id: 389edc3a9dc8
kind: bug
title: 'Candidate ''go test ./...'' red in the official image: TestSourceRoute GOROOT, /var/cache/bashy permission, ACP 120 s deadlines, internal/agentos 10 m timeout'
seq: 627
status: done
priority: p0
labels:
    - bashy
    - gate
    - release
created: 2026-11-22T16:00:50.197077Z
assignee: claude-fable5.1
sprint: 692
closed: 2026-11-22T16:49:39.163521Z
closed_by: claude-fable5.1
---

Candidate gate leg 2 diagnostic (umbrella 8b8db523f, docs/sprint-677-integration-evidence.md): candidate go test ./... in the official image rc.40-go1.27.4 on lane 2 (8 CPU / 7 GB): 26 ok, 2 FAIL (cmd/bashy 464 s, internal/agentos 600 s panic timeout). Names verbatim: (1) TestSourceRoute/* (7 subtests): 'bashy: resolve Go toolchain: mkdir /var/cache/bashy/bin/go/1.27.2: permission denied' AND the known GOROOT product bug bashy todo 54a66781 (managed toolchain child keeps an inherited GOROOT); (2) TestRepairHermeticStrippedPathRunsThroughBashyRuntime: same 'mkdir /var/cache/bashy/bin/go/1.27.2: permission denied'; (3) TestACPHelpIsHeraldACPHelpByteForByte and TestACPProcessLevelInitializeSessionPrompt: context deadline exceeded at ~121 s (cold yoke/chat adapter build under caps), plus an embed error from the module cache: 'embed baseline/adapters/docker-ps.yaml: open .../yoke@.../pkg/fleet/baseline/adapters/docker-ps.yaml: no such file or directory' (check whether the yoke module zip at 908e590c really lacks pkg/fleet/baseline/adapters/docker-ps.yaml - a .gitignore or module-zip exclusion would be a PRODUCT bug for every GOWORK=off consumer); (4) internal/agentos: 'panic: test timed out after 10m0s' with no individual FAIL (TestPromotionStatusLineUnconfigured among the running tests). Owner muse (knows the lane). FOR EACH: root cause with class (venue/test/product) recorded here, then fix where the cause lives: the /var/cache/bashy path is the managed-toolchain cache root - a test must point it at a writable TempDir (or the product must fall back to the user cache when /var/cache is not writable: decide from the code, smallest change); GOROOT per 54a66781 (pin GOROOT to the managed toolchain in the child env - yoke/external/gotoolchain or bashy side, NOT the frozen bash engine unless unavoidable); ACP tests warm the chat adapter once (TestMain) or budget the cold build explicitly; the dag 'test' target passes an explicit -timeout large enough for internal/agentos under 8 CPU (or splits the package run) - a test-infra change, never a skip. Verify on the claimed gate-host lane 2 in the official image with targeted -run per fixed test (nohup + poll). TEST RULE (operator 2026-11-22): build + smallest targeted unit tests only, then submit; the re-run of the red gate legs is the conductor's. Root cause recorded on this story BEFORE the fix. Start on current origin main of each repo touched; Sprint/Story/Story-ID + Agent trailers; submodule commit first (do not push), the conductor merges and bumps pins. Long remote commands: nohup + poll, never block one command for more than a minute.

## Root causes (recorded BEFORE fix, 2026-11-22, muse)

Gate: candidate `go test ./...`, official image rc.40-go1.27.4, lane 2 (8 CPU/7 GB), bashy 9dd37bb2, yoke 908e590c. Both submodule HEADs verified == origin/main at start.

1. TestSourceRoute/* (7) + TestRepairHermeticStrippedPathRunsThroughBashyRuntime — `mkdir /var/cache/bashy/bin/go/1.27.2: permission denied`.
   Class: PRODUCT (stale pin) exposed by venue. yoke/external/gotoolchain DefaultVersion=1.27.2, but product go.mod toolchain and the official image are 1.27.4; the image pre-seeds only `/var/cache/bashy/bin/go/1.27.4/go -> /usr/local/go` (tools/bashy-build/Containerfile) and `/var/cache/bashy/bin` itself is root-owned (only the 1.27.4 subdir is builder-owned). bashy/internal/agentos island resolver calls gotoolchain.Ensure(ctx,"") ignoring $BASHY_GO_VERSION (the `bashy go` front door honors it), so it asks binmgr for 1.27.2, misses the pre-seeded cache, and MkdirAll fails. TestRepairHermetic compounds it: repairHermeticEnv preserves BASHY_BIN_CACHE but drops BASHY_GO_VERSION, so its `bashy go` wrapper also defaults to 1.27.2.
   Fix where it lives (yoke gotoolchain + bashy test env): DefaultVersion 1.27.2 -> 1.27.4; Ensure("") honors $BASHY_GO_VERSION like NewGoCmd; repairHermeticEnv preserves BASHY_GO_VERSION. No /var/cache fallback needed once the requested version matches the pre-seeded one (cache hit needs no mkdir); pointing tests at a fresh TempDir cache would force a network download in the offline image and is worse.

2. GOROOT (todo 54a667814e3c) — managed toolchain child keeps an inherited GOROOT.
   Class: PRODUCT. yoke/external/gotoolchain goCommandEnv appends `GOROOT=<managed>` after os.Environ() without removing an inherited GOROOT, leaving duplicate entries (child resolves the foreign first/ambiguous one: `compile: version go1.27.4 does not match go tool version go1.27.2` when versions differed). Same append pattern in yoke/external/govulncheck. The bash engine already pins GOROOT correctly (bash/interp setEnvString + strips GOROOT when probing an injected binary) and is NOT touched. TestSourceRoute currently strips GOROOT for its child (venue workaround citing 54a66781).
   Fix where it lives (yoke gotoolchain, shared by govulncheck): pin GOROOT by replacement (single entry), exported as PinGOROOT; add unit test with a foreign inherited GOROOT. Then TestSourceRoute stops stripping GOROOT so it exercises the product path.

3. TestACPHelpIsHeraldACPHelpByteForByte + TestACPProcessLevelInitializeSessionPrompt — context deadline exceeded ~121 s; embed error `baseline/adapters/docker-ps.yaml: no such file` from a tmp module cache.
   Class: TEST (budget/isolation) + VENUE (cold build under caps), embed sub-item VENUE not product. Verified: the yoke module zip at 908e590c DOES contain pkg/fleet/baseline/adapters/docker-ps.yaml (165 B; `unzip -l` on the download cache zip + extracted modcache both list it; added in 1df3a26c, ancestor of 908e590c; no .gitignore exclusion). The gate error path is under GOTMPDIR (`/var/cache/bashy-build/tmp/.../yoke@...`), i.e. an adapter build with a private/tmp module cache whose extraction was incomplete/raced under parallel cold builds — not a missing file in the shipped module. Each ACP test also uses its own fresh HOME (acpTestEnv), so each pays a full cold yoke/chat adapter build alone against 60 s/90 s contexts on an 8-CPU-capped venue.
   Fix where it lives (bashy internal/agentos tests): warm the adapter once against a shared test HOME (sync.Once, explicit 5 min cold budget), both ACP tests reuse that HOME so only the first pays the build; per-test contexts stay 60 s/90 s for the warm path. Never a skip.

4. internal/agentos — `panic: test timed out after 10m0s`, no individual FAIL (TestPromotionStatusLineUnconfigured merely among running tests).
   Class: TEST-INFRA/venue capacity, not a named product failure. Package carries 1547 tests (284 files) including process-level adapter builds; on the 8-CPU/7 GB lane sibling packages took 375-600 s, so the default 10 m `go test` package timeout is simply undersized for this package under caps. No test name failed.
   Fix where it lives (bashy dag.md `test` target, test-infra only): `go test -timeout 30m ./...` (Makefile is a generated projection of dag.md; regenerate/check it). Never a skip or split that drops coverage.

## Targeted verification on gate-host lane 2 (2026-11-22, muse)

Lane claimed (the gate-host lane-2 resource, epoch 9). Staged clean `git archive` trees of bashy 1af94b00 + yoke 5f136516 (plus workspace siblings for go.work) at the lane-2 work dir on the gate host; ran in the official image localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3 (go1.27.4, BASHY_BIN_CACHE=/var/cache/bashy/bin pre-seeded with go/1.27.4), 8 CPU / 7 GB, cache volume lane2-s692-rc40-cache, via setsid+nohup to run.log and polling (attached keepalive held the WSL distro). Results:

- yoke: `go test ./external/gotoolchain/ -run 'TestPinGOROOTReplacesForeignGOROOT|TestDefaultVersionMatchesProductToolchain|TestEnsureEmptyVersionHonorsEnvVersion|TestWindowsNativePathForGOOS'` — PASS (all 4, ok 0.012s).
- bashy: `go test ./cmd/bashy -run TestSourceRoute` — PASS (13.220s): go_extension, go_flag_no_op, go_flag_txt, go_flag_no_extension, go_module_directory, non-main_refusal, flag_beats_python_extension all PASS; foreign-language cases SKIP by design (BASHY_TEST_FOREIGN_SOURCES unset, pre-existing). Note: with GOWORK exported into the test child, go_module_directory fails (`contained in a module that is not one of the workspace modules`) — a staging-env artifact of this verification harness, not the gate (the gate does not export GOWORK); without the exported GOWORK it PASSes.
- bashy: `go test ./internal/agentos -run 'TestRepairHermeticStrippedPathRunsThroughBashyRuntime|TestACPHelpIsHeraldACPHelpByteForByte|TestACPProcessLevelInitializeSessionPrompt'` — PASS (152.322s): ACP help 80.67s (cold warm paid once), ACP process 25.48s, repair hermetic 46.09s.

Full gate-leg re-run (dag test ./... incl. the -timeout 30m target) remains the conductor's, per the operator test rule.
