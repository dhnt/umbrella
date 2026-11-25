---
id: 507e2cab30e5
kind: feature
title: F2 Re-advertise 'bashy site attach' on agent-ready pages once a released bashy carries it
seq: 741
status: todo
priority: p1
labels:
    - hosted-plane
    - release
created: 2026-11-25T06:08:19.593255Z
sprint: 711
sprint_id: 824bc632-65c8-5982-8bf9-7f69ed848391
sprint_title: 'Train 1 follow-ups: site MCP + site attach on dhnt.io, and the deferred integration runs (C4 five-app member matrix, I1 group-shape)'
---

Held back from train 1 by A2a. 'bashy site attach' first landed in bashy 775bcc30 (2026-11-23) and is in no released bashy (latest v1.0.0-rc.40-dev). Switch the line back on in the hosted plane config only after the bashy release that carries it is promoted; verify from that release against dhnt.io.
