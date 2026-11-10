---
id: 88c8daf952b1
kind: spike
title: S10 Specify fence checking and reproducible locked execution
seq: 89
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.634645Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Design-only deliverable with two independently reviewable sections: optional fence verification and reproducible locked execution.

Dependencies: S1/S5/S8; coordinate with Sprint 600.

## Fence verification acceptance
Cover every shipped fence language, compiler/syntax-only/type-check coverage, opt-in strict TypeScript, selected optional Python checker, missing-tool behavior and source-mapped diagnostics. Checking never invokes fence entry points or silently provisions tools.

## Locked execution acceptance
Extend existing environment plans rather than creating a parallel planner. Specify exact toolchain identities, trusted digest provenance, dependency locks, relevant environment inputs, ambient inheritance, PATH resolution, overrides and transfer of resolved identity into execution. Record floating Rust/Python selections and remote checksum retrieval as gaps; choose exact versions and trusted digest artifacts before implementation.

No runtime, toolchain, provisioning or lock implementation in this story.
Planned owner: agy (reviewer, gate and merge: claude).
