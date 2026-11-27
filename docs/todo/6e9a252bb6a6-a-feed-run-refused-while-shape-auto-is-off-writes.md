---
id: 6e9a252bb6a6
kind: bug
title: A feed run refused while shape auto is off writes no decision-log line
seq: 818
status: todo
priority: p2
labels:
    - shapeware
created: 2026-11-27T01:12:59.062133Z
---

Sprint 730 F4 (2026-11-26): shape-feed checks bashy shape auto status and stops before any wish, so the log shows the switch but not each refused feed run; a wish that reaches the service while off is refused and logged (yoke pkg/shape auto.go). Future input: a log line for the refused run, if the owner needs it.
