---
id: 570d50d0c983
kind: bug
title: 'bashy internal/agentos: four unit tests fail on the gate lane at main 37833eb8 (embedded adapters drift; make fallthrough hints)'
seq: 854
status: todo
priority: p2
created: 2026-11-28T00:51:44.047504Z
---

Found 2026-11-27 by the Sprint 738 full agentos run on a Linux gate lane, official toolchain. Fail identically on main 37833eb8 and on the Sprint 738 candidate b872d444 (same lane, same command): TestEmbeddedAdaptersMatchSourceTree (examples/shaping/discover/discover.bsh and examples/update/update.bsh drifted from the source tree; the test says run go generate ./internal/agentos/adapterembed), TestMakeFallthroughFrontDoor, TestMakeFallthroughListAndHints, TestDagMakeHandlerShell (expected hint line is empty). Not caused by Sprint 738 and not repaired there. Root cause not yet identified for the three hint tests: check whether the lane environment turns hints off (venue) before touching product code.
