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

yoke/pkg/bus/notify.go line ~37 says at, batch, crontab, sleep and timeout call NotifyEvent once their event occurs for a shared --notify flag. Survey 2026-11-14: nothing calls NotifyEvent except notify itself and yoke/pkg/todo/notify.go; none of the five applets has a --notify flag (bashy sleep/timeout/at --help show none). Decide: either wire --notify TARGET SUBJECT into the five applets through their common host layer as the comment intends (then sleep 10m --notify me 'tea' is a one-line reminder), or delete the comment. Done when: the comment matches the code; if implemented, one applet test per command.
