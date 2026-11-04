---
id: 97416a83424c
kind: doc
title: D2 Define onboarding and service account relationships
seq: 8
status: todo
priority: p0
labels:
    - design
created: 2026-11-04T17:39:38.624028Z
sprint: 568
sprint_id: b1fae56b-6fb4-5bb7-9f7f-a446d397fce9
sprint_title: Shared membership and communication for humans and agents
---

Design only; no coding, deployment or live-account migration.
Sprint: 568 (b1fae56b-6fb4-5bb7-9f7f-a446d397fce9).
Master plan: docs/plan-s568-master-execution.md.
Dependencies: D1.

Scope
Specify creation/invitation, authentication and credential lifecycle for agent-operated accounts, then the ordinary member lifecycle shared with humans. Define user-created groups and permissions, per-service account IDs/usernames/aliases, optional contact methods, explicit local-to-service mappings and attribution when acting for another user. No mandatory global identity registry or application-level agent member subtype.

Acceptance
Account and membership lifecycle diagrams/contracts cover creation, invitation, authentication, renewal, revocation, suspension and removal; matching contact details do not silently merge accounts; ordinary app interfaces and permissions serve both kinds of operator.

Deliver evidence as reviewed architecture/contracts and scenario walkthroughs, not claims of passing runtime tests. Both human and agent members use ordinary service features; humans may use every bashy command directly or with assistance.
