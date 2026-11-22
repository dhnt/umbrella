---
id: 389edc3a9dc8
kind: bug
title: 'Candidate ''go test ./...'' red in the official image: TestSourceRoute GOROOT, /var/cache/bashy permission, ACP 120 s deadlines, internal/agentos 10 m timeout'
seq: 627
status: assigned
priority: p0
labels:
    - bashy
    - gate
    - release
created: 2026-11-22T16:00:50.197077Z
weave: 150
assignee: muse-wonder
sprint: 692
---

Candidate gate leg 2 diagnostic (umbrella 8b8db523f, docs/sprint-677-integration-evidence.md): candidate go test ./... in the official image rc.40-go1.27.4 on lane 2 (8 CPU / 7 GB): 26 ok, 2 FAIL (cmd/bashy 464 s, internal/agentos 600 s panic timeout). Names verbatim: (1) TestSourceRoute/* (7 subtests): 'bashy: resolve Go toolchain: mkdir /var/cache/bashy/bin/go/1.27.2: permission denied' AND the known GOROOT product bug bashy todo 54a66781 (managed toolchain child keeps an inherited GOROOT); (2) TestRepairHermeticStrippedPathRunsThroughBashyRuntime: same 'mkdir /var/cache/bashy/bin/go/1.27.2: permission denied'; (3) TestACPHelpIsHeraldACPHelpByteForByte and TestACPProcessLevelInitializeSessionPrompt: context deadline exceeded at ~121 s (cold yoke/chat adapter build under caps), plus an embed error from the module cache: 'embed baseline/adapters/docker-ps.yaml: open .../yoke@.../pkg/fleet/baseline/adapters/docker-ps.yaml: no such file or directory' (check whether the yoke module zip at 908e590c really lacks pkg/fleet/baseline/adapters/docker-ps.yaml - a .gitignore or module-zip exclusion would be a PRODUCT bug for every GOWORK=off consumer); (4) internal/agentos: 'panic: test timed out after 10m0s' with no individual FAIL (TestPromotionStatusLineUnconfigured among the running tests). Owner muse (knows the lane). FOR EACH: root cause with class (venue/test/product) recorded here, then fix where the cause lives: the /var/cache/bashy path is the managed-toolchain cache root - a test must point it at a writable TempDir (or the product must fall back to the user cache when /var/cache is not writable: decide from the code, smallest change); GOROOT per 54a66781 (pin GOROOT to the managed toolchain in the child env - yoke/external/gotoolchain or bashy side, NOT the frozen bash engine unless unavoidable); ACP tests warm the chat adapter once (TestMain) or budget the cold build explicitly; the dag 'test' target passes an explicit -timeout large enough for internal/agentos under 8 CPU (or splits the package run) - a test-infra change, never a skip. Verify on the claimed gate-host lane 2 in the official image with targeted -run per fixed test (nohup + poll). TEST RULE (operator 2026-11-22): build + smallest targeted unit tests only, then submit; the re-run of the red gate legs is the conductor's. Root cause recorded on this story BEFORE the fix. Start on current origin main of each repo touched; Sprint/Story/Story-ID + Agent trailers; submodule commit first (do not push), the conductor merges and bumps pins. Long remote commands: nohup + poll, never block one command for more than a minute.
