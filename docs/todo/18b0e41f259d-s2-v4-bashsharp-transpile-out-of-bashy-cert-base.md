---
id: 18b0e41f259d
kind: refactor
title: 'S2 V4: bashsharp/transpile out of bashy_cert_base'
seq: 25
status: wontfix
priority: p0
labels:
    - layer-separation
created: 2026-11-06T21:04:31.685198Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-22T13:41:42.036615Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 575 ended): superseded. The shared-engine split is future refactoring the operator has not authorized; Sprint 677 delivered the certified-core boundary as bsh (bashsharp/cmd/bsh, zero yoke). Reopen only under a new, operator-authorized separation sprint.

Problem: cmd/bashy/main_core.go blank-imports bashsharp/transpile, so the cert base links Bash#. Change: drop it from bashy_cert_base (keep for full bashy); reconcile docs/sprint-355-core-optional-design.md which put Bash# in Base (delineation plan supersedes - reviewer to confirm). Exit: cert base links no bashsharp; S0 allowlist entry removed. Plan: docs/plan-s575-master-execution.md
