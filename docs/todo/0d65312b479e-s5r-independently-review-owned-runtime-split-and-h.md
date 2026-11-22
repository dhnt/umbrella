---
id: 0d65312b479e
kind: spike
title: S5R Independently review owned runtime split and handler compatibility
seq: 454
status: wontfix
priority: p0
labels:
    - layer-separation
created: 2026-11-17T22:04:50.254528Z
assignee: s575-design-review
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-22T13:41:42.862422Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 575 ended): superseded. The shared-engine split is future refactoring the operator has not authorized; Sprint 677 delivered the certified-core boundary as bsh (bashsharp/cmd/bsh, zero yoke). Reopen only under a new, operator-authorized separation sprint.

Read-only independent review of S5D design. Latest operator permits minimum necessary structural changes, moving whole sh into qiangli/bash and archive old repo only after gates; no external-upstream tracking requirement. Require actual Bash <- Bash# <- bashy direction and independent builds against fixed lower versions. Review distinct AST/Runner types, coreutils ExecHandler context/options compatibility, Bashy CLI/session/agentos wiring, import cycles and reproducible publication order. No product edits; identify exact blockers and smallest corrections. Authoritative final behavior and tests unchanged.
