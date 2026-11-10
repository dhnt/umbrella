---
id: e12567fd2a51
kind: feature
title: S8 Inspect host contract providers and effective authority
seq: 87
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.350056Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Check required host providers and explain effective authority before checked execution.

Dependencies: S3/S4/S5. Supply provider checks used by S6.

## Acceptance
- Diagnose the standalone missing-contract-provider reproduction; recognize bashy providers and valid user-defined decorators.
- Represent available, missing and unresolved host capabilities explicitly, without importing bashy/yoke policy into the standalone language.
- Diagnose statically provable agentic-scope and effect-cap violations; unknown effects remain unknown rather than safe.
- Publish a matrix for declarations, shell command dispatch, redirections/builtins, native imports, compiled hosts and foreign-worker boundaries.
- Distinguish declaration, dispatch enforcement and containment; agentic scope grants no permissions.
- Record decorated-shell lowering and compiled policy-advice limitations without implementing them here.

External dependency: Sprint 600 UUID 1b4d2326-3a0e-583e-9cdf-358f396c39e3 owns fence routing, per-call environment and worker lifecycle. Claim only guarantees supported by its delivered evidence; PATH/SHELL shims are not universal containment. No authority/default changes.
Planned owner: codex (reviewer, gate and merge: claude).

## Execution plan
Follow [Sprint 610 master execution plan](../sprint-610-master-execution-plan.md). Planning only: retain todo status and planned ownership; no implementation, workers, benchmarks or release are authorized. Dependencies and story acceptance remain authoritative.
