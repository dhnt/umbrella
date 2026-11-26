---
id: e79e4ac55079
kind: chore
title: 'R6 Dev-box scheduler hygiene: prune stale jobs, operator decides on enabling the schedule unit'
seq: 280
status: todo
priority: p2
labels:
    - ops
created: 2026-11-14T22:23:13.051427Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

Operator-run. State of bashy schedule list on the dev box:
2026-11-14: 8 jobs, 7 enabled, created 2026-07-21 to 2026-11-01; next_run weeks in the past, last_run zero.
2026-11-25 (re-checked): the same 8 jobs; the enabled ones now show last_run 2026-11-22, so an engine ran after filing and then stopped; next_run is 3 days in the past; bashy service status shows the schedule unit disabled and inactive. What ran the engine and why it stopped is not known and should be recorded here.
Stale content: two qa-poll jobs and one disabled qa job call a retired Go 1.26.0 toolchain path (baseline is Go 1.27.4); one cron job is a test (echo ok); the others are mirror-ghpages, ci-failure-router, ephemeral-reap and disk-floor-alarm.
Operator: review each job, rm or disable the stale ones, then decide whether bashy service enable schedule should run on this host. Nothing is enabled without the operator.
Done when: the remaining list is intentional, the decision and the cause of the 11-22 stop are recorded here, and (if enabled) bashy schedule list shows a daemon holder.
