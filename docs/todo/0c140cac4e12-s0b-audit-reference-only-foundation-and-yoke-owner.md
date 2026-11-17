---
id: 0c140cac4e12
kind: spike
title: S0B Audit reference-only foundation and Yoke ownership moves
seq: 451
status: assigned
priority: p0
labels:
    - layer-separation
created: 2026-11-17T21:49:52.916951Z
assignee: s575-ownership-review
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Read-only review. Inspect bashy/internal/core/commands.go -> yoke/pkg/fleet and coreutils/pkg/{weavecli,nudge,schedule}, coreutils/tool/mcpdoc and posixproviders. Identify minimal package relocations and import/dependency updates eliminating reverse dependencies while preserving behavior and utility/provider names. Check whether the proposed dependency-free catalog extraction is truly a move or requires logic/API changes. Do not implement or invent APIs. Cite exact source locations and cycles. No edits, commits, tests, remote host use or fixes. Compare against docs/plan-s575-master-execution.md current contract.
