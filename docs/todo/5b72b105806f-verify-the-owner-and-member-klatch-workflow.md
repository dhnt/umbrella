---
id: 5b72b105806f
kind: test
title: Verify the owner and member Klatch workflow
seq: 569
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:46.464191Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: Verify Klatch group participation
---

Use the running Klatch instance. Sync a circle roster, have two distinct members enter the same group and exchange messages via browser and CLI, remove a member and sync again. Verify denial and idempotent repeat sync. Close on existing evidence if the workflow passes. Use the epic contract in docs/plan-group-participation.md. Identify the consumer/producer shaping hook on the app or artifact. Demonstrate role-scoped invite/join, an allowed change, its visibility and a denied action. Every UI action must have an equivalent Bash CLI action under the same identity and permissions.
