---
id: 8a420a9a836b
kind: enhancement
title: S9 Improve runtime contract parsing and result bindings
seq: 88
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.493115Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S8. Cache parsed contract checks within the owning runtime lifecycle. Preserve RESULT and STATUS; add RESULT_0, RESULT_1, ... and an error binding for typed error results.
Acceptance: multi-result (T,error) contracts can inspect each result and the error; repeated calls reuse parsed checks without leaking variable state or unbounded cache growth. Preserve precondition body suppression, body failure, cancellation, exit and yield semantics. Validate interpreted and compiled hosts separately. Contracts remain runtime shell checks, without purity, rollback or static-proof claims.
Planning-only creation.
