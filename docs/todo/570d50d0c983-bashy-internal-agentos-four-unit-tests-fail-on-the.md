---
id: 570d50d0c983
kind: bug
title: 'bashy internal/agentos: four unit tests fail on the gate lane at main 37833eb8 (embedded adapters drift; make fallthrough hints)'
seq: 854
status: done
priority: p2
created: 2026-11-28T00:51:44.047504Z
closed: 2026-11-28T01:18:25.051577Z
---

Found 2026-11-27 by the Sprint 738 full agentos run on a Linux gate lane, official toolchain. Fail identically on main 37833eb8 and on the Sprint 738 candidate b872d444 (same lane, same command): TestEmbeddedAdaptersMatchSourceTree (examples/shaping/discover/discover.bsh and examples/update/update.bsh drifted from the source tree; the test says run go generate ./internal/agentos/adapterembed), TestMakeFallthroughFrontDoor, TestMakeFallthroughListAndHints, TestDagMakeHandlerShell (expected hint line is empty). Not caused by Sprint 738 and not repaired there. Root cause not yet identified for the three hint tests: check whether the lane environment turns hints off (venue) before touching product code.

Root cause (2026-11-27, manager of Sprint 738, before any fix). Two separate causes.

1. `TestEmbeddedAdaptersMatchSourceTree`: **product defect (stale generated files).** bashy commits `031c3afc` (discover) and `f860d547` (update), both 2026-11-27, changed `examples/shaping/discover/discover.bsh` and `examples/update/update.bsh` without regenerating the embedded copies under `internal/agentos/adapterembed` (last touched 2026-11-25 and 2026-11-22). The binary therefore carried the older scripts. Reproduced on the dev box and on the gate lane at the same commit, so it is not a venue effect. Fix: `go generate ./internal/agentos/adapterembed` (only those two files change).
2. `TestMakeFallthroughFrontDoor`, `TestMakeFallthroughListAndHints`, `TestDagMakeHandlerShell`: **test defect.** The hint they assert is silenced by `BASHY_HINTS=off`, which the tests read from the process environment, and the gate lanes export `BASHY_HINTS=off` (`script/gate-lane.sh`, `gate_env`). Same commit: green on the dev box, red on the lane; red on the dev box with `BASHY_HINTS=off`. The product behaves as designed and the lane setting is deliberate, so the fix is in the tests: they pin `BASHY_HINTS` and `BASHY_AGENTIC` themselves.

Fixed 2026-11-27: bashy `7a30ca7a` (regenerate the embedded adapters) and `e8b5032d` (the three tests pin their hint environment), on main by fast-forward. Verified on the gate lane with `BASHY_HINTS=off` exported: the four tests PASS and the full `go test ./internal/agentos` is ok (619 s).
