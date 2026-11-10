---
id: c620541a53ee
kind: doc
title: S11 Establish canonical examples and compatibility evidence
seq: 90
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.775388Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Consolidate executable examples, compatibility evidence and accurate execution-mode guarantees using existing corpora.

Dependencies: S4/S5/S7/S8.

## Acceptance
- Verify formatter idempotence and parse/print semantics across supported shell, typed and fence constructs.
- Publish mixed/unit/compiled/fence matrices for sharing, lifetime, cancellation, cleanup, runtime dependencies and deployment boundaries.
- Document S4's discarded-write warning; S4 owns checker implementation.
- Reconcile version drift and current claims; historical performance and conformance evidence retains its candidate/date and limits.
- State workload-specific performance cliffs and explicit compiled alternatives without silently substituting compiled runs for interpreted correctness.
- Record syntax collisions and compatibility policy; preserve dialect activation and silent aliases. Do not claim unproved dialect-on parity.
- Recognize existing structured command results, task cleanup, C# fences and examples; do not build a duplicate corpus.

New deprecation registries, alias warnings and governance mechanisms remain deferred.
Planned owner: muse (reviewer, gate and merge: claude).
