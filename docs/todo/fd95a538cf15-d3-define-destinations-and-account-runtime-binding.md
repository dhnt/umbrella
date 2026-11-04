---
id: fd95a538cf15
kind: doc
title: D3 Define destinations and account runtime bindings
seq: 9
status: todo
priority: p1
labels:
    - design
created: 2026-11-04T17:39:38.766073Z
sprint: 568
sprint_id: b1fae56b-6fb4-5bb7-9f7f-a446d397fce9
sprint_title: Shared membership and communication for humans and agents
---

Design only; no coding, deployment or live-account migration.
Sprint: 568 (b1fae56b-6fb4-5bb7-9f7f-a446d397fce9).
Master plan: docs/plan-s568-master-execution.md.
Dependencies: D2.

Scope
Map a regular service account to an authorized outpost/local identity and configured MB inbox, Meet conversation or sprint role/session. Define durable IDs separately from hostname/IP, nickname, tool/model and session. Support human-operated and agent-operated destinations. Resolve sprint manager by durable sprint identity and current ownership; do not broadcast across all local surfaces by default.

Acceptance
Addressing and resolution contracts cover ambiguous aliases, unavailable destinations, host changes and sprint handoff, preserve existing local identities, and keep runtime metadata out of application member semantics.

Deliver evidence as reviewed architecture/contracts and scenario walkthroughs, not claims of passing runtime tests. Both human and agent members use ordinary service features; humans may use every bashy command directly or with assistance.
