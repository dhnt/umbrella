---
id: b23982703c71
kind: task
title: O0 Confirm the console builds the desk-family apps as member instances from the module proxy; close d35e0de8
seq: 714
status: todo
priority: p0
labels:
    - shaping
created: 2026-11-24T19:03:06.172485Z
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Shaping-enable the example apps for owners/producers (follow-up)
---

Todo d35e0de8 (p0) is still open, but bashy main fixed its cause: 56b5b1a1 (kit and chart are published modules, no sibling replace), 6a10293f and 9a24fd30 (module proxy for fork homes, yoke dcccc0fa). Confirm on the gate host, with a current bashy (703 F11 d246ca4e), that the console builds form, viewer and notepad as member instances with no incident page and no repair call. Then close d35e0de8 with the evidence. If it still fails, root-cause it on d35e0de8 first. Plan: docs/sprint-683-master-execution-plan.md.
