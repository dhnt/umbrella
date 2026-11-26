---
id: b23982703c71
kind: task
title: O0 Confirm the console builds the desk-family apps as member instances from the module proxy; close d35e0de8
seq: 714
status: wontfix
priority: p2
labels:
    - shaping
created: 2026-11-24T19:03:06.172485Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
closed: 2026-11-26T11:16:12.140339Z
---

Todo d35e0de8 (p0) is still open, but bashy main fixed its cause: 56b5b1a1 (kit and chart are published modules, no sibling replace), 6a10293f and 9a24fd30 (module proxy for fork homes, yoke dcccc0fa). Confirm on the gate host, with a current bashy (703 F11 d246ca4e), that the console builds form, viewer and notepad as member instances with no incident page and no repair call. Then close d35e0de8 with the evidence. If it still fails, root-cause it on d35e0de8 first. Plan: docs/sprint-683-master-execution-plan.md.

Moved 2026-11-24 (operator) from Sprint 683 to Sprint 703 so it proceeds with D4 90f03f54; it does not depend on the UI decisions 683 is held for. 683 O1 still depends on it.

## Moved to Sprint 683 (2026-11-24, operator: close Sprint 703)

Owner publishing (offer, adopt) is Sprint 683's workflow, held on 705 S3; this story travels with it instead of being dropped.
