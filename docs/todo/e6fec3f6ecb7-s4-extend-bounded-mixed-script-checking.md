---
id: e6fec3f6ecb7
kind: feature
title: S4 Extend bounded mixed-script checking
seq: 83
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.78187Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S3. Diagnose undefined names, incompatible typed returns and calls, provable local nil dereferences and pointer-selector dereferences. Extend enum exhaustiveness where the enum type is statically known.
Acceptance: reviewed successful-check blind spots become positioned errors, including missing return name, string returned as int and dereference of a provably nil local pointer. Positive cases prove valid narrowing and valid typed calls remain accepted. Dynamic and unresolved regions explicitly report unchecked coverage; no full Go type-safety claim. Do not introduce ADTs or new null syntax.
Planning-only creation; preserve language defaults.
