---
id: 302a91ea9f57
kind: enhancement
title: 'R3 Overdue todo reminder: notify the owner when a due item passes its deadline (schedule+notify pattern, .bsh custom command)'
seq: 277
status: todo
priority: p2
labels:
    - todo
created: 2026-11-14T22:23:12.636488Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

bashy todo has --due and --recurring and todo.go has IsOverdue, and yoke/pkg/todo/notify.go notifies an assignee on assignment, but nothing notifies when an item becomes overdue. Model: bashy/examples/llm-usage/usage-alarm.bsh (a schedule-run .bsh that calls bashy notify). Shape: an examples/ .bsh custom command (todo-overdue-alarm) that lists overdue items with --json, notifies each owner once per item (idempotent marker), and documents the schedule add --every line that runs it; not core unless a primitive is missing. Depends on R1 only for the user seeing that the engine is off. Done when: a seeded overdue item produces exactly one bashy notify to its owner across two ticks; --dry-run and --json supported.
