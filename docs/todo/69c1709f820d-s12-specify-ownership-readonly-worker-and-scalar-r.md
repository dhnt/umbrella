---
id: 69c1709f820d
kind: spike
title: S12 Specify ownership, readonly, worker and scalar-runtime follow-ups
seq: 91
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.915003Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S1; use S11 mode guarantees. Design deliverables only: separate briefs for bridge pointer-origin/closure ownership; readonly retention and identity remapping; persistent C/C++/Go workers; non-recursive scalar evaluation.
Acceptance: each brief gives baseline evidence, safety invariants, dependencies, test commands and measurable acceptance. Ownership preserves retained native pointers and cross-call identity; no call-scoped/weak-reference cleanup that repeats rejected designs. Readonly covers cloned identity, owner attribution and zero-size cases. Workers cover cancellation, process groups, lifecycle bounds, per-call env and Sprint 600 routing. Scalar work preserves original interpreted correctness identities and reports workload-specific performance, allocation and stack measurements.
Link extraction to Sprint 575 (65ce85f5-87c0-5863-bf55-62de86f5df36) and Sprint 581 (cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7); do not duplicate or authorize extraction.
No speculative reclamation, worker conversion or evaluator redesign implementation in this sprint.
