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
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

Proof one of the Sprint 684 rod: the admission baseline. Use the running Klatch instance (operator-owned, in the gate host's container machine; confirm before starting it). Sync a circle roster with bashy klatch sync, have two distinct members enter the same group and exchange messages via browser and CLI, remove a member and sync again. Verify denial for the removed member and for an outsider holding a forwarded link, and idempotent repeat sync. Then run the Sprint 684 group-shape skill-script (G4) against Klatch, with one participant acting through its member's agent. Overlaps Sprint 616 story F2 (14bb7d2b): reuse its 200/403/401 and live-revoke steps rather than writing new ones. Close on existing evidence if the workflow passes. Contract: docs/plan-group-participation.md.
