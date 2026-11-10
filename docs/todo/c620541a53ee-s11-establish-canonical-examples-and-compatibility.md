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

Depends on S5/S7/S8. Curate executable examples from existing corpora and verify formatter idempotence and parse/print semantics across supported shell, typed and fence constructs. Publish execution-mode and concurrency guarantees.
Acceptance: mixed/unit/compiled/fence matrices state sharing, lifetime, cancellation and cleanup boundaries; checker warns about mixed-task writes discarded by snapshot semantics without changing those semantics. Reconcile version claims and distinguish current behavior from historical measurements. Keep legacy aliases silent. Record compatibility/collision policy without changing dialect activation or claiming dialect-on parity not proved by tests.
Do not invent a new corpus when existing fixtures/examples cover the requirement.
Planning-only creation.
