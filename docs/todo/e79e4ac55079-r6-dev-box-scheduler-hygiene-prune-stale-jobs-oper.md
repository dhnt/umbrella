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

bashy schedule list --json on the dev box (2026-11-14): 8 jobs, 7 enabled, created 2026-07-21 to 2026-11-01; several reference a retired Go toolchain path and old workspace directories; next_run values are 2026-10-21 and 2026-11-01 with last_run zero, i.e. none has fired since the unit was last running. Operator-run: review each job (qa polls, mirror-ghpages, ci-failure-router, ephemeral-reap, disk-floor-alarm), rm or disable the stale ones, then decide whether bashy service enable schedule should run on this host. Nothing is enabled without the operator. Done when: the remaining list is intentional, the decision is recorded here, and (if enabled) bashy schedule list shows a daemon holder.
