---
id: f9e4868ddaf2
kind: bug
title: Repair resource identity and claim handle review findings
seq: 530
status: wontfix
priority: p0
created: 2026-11-19T12:08:51.203686Z
weave: 101
assignee: codex-gpt6-sol
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
closed: 2026-11-19T13:04:32.383597Z
---

Preserve the submitted #524 candidate in run95 nested worktrees and all original commits; do not restart, push or pin it under Sprint 666. Before repairing the candidate, review whether its added per-record UUIDs and backfills are needed at all: an unambiguous full parent path can be sufficient. Concrete review findings remain: (1) mutable canonical claim name can strand a live lease on rename; (2) numeric/hex names can collide with sequence/UUID parsing; (3) qualified remote parent/sequence must stay within parent; (4) supported set/rm handles must match show; (5) the Bashy registry test assumes an obsolete local/store identity; (6) concurrent legacy mint and actual CLI JSON roundtrips need scrutiny; (7) bare canonical slug can drop scope and collapse different resources. Resolve only findings relevant to the finally approved design. Sprint 666 #523 physical Address fix remains distinct and does not depend on this candidate. Future validation runs on claimed test hosts after separate authorization. Record exact nested SHAs and review risks; no shared checkout or private host data.
