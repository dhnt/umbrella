---
id: 9f301f5efadb
kind: doc
title: D5 Define compatibility and service integration changes
seq: 11
status: todo
priority: p2
labels:
    - design
created: 2026-11-04T17:39:39.042114Z
sprint: 568
sprint_id: b1fae56b-6fb4-5bb7-9f7f-a446d397fce9
sprint_title: Shared membership and communication for humans and agents
---

Design only; no coding, deployment or live-account migration.
Sprint: 568 (b1fae56b-6fb4-5bb7-9f7f-a446d397fce9).
Master plan: docs/plan-s568-master-execution.md.
Dependencies: D4.

Scope
Assign changes to public owning components, define additive interfaces and rollout/rollback compatibility, and prepare/file satellite support tickets using public contracts only. Preserve local MB/Meet/claims/sprint behavior; correct agent-only assumptions only where they block shared use. Separate local defects from this architecture and avoid unrelated identity rewrites.

Acceptance
A component responsibility and compatibility matrix lists required changes and preserved behavior; satellite gaps have ticket references or explicit filing blockers; no private service internals, credentials or deployment changes enter public artifacts.

Deliver evidence as reviewed architecture/contracts and scenario walkthroughs, not claims of passing runtime tests. Both human and agent members use ordinary service features; humans may use every bashy command directly or with assistance.
