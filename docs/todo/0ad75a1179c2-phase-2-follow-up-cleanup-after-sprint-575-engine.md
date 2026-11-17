---
id: 0ad75a1179c2
kind: refactor
title: Phase 2 follow-up cleanup after Sprint 575 engine separation
seq: 31
status: todo
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:59.390981Z
sprint: 581
sprint_id: cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7
sprint_title: 'Layer separation phase 2: Bash# engine out of sh/interp and sh/syntax'
---

Operator 2026-11-17 assigned full evaluator/parser extraction to Sprint 575 S5 (68dba07e6977), so do not duplicate that implementation here. This 581 seed retains only follow-up cleanup not needed for the minimum-change split: moreinterp/coreutils duplication, broader agentic feature cleanup, execbudget naming and dhnt skills dependency reconciliation. Any item necessary to meet the approved Bash <- Bash# <- bashy boundary is owned by 575. Current source of scope: docs/plan-s575-master-execution.md. No implementation authorized by this seed.
