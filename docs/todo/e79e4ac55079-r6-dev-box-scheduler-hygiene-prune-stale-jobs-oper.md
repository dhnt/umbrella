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

## Legwork 2026-11-25 (conductor; nothing changed on the dev box)

### Cause of the 11-22 firing: test defect, not an engine that stopped

No persistent engine ran. The evidence on the dev box:

- The daemon lock file records one foreground scheduler started 2026-11-22 04:10:56 PST; its process is gone. Every interval job shares the identical last-run instant 04:11:56 (one pass, 60 s after that start); the daily cron job's last run is 03:54:21 the same morning (an earlier, equally short pass).
- At that minute a session was running bashy unit tests on the dev box. Its record names `TestServiceMonitorSeedInternalAndCustomShareOneMechanism` (bashy `internal/agentos/supervisord_service_test.go`) failing with "schedule daemon already running: lock held by bashy-schedule-daemon".
- That test sets a temporary `BASHY_HOME` and runs `service enable schedule`, but does not set `BASHY_SCHEDULE_STATE`. The scheduler store lives in the user configuration directory, not under `BASHY_HOME`, so the test's supervisor started a real `schedule daemon` on the host's real job store. It fired every due job once and ended with the test.

Classification: **test defect** (the test escapes its sandbox and runs the host's scheduled jobs). Fix where the cause lives: the test must set `BASHY_SCHEDULE_STATE` to a temporary path. Not fixed here; recorded for the operator to schedule. Confidence: high on the mechanism (lock file + test source), circumstantial on the 03:54 pass (same morning, same test activity, no separate record).

Side finding: the cloud-host reaper job's own log has no entry after 2026-10-21, so that job did not run to completion on 11-22 even though the store marked it as run.

### Job inventory and recommendation (8 jobs)

| # | Job | Every | State | Finding | Recommendation |
|---|---|---|---|---|---|
| 1 | QA poll for the bashy repository | 15m | on | Calls a bashy binary under a Go 1.26.0 toolchain path that no longer exists; cannot run | Delete |
| 2 | QA poll for the ycode repository | 15m | on | Same missing binary | Delete |
| 3 | Outpost QA run | 15m | off | Same missing binary; never ran | Delete |
| 4 | Unnamed `echo ok` test job | daily 09:00 | on | Leftover from a weave workspace that no longer exists | Delete |
| 5 | Mirror of a GitHub Pages repository into a local loom | 5m | on | The local loom endpoint it posts to is not listening | Delete, or keep disabled until that loom is back |
| 6 | CI failure router | 5m | on | Script and its configuration exist; acts on CI failures unattended | Operator decides; disable until wanted |
| 7 | Reaper for throwaway cloud hosts | 10m | on | Uses a cloud token; last completed 2026-10-21 | Keep only if throwaway hosts are still created from this box; otherwise disable |
| 8 | Disk floor alarm (100G) | 15m | on | Script exists; harmless and useful | Keep |

### Enable decision

With jobs 1-5 removed, only the disk alarm clearly earns a running engine on the dev box; 6 and 7 act on outside systems unattended. Recommendation: prune first, decide 6 and 7, then `bashy service enable schedule` only if at least one kept job is wanted continuously. Until the test defect above is fixed, any bashy unit-test run on the dev box can fire whatever is left enabled.

### Operator decisions 2026-11-25

- Jobs 1-5 deleted on the operator's approval (`bashy schedule rm`; the job store was backed up beside itself first). Three jobs remain, all enabled: the CI failure router, the cloud-host reaper and the disk floor alarm.
- The test defect is filed as da90afb1a1dc (standalone bug, p2).
- Still open: keep, disable or delete the CI failure router and the cloud-host reaper; whether to enable the schedule unit.
