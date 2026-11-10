---
id: 1915e8fd337b
kind: refactor
title: S3 Unify semantic checking across Bash# front doors
seq: 82
status: todo
priority: p0
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.640827Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S2. Introduce one shared analysis entry point combining existing CheckProfile and CheckBashSharp obligations; reuse from standalone checking, bashy check and transpilation.
Acceptance: equivalent inputs produce equivalent semantic verdicts, stable diagnostic identities and consistent source locations. Keep lowering-only limitations separate from source semantic rejections. Checking builds no runner and executes no program. Retain package-led Go checking. Do not describe the union of existing checks as full Go type safety.
Planning-only creation. S4-S6 follow this shared foundation.
