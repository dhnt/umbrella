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
assignee: agy-gemini4-neon
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

Finding (dev box, 2026-11-14): bashy schedule add --at/--cron/--every, bashy notify --in/--at, and the at/batch/crontab applets all persist jobs into coreutils/pkg/schedule, but the fleet unit yoke/pkg/fleet/baseline/services/schedule.yaml is opt-in and disabled by default; no front door warns when no engine is running, so reminders are accepted and never fire.
Update 2026-11-25: the jobs on the dev box now show last_run 2026-11-22 (an engine ran after filing, then stopped silently); the unit is disabled and inactive; 7 enabled jobs are 3 days overdue, still with no warning anywhere. The gap is unchanged.
Root cause (classified: product gap, not venue): opt-in service + no preflight in the submitting commands; coreutils/pkg/schedule has no engine-state check (only claimDaemonAdmission in service.go).
Code inspected 2026-11-25 (coreutils f9833f72, yoke d617ba6a, bashy 6af53a3c): still no engine-state code; one commit since filing (219d672b) touched shell paths only. Reusable: coreutils/pkg/lockfile Owner(path) (read-only holder lookup), coreutils/pkg/nudge (bashy-hint-v1 emitter, off with BASHY_HINTS=off).
Operator decision 2026-11-25: one scheduler code base. Change coreutils/pkg/schedule in place (no duplicate in yoke), coordinated with the Sprint 385 (POSIX certification preparation) manager because POSIX is not yet certified. R1 does not start until that manager answers; the answer and merge window are recorded here; the coreutils commit is reviewed by that manager before merge.
Fix shape (MVP): exported EngineState() next to claimDaemonAdmission: lock holder via lockfile.Owner (never takes the lock) + count of enabled jobs whose next_run is past. schedule list prints one engine line and --json gains an engine object. The schedule add command handler and yoke notify --in/--at emit one hint via pkg/nudge when no daemon holds the lock, naming bashy service enable schedule or bashy schedule tick; never block; job always stored; exit code unchanged. Nothing added to the stored job format. Two commits: coreutils first, then yoke pkg/bus/notify.go.
Not in MVP: hint on at/batch/crontab (POSIX names; their output stays byte-identical unless the Sprint 385 manager says otherwise); unit enabled/disabled in engine state (coreutils cannot import yoke).
First step for the worker: confirm the call path from at/batch/crontab into the store so the hint cannot reach them.
Done when: no daemon -> hint printed and job still stored; daemon holder present -> no hint; BASHY_HINTS=off -> no hint; schedule list and --json show engine state; at/batch/crontab output unchanged with the engine off; existing schedule/bus/at/batch/crontab tests green by name; Sprint 385 manager answer and review recorded here. Targeted unit tests only, on a gate-host lane. Related: bashy docs/todo/8624c8fab52e (durable time orchestration) stays separate.
Sprint 385 manager answer (agy-gemini4-carbon, 2026-11-25, also on the Sprint 385 thread): (a) none of the 67 non-pass items touches pkg/schedule, pkg/lockfile, the job format, the daemon lock or at/batch/crontab; keep `coreutils schedule daemon --interval 1s`, BASHY_SCHEDULE_STATE and the schedule lock files unchanged (385 story 81a222a1cba3 depends on them). (b) The certification suite never runs schedule list or schedule add; the at-family applets call pkg/schedule Go APIs directly. The hint must be off under POSIXLY_CORRECT=1, BASHY_HINTS=off and BASHY_TELEMETRY_QUIET=1. (c) Strictly no hint on at/batch/crontab/atq/atrm: stdout and stderr stay byte-identical. (d) Branch from coreutils main f9833f72 (the posix-baseline tag of 2026-11-24). HOLD the merge to coreutils main until the Sprint 385 Phase 1 checkpoint rules whether f9833f72 stays the frozen candidate. Send the commit SHA to the 385 manager for review.
Added to done-when: hint suppressed under POSIXLY_CORRECT=1 and BASHY_TELEMETRY_QUIET=1 (tests for each); R1 coreutils work lives on a branch until the 385 manager releases the merge hold.
Worker rules for commit 1 (R1a, coreutils), fixed before assignment:
1. Work only in the coreutils repository (github.com/qiangli/coreutils), on a new branch s637-r1 created from f9833f72. Push that branch to origin. NEVER push or merge to coreutils main: the merge is on hold by the Sprint 385 manager. Do not change the umbrella pin, go.mod files, yoke or bashy.
2. Touch only pkg/schedule (source + tests). Do not edit cmds/at, cmds/batch, cmds/crontab, pkg/lockfile, the job struct, statePath, or either lock filename (schedule.lock, schedule-daemon.lock).
3. First confirm and write down in the submit note which pkg/schedule functions at/batch/crontab call, and that none of them reaches the new hint.
4. The hint is emitted only from the cobra `schedule add` handler, through pkg/nudge, and is suppressed when POSIXLY_CORRECT=1, BASHY_HINTS=off or BASHY_TELEMETRY_QUIET=1.
5. Tests: targeted only, GOWORK=off go test ./pkg/schedule/... ./cmds/at/... ./cmds/batch/... ./cmds/crontab/... on a claimed gate-host lane (bashy claim), not on the dev box. No full suite, no conformance run. Report test names added and the pass list.
6. One commit, trailers Sprint: #637 / Story: #275 / Story-ID: 80394689a60f / Agent: <your registered name>. Submit with the branch name and commit SHA. Keep it under 30 minutes; if blocked, submit what exists with the blocker stated.
Commit 2 (R1b, yoke notify hint) is NOT part of this assignment; it waits for the coreutils merge.

## Sprint 385 review of R1a (2026-11-25)

The Sprint 385 manager reviewed coreutils branch s637-r1 (bef90e27) and approved it from the POSIX side. The "engine:" first line in `schedule list` and the transient lockfile.Owner probe do not affect the conformance run (it uses a private schedule state directory and never invokes `schedule list` or `schedule add`). The merge HOLD stays: coreutils main remains f9833f72 until the Sprint 385 Phase 1 checkpoint.

## R1b worker rules (yoke; prepared on a branch while the hold stands)

1. Work only in the yoke repository (github.com/qiangli/yoke), on a new branch s637-r1b created from origin/main (efe0bed7). Push that branch to origin. NEVER push or merge to yoke main, and do not touch coreutils, bashy or the umbrella pins: the merge waits for the coreutils hold to lift.
2. go.mod: change only the one require line for github.com/qiangli/coreutils to v0.0.0-20261126020849-bef90e271000 (branch s637-r1), plus the go.sum lines that follow. Edit the line by hand; do not let `go get` or `go mod tidy` reformat go.mod. Leave the goawk replace line alone.
3. pkg/bus/notify.go: in NewNotifyCmd, after ScheduleNotify succeeds for --in/--at, call schedule.HintIfEngineOff(cmd.ErrOrStderr(), "notify") once (both text and --json paths; the hint goes to stderr only, stdout stays the receipt). No other change: the job is always stored, the exit code and receipt are unchanged, no new hint text or suppression logic in yoke (coreutils owns both).
4. Tests in pkg/bus/notify_test.go, on a scratch BASHY_SCHEDULE_STATE: (a) no daemon lock holder: `notify --in` stores the job and stderr carries the engine-off hint; (b) BASHY_HINTS=off: no hint, job stored; (c) --json: stdout is exactly the receipt JSON. Existing tests stay green by name.
5. Run only GOWORK=off go test ./pkg/bus/... on a claimed gate-host lane (bashy claim), not on the dev box. No full suite. Report test names added and the pass list.
6. One commit, trailers Sprint: #637 / Story: #275 / Story-ID: 80394689a60f / Agent: <your registered name>. Submit with the branch name and commit SHA. Keep it under 30 minutes; if blocked, submit what exists with the blocker stated.
