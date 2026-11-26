---
id: 302a91ea9f57
kind: enhancement
title: 'R3 Overdue todo reminder: notify the owner when a due item passes its deadline (schedule+notify pattern, .bsh custom command)'
seq: 277
status: todo
priority: p3
labels:
    - todo
created: 2026-11-14T22:23:12.636488Z
---

Triage 2026-11-25: moved out of Sprint 637 (a8b3d759) to keep that sprint on its MVP (a reminder fires or says why). This is a new feature, kept as a standalone todo for later planning.
bashy todo has --due and --recurring and todo.go has IsOverdue (todo --json already carries overdue), and yoke/pkg/todo/notify.go notifies an assignee on assignment, but nothing notifies when an item becomes overdue. Model: bashy/examples/llm-usage/usage-alarm.bsh (a schedule-run .bsh that calls bashy notify). Shape: an examples/ .bsh custom command (todo-overdue-alarm) that lists overdue items with --json, notifies each owner once per item (idempotent marker), and documents the schedule add --every line that runs it; not core unless a primitive is missing. Benefits from Sprint 637 R1 (80394689a60f) so the user sees when the engine is off. Done when: a seeded overdue item produces exactly one bashy notify to its owner across two ticks; --dry-run and --json supported.
