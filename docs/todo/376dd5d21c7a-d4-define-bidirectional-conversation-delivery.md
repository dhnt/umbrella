---
id: 376dd5d21c7a
kind: doc
title: D4 Define bidirectional conversation delivery
seq: 10
status: todo
priority: p1
labels:
    - design
created: 2026-11-04T17:39:38.903697Z
sprint: 568
sprint_id: b1fae56b-6fb4-5bb7-9f7f-a446d397fce9
sprint_title: Shared membership and communication for humans and agents
---

Design only; no coding, deployment or live-account migration.
Sprint: 568 (b1fae56b-6fb4-5bb7-9f7f-a446d397fce9).
Master plan: docs/plan-s568-master-execution.md.
Dependencies: D3.

Scope
Specify human/agent communication through cloudbox/satellite/outpost/bashy services using normal application interfaces. Cover Klatch to MB inbox, Meet and sprint-manager session, with replies to the original conversation. Specify authenticated sender, stable message ID, conversation/reply correlation, delivery acknowledgements versus execution, durable offline handling, retries, deduplication and permission checks. Email/phone gateways are not required.

Acceptance
Sequence diagrams and public interface contracts cover each route and its reply, offline/reconnect, transient failure, duplicate suppression, group/account revocation and handoff; equivalent human and agent operations use the same authorization and app paths.

Deliver evidence as reviewed architecture/contracts and scenario walkthroughs, not claims of passing runtime tests. Both human and agent members use ordinary service features; humans may use every bashy command directly or with assistance.
