---
id: 68dba07e6977
kind: refactor
title: 'S5 L1a: Bash# packages out of sh (interp->polyglot seam, move lower/gosource/grammar/polyglot)'
seq: 28
status: todo
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:32.06735Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Problem: sh/interp imports sh/polyglot (12 files); sh/{lower,gosource,polyglot,grammar} (~110K LOC) are Bash# in the foundation module. Change: put interp->polyglot behind a registration seam; relocate the four packages into the bashsharp module with the interp tests that import them; update yoke/bashy imports. Out of scope: the 208 bashpp_* files inside interp (Sprint 581). Exit: go list -deps ./interp has no Bash# package; sh full tests, bashsharp-tests harness/run.sh, bashy make test and test-bash-container 86/86 before/after on remote test host; report cert-input change to S571. Plan: docs/plan-s575-master-execution.md
