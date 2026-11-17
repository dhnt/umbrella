---
id: 10620c479d5c
kind: spike
title: 'S8 Follow-on spike: location transparency across execution tiers'
seq: 421
status: todo
priority: p3
labels:
    - yoke
created: 2026-11-17T18:49:47.18662Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: after one app exists, the same command should run at any execution tier (userland, sandbox, sphere, cluster, cloud) with the same envelope; the envelope is what crosses the wire.
Behavior: spike only: define how a conforming command is dispatched to another tier and returns the identical envelope; identify the smallest slice. No implementation in this sprint.
Depends on: S0, S1.
Verification: written spike result with a proposed follow-up story set, reviewed by the operator.
