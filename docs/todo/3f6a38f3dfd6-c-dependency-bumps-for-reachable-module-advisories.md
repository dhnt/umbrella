---
id: 3f6a38f3dfd6
kind: chore
title: 'C: Dependency bumps for reachable module advisories + fresh govulncheck, retire/shrink vuln override'
seq: 586
status: done
priority: p0
created: 2026-11-21T08:29:57.498182Z
assignee: claude-fable5.1
sprint: 692
closed: 2026-11-22T15:09:19.369981Z
closed_by: claude-fable5.1
---

UNPAUSED + RESCOPE (operator 2026-11-22, decision D2 'full clean job'): p0, owner agy, one run together with C2 0774dc22. Bump every reachable module advisory in bashy, outpost and yoke to fixed versions (start from the salvaged WIP commits named on C2; minimal, no unrelated upgrades); fresh govulncheck per scope on a claimed gate-host lane (never the dev box) with yoke external/ollama+podman sources hydrated; RETIRE the d91599c2 override (bashy 7ddc31c9) and empty vuln-ignore of the fixed ids. A remaining reachable finding blocks the release; no new override. Record the govulncheck summary per scope in the submit. TEST RULE (operator 2026-11-22): build + the smallest targeted unit tests for the changed packages only, then submit. No go test ./..., no gates, no integration per story or per commit. The one full run is the rc.40 candidate gate (458628c0) at sprint close; anything red there is root-caused and fixed until the full run is clean. Start on current heads (bashy mod drift; rebase before submit). Trailers: Sprint/Story/Story-ID + Agent; submodule commit+push first, then the umbrella pin.

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

Phase 0C, AFTER A merges. Operator: do a clean job whatever it takes now. Repos: bashy, outpost, yoke. Bump the reachable module advisories from rc.39 ledger (x/net, x/crypto, grpc, excelize, klauspost/compress, otel exporters, quic-go, pion, moby/buildkit, runc, fulcio, frp) to fixed versions - minimal, no unrelated upgrades. Fresh govulncheck per scope WITH yoke external/ollama+podman sources fetched. Retire the d91599c2 override (bashy 7ddc31c9) if clean, else shrink to exact remaining reachable ids each justified here. Acceptance: govulncheck output per scope + override diff recorded; targeted builds/tests green; root cause before fixing any red the bumps expose.

RUN #110 FAILURE CLASSIFICATION (manager, 2026-11-21): WORKER/TOOL exit failure - NOT watchdog (no killed_by, 40m49s < 48m cap), NOT venue (dev-box work). agy process exited failed with ALL work uncommitted (0 commits in 40m; repeat of the no-incremental-commit failure mode). SALVAGE: manager verified sanity (outpost go build ok; go list -m ok x3; test-govulncheck-release.py 8/8) and committed the dirty trees as local WIP in workspace issue-110 submodules: bashy ab591e31, outpost 06f2121b, yoke dab686f8 (full shas on C2). Remainder (fresh govulncheck evidence, targeted builds, delivery commits, pins) = story C2. This story closes together with C2 acceptance.
