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

## Outcome
Establish one semantic analysis entry point combining CheckProfile and CheckBashSharp, reused by standalone checking, bashy check and transpilation.

Dependencies: S2 by required delivery sequence.

## Interface ownership
Own the shared result contract: positioned source diagnostics with stable identities, checked/unchecked coverage, and explicit host-capability inputs. S4/S8 own added checks; S5 owns presentation. Keep bashy/yoke policy dependencies out of the standalone language.

## Acceptance
- Equivalent source and analysis context produce equivalent semantic verdicts and locations across front doors.
- Source semantic rejection remains distinct from lowering/toolchain limitations; transpilation may still refuse otherwise valid source for those limitations.
- Analysis builds no runner and performs no user execution, shell expansion or implicit provisioning.
- Retain package-led Go checking and existing source-profile identities.
- The union of current checks is described as bounded checking, not full Go type safety.

Planned owner: claude (reviewer, gate and merge: claude).

## Execution plan
Follow [Sprint 610 master execution plan](../sprint-610-master-execution-plan.md). Planning only: retain todo status and planned ownership; no implementation, workers, benchmarks or release are authorized. Dependencies and story acceptance remain authoritative.
