---
id: 5b72b105806f
kind: test
title: I2 Verify the owner and member Klatch workflow (integration, release train)
seq: 569
status: todo
priority: p3
labels:
    - group-shaping
    - future-input
created: 2026-11-20T21:08:46.464191Z
---

Integration story of the group shaping epic, run once on integrated main on the gate host as part of the release train; no code. Use the running Klatch instance (operator-owned, in the gate host's container machine; the operator confirms before it is started). Sync a circle roster with bashy klatch sync, have two distinct members enter the same group and exchange messages via browser and CLI, remove a member and sync again. Verify denial for the removed member and for an outsider holding a forwarded link, and idempotent repeat sync. Overlaps Sprint 616 story F2 (14bb7d2b): reuse its 200/403/401 and live-revoke steps. This is the baseline of the one group model (roster = the app's audience on the host; owner and member) that Page, Session and Notepad share. Evidence in docs/sprint-699-evidence.md. Plan: docs/sprint-684-685-master-execution-plan.md.
