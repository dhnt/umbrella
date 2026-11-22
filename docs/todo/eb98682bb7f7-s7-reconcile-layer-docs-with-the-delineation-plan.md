---
id: eb98682bb7f7
kind: doc
title: S7 Reconcile layer docs with the delineation plan
seq: 30
status: wontfix
priority: p2
labels:
    - layer-separation
created: 2026-11-06T21:04:32.306849Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-22T13:41:42.723826Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 575 ended): superseded. The shared-engine split is future refactoring the operator has not authorized; Sprint 677 delivered the certified-core boundary as bsh (bashsharp/cmd/bsh, zero yoke). Reopen only under a new, operator-authorized separation sprint.

Problem: docs contradict bashy/docs/plan-layer-delineation.md. Change: update sh/CLAUDE.md ('Bash++ lives here deliberately'), bashsharp/CLAUDE.md, bashsharp/docs/seam.md, bashy/CLAUDE.md layer table (Bash++ naming, planned coreutils/pkg/yoke), umbrella CLAUDE.md 'ENGINE stays in sh', S355 Base definition, stale freeze wording in dad90d644fa5; file the referenced-but-missing af65f24e engine-seam card. Exit: docs agree with the delineation plan. Plan: docs/plan-s575-master-execution.md
