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

## Outcome
Extend bounded checks for undefined typed names, incompatible calls/returns, provable local nil and pointer-selector dereferences, and enum exhaustiveness where the enum type is statically known. Own diagnostics for writes to outer bindings discarded by mixed-task snapshot semantics.

Dependencies: S3; integrate diagnostics with S5.

## Acceptance
- The reviewed undefined return name, string-as-int return and provably nil local dereference produce positioned errors.
- Positive tests preserve valid narrowing, shadowing, forward declarations and valid typed calls.
- Potential mutation, closures and unknown side effects invalidate facts that are no longer justified; unresolved/dynamic regions report unchecked coverage rather than false certainty.
- Known enum locals/expressions receive exhaustiveness checks; dynamic enum membership guards remain a separate deferred runtime proposal.
- Discarded-write warnings preserve snapshot semantics and avoid claiming compiled/interpreted sharing equivalence.
- No ADTs, new null syntax or general effect/type-safety claim.

Planning record only: implementation requires a separate execution instruction. Leave this story todo and unassigned; no code, worker launch or release is authorized by this rewrite.
