---
id: be8e90559755
kind: refactor
title: 'S3 V1/L2: Classic bash links no Bash# (cli injection hook)'
seq: 26
status: wontfix
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:31.815071Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-22T13:41:42.450003Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 575 ended): superseded. The shared-engine split is future refactoring the operator has not authorized; Sprint 677 delivered the certified-core boundary as bsh (bashsharp/cmd/bsh, zero yoke). Reopen only under a new, operator-authorized separation sprint.

Problem: bashy/cmd/bash links bashsharp/front and sh/polyglot through internal/cli. Change: internal/cli reaches the Bash# front only via a hook set by Bash#-enabled entry points (pattern: AgentOSDispatch); bash --bashsharp/--bashpp fails with a clear error pointing to bashy/bashsharp (operator-approved 2026-11-04); changelog/release-notes entry. Exit: go list -deps ./cmd/bash has no bashsharp/polyglot; S0 allowlist removed; make test-bash-container 86/86 and make test before/after on remote test host. Plan: docs/plan-s575-master-execution.md
