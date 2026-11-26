---
id: bbb480c01f56
kind: chore
title: 'R2 NotifyEvent --notify hook: implement for at/batch/crontab/sleep/timeout or retire the stale comment'
seq: 276
status: todo
priority: p3
labels:
    - scheduler
created: 2026-11-14T22:23:12.496747Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

yoke/pkg/bus/notify.go line 37 says at, batch, crontab, sleep and timeout call NotifyEvent once their event occurs for a shared --notify flag. Survey 2026-11-14, re-checked 2026-11-25 (yoke d617ba6a): nothing calls NotifyEvent except notify itself (notify.go:244) and yoke/pkg/todo/notify.go:59; none of the five applets has a --notify flag.
Triage 2026-11-25 (default, operator may change): delete the stale comment, do not implement. bashy notify --in DUR already is the one-line reminder; wiring --notify into five applets is feature work on POSIX names. Rewrite the comment to describe the actual callers.
Done when: the comment matches the code (own commit in yoke).
