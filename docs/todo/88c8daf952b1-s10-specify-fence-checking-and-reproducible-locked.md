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

Depends on S1/S5/S8; coordinate with Sprint 600. Design deliverable only in this sprint: an implementation-ready specification for opt-in fence checking and locked execution, extending existing environment plans rather than adding a parallel planner.
Acceptance: define coverage for every shipped fence language, strict TypeScript checking as an opt-in, syntax-only versus type-check coverage, missing-tool behavior, explicit provisioning policy, exact toolchain identities, digest provenance, relevant environment inputs, override identities and lock handling. Specify source-mapped diagnostics and how resolved execution identity reaches the run. Checking never invokes fence entry points or silently provisions tools. Python type checking must identify its selected checker and availability.
Record current floating Rust/Python selections and remote checksum retrieval as concrete gaps; select exact versions and trusted digest artifacts in the specification before implementation.
No runtime/toolchain changes in this story.
