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

## Outcome
Unify machine-readable diagnostics and support identities using S3's analysis contract. Add bashsharp --check --json and additive fields to bashy-check-v1.

Dependencies: S3. Establish the presentation contract before final S4/S8 integration; S4/S8 can add diagnostic producers without a circular dependency.

## Acceptance
- Preserve parser source positions, stable codes, source ranges, coverage and workaround hints.
- File, stdin and -c inputs produce deterministic reports; text and JSON agree on verdict.
- Existing bashy fields/consumers and exit statuses remain compatible.
- Go-delta lookup uses stable codes where available; retain a compatibility fallback for older text-only refusals.
- Source errors and lowering restrictions remain distinguishable.
- Verify current runtime refusal fixtures against generated support metadata, not metadata consistency alone.

LSP, semantic navigation, machine-applicable edits and a new AST CLI are separate deferred proposals; do not imply implementation by adding hints.
Planned owner: glm (reviewer, gate and merge: claude).

## Execution plan
Follow [Sprint 610 master execution plan](../sprint-610-master-execution-plan.md). Planning only: retain todo status and planned ownership; no implementation, workers, benchmarks or release are authorized. Dependencies and story acceptance remain authoritative.
