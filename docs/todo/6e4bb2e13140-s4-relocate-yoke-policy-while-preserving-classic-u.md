---
id: 6e4bb2e13140
kind: refactor
title: S4 Relocate Yoke policy while preserving Classic utility mechanisms
seq: 27
status: wontfix
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:31.940648Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-22T13:41:42.313586Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 575 ended): superseded. The shared-engine split is future refactoring the operator has not authorized; Sprint 677 delivered the certified-core boundary as bsh (bashsharp/cmd/bsh, zero yoke). Reopen only under a new, operator-authorized separation sprint.

Use the reviewed minimum-change ownership map to move agentic policy out of the foundation. Keep dependency-free metadata used by man and necessary provider/resolver mechanisms below; do not blindly move tool/mcpdoc or alter names/default provider behavior. Eliminate upward imports and Bash# implementation links from Classic. Existing hooks preferred; necessary structural wiring allowed, semantics/test expectations preserved. Standalone official-image DAG gates, no make; plan docs/plan-s575-master-execution.md, review docs/s575-separation-review.md.
