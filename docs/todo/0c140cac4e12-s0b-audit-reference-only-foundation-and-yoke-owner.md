---
id: 0c140cac4e12
kind: spike
title: S0B Audit reference-only foundation and Yoke ownership moves
seq: 451
status: done
priority: p0
labels:
    - layer-separation
created: 2026-11-17T21:49:52.916951Z
assignee: s575-codex-manager
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-20T12:26:30.290679Z
closed_by: s575-codex-manager
---

Read-only review. Inspect bashy/internal/core/commands.go -> yoke/pkg/fleet and coreutils/pkg/{weavecli,nudge,schedule}, coreutils/tool/mcpdoc and posixproviders. Identify minimal package relocations and import/dependency updates eliminating reverse dependencies while preserving behavior and utility/provider names. Check whether the proposed dependency-free catalog extraction is truly a move or requires logic/API changes. Do not implement or invent APIs. Cite exact source locations and cycles. No edits, commits, tests, remote host use or fixes. Compare against docs/plan-s575-master-execution.md current contract.

## Manager closeout — 2026-11-20
Read-only ownership/catalog/fleet/MCP findings and reverse-dependency constraints are committed in docs/s575-separation-review.md. The investigation is complete; it is not acceptance of catalog extraction, shared-contract changes or engine splitting.
Existing receipts and source ancestry were reviewed; no new test/build ran during reconciliation. Evidence belongs to its exact historical source/artifact identities, not arbitrary later heads. S575 full-run evidence remains under posix-baseline/s575-2026-11-19 with its raw 4 FAIL, 54 UNRESOLVED and 9 INSPECT unchanged. RC38 is on operator hold.
