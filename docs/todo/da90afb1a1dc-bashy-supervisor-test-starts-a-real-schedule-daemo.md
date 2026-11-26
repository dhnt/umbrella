---
id: da90afb1a1dc
kind: bug
title: bashy supervisor test starts a real schedule daemon on the host job store (missing BASHY_SCHEDULE_STATE isolation)
seq: 781
status: todo
priority: p2
labels:
    - scheduler
    - test
created: 2026-11-26T06:22:41.379383Z
---

Found during Sprint 637 R6 (e79e4ac55079), 2026-11-25. Not fixed.

**Defect (test, not product).** `TestServiceMonitorSeedInternalAndCustomShareOneMechanism` in bashy `internal/agentos/supervisord_service_test.go` sets a temporary `BASHY_HOME` and runs `service enable schedule`, but never sets `BASHY_SCHEDULE_STATE`. The scheduler store and its daemon lock live in the user configuration directory, not under `BASHY_HOME`, so the test's supervisor starts a real `schedule daemon` on the host's real job store. Every due job on the machine fires once, and the test itself fails with "schedule daemon already running: lock held by bashy-schedule-daemon" when a scheduler is already up.

**Evidence.** On the dev box the daemon lock file recorded a foreground scheduler started 2026-11-22 04:10:56 PST; all interval jobs share the last-run instant 04:11:56; a session running bashy unit tests at that minute recorded this test failing with the lock message. Full record on e79e4ac55079.

**Fix shape (smallest).** In the test, `t.Setenv("BASHY_SCHEDULE_STATE", filepath.Join(home, "schedule.json"))` before enabling the unit. Then check the other tests in that file and package that enable or start the `schedule` unit for the same gap.

**Done when.** The test passes with a host scheduler running; running it leaves the host job store and daemon lock untouched (compare modification times before and after, on a gate-host lane); no other test in the package reaches the host scheduler store.

**Not in scope.** Moving the scheduler store under `BASHY_HOME` (a product change; raise separately if wanted).
