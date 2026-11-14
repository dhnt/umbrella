---
id: 80394689a60f
kind: bug
title: 'R1 Deferred reminders are accepted while the schedule engine is off: preflight hint + engine state'
seq: 275
status: todo
priority: p1
labels:
    - scheduler
created: 2026-11-14T22:23:12.355952Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

Finding (dev box, 2026-11-14): bashy schedule add --at/--cron/--every, bashy notify --in/--at, and the at/batch/crontab applets all persist jobs into coreutils/pkg/schedule, but the fleet unit yoke/pkg/fleet/baseline/services/schedule.yaml is opt-in and disabled by default; no schedule daemon was running; bashy schedule list --json showed 7 enabled jobs with next_run weeks in the past and last_run zero. No front door warns, so every reminder on the host is accepted and never fires. This is the only reminder route the calendar decision (bashy docs/calendar-decision.md §3) relies on.
Root cause (classified: product gap, not venue): opt-in service + no preflight in the submitting commands; coreutils/pkg/schedule has no engine-state check (only claimDaemonAdmission lockfile in service.go).
Fix shape (small, baseline-proven): when no daemon lock holder exists and the schedule unit is disabled, schedule add / notify --in|--at / at / batch / crontab print one stderr hint naming bashy service enable schedule or bashy schedule tick; never block (guard escape-hatch rule); schedule list and --json carry engine state (daemon pid or none, unit enabled/disabled, overdue job count). Targeted tests in coreutils/pkg/schedule and yoke/pkg/bus only.
Done when: disabled engine -> hint printed and job still stored; enabled engine -> no hint; schedule list shows engine state; existing schedule/bus tests green. Related: bashy docs/todo/8624c8fab52e (durable time orchestration: fired-job record, lease/ack/retry, persisted tz) stays separate.
