---
id: 4cbb8f8b3a0f
kind: feature
title: S5 Share structured diagnostics and support identities
seq: 84
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.923295Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S3; integrate S4 diagnostics. Add bashsharp --check --json. Preserve bashy-check-v1 with additive fields for shared diagnostic identities, source ranges, checked coverage and workaround hints.
Acceptance: parser positions survive both front doors, text and JSON agree on verdict, deterministic results cover file/stdin/-c, and Go-delta lookup uses codes where available rather than depending on exact diagnostic prose. Existing consumers and exit statuses remain compatible. Keep source and lowering limitations distinguished.
Planning-only creation. LSP and semantic navigation remain separate follow-ups.
