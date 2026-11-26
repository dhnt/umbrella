---
id: da90afb1a1dc
kind: bug
title: bashy supervisor test starts a real schedule daemon on the host job store (missing BASHY_SCHEDULE_STATE isolation)
seq: 781
status: done
priority: p2
labels:
    - scheduler
    - test
created: 2026-11-26T06:22:41.379383Z
assignee: agy-gemini4-neon
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
closed: 2026-11-26T06:32:54.032566Z
closed_by: claude-fable5.2
---

Found during Sprint 637 R6 (e79e4ac55079), 2026-11-25. Root cause corrected the same day after reading the test harness (the first filing blamed only the missing scheduler-state isolation).

## Root cause (code inspected 2026-11-25, bashy main 293477c9)

`TestServiceMonitorSeedInternalAndCustomShareOneMechanism` (bashy `internal/agentos/supervisord_service_test.go`) enables the `schedule` unit, whose exec is `bashy schedule daemon`. The supervisor runs an exec of `bashy` as `bashySelfPath()` (`internal/agentos/agentos.go`): `BASHY_SELF` from the environment first, else the running executable. In a clean environment that is the test binary, which under `BASHY_SUPERVISORD_TEST_CHILD=hold` is a stub that prints its argv and blocks: no scheduler runs.

Two gaps turn that into a real scheduler on the host:

1. The test does not clear `BASHY_SELF`. When the variable is present in the environment the test runs in, the unit's child is the real bashy binary, and `bashy schedule daemon` (then `--interval=1m` after the test's override) really runs.
2. The test does not set `BASHY_SCHEDULE_STATE`. The scheduler store and daemon lock live in the user configuration directory, not under the temporary `BASHY_HOME`, so that real daemon uses the host's job store and fires every due job.

On 2026-11-22 gap 1 was open because of the adapter environment leak (story 22d478f9): `bashy dag test` passed `BASHY_SELF` down to `go test` binaries. That leak was fixed the same morning (bashy 86c645bc), so the path is closed for `bashy dag test` today, but the test still trusts its environment. Evidence on the dev box: daemon lock recorded a foreground scheduler started 04:10:56 PST; all interval jobs share the last-run instant 04:11:56 (one pass, 60 s later, matching `--interval=1m`); the session running the tests recorded this test failing with "schedule daemon already running: lock held by bashy-schedule-daemon".

Classification: test defect (the test does not isolate itself from the host). The product leak that exposed it is already fixed.

## Fix (worker rules)

1. Work only in the bashy repository (github.com/qiangli/bashy), on a new branch `fix-da90afb1` created from origin/main (293477c9 or later). Push the branch to origin. Do NOT push or merge to bashy main and do not touch pins or any other repository; the conductor merges.
2. In `TestServiceMonitorSeedInternalAndCustomShareOneMechanism`, next to the existing `t.Setenv` lines, add exactly:
   - `t.Setenv("BASHY_SELF", "")` with a one-line comment: the unit's child must be this test binary's stub, never a real bashy from the environment;
   - `t.Setenv("BASHY_SCHEDULE_STATE", filepath.Join(home, "schedule.json"))` with a one-line comment: even a real child must not reach the host scheduler store.
   No other change to that test. No product code change.
3. Check the other tests in `internal/agentos` that set `BASHY_SUPERVISORD_TEST_CHILD` with `t.Setenv` and start a unit whose exec is `bashy`. Where the same `BASHY_SELF` gap exists, add the same `t.Setenv("BASHY_SELF", "")` line and list each in the submit note. Do not refactor.
4. Run only this, on a claimed gate-host lane (`bashy claim`), never on the dev box: `GOWORK=off go test ./internal/agentos/ -run 'TestServiceMonitor|TestSupervisord' -count=1`. Then run the one named test again with `BASHY_SELF=/nonexistent/bashy` exported and confirm it still passes (proves gap 1 is closed). Report the pass list by test name.
5. One commit, trailers `Sprint: #637` / `Story: #781` / `Story-ID: da90afb1a1dc` / `Agent: <your registered name>`. Submit with the branch name and commit SHA. Keep it under 30 minutes; if blocked, submit what exists with the blocker stated.

## Done when

The named test passes on the gate host both in a clean environment and with `BASHY_SELF` set to a bogus path; no other test in the package can run a real bashy as a unit child from the environment.

## Not in scope

Moving the scheduler store under `BASHY_HOME` (a product change; raise separately if wanted).
