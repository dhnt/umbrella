---
id: 5a3025637c52
kind: feature
title: 'S3 Session: author on every event, session history, session undo'
seq: 687
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-24T07:30:49.142471Z
assignee: claude-opus5.5
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

No dependency on S1: Session is event-sourced (examples/session/lib/run.py log) and serves the same contract from the log it already keeps. Every event records its author (owner, or the participant's name). session history N [--json] lists the log in the contract's JSON (revision, author, created, event, step). session undo N reverses the last owner change: time, reorder, pause/resume, skip, done; the reorder event also records the order it replaced. goto stays the verb for going back to any step. No new store. Unit tests in examples/session/tests/test_run.py: author on events, history shape, undo of each event kind, undo with an empty log refused. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

Read the sprint card and execution plan. Work in an isolated bashy checkout. Fetch touched repositories and siblings, check origin default heads, umbrella pins and bashy mod drift. The one-pin bashy/ycode cycle is expected. Record the base SHA and pass the story build and unit suite before editing. Stop and report if scope must expand.

Run builds and unit tests only in the assigned gate-host Linux lane. The manager reserves the lane and releases it after evidence. Require gate-lane check to print ok, then use gate-lane run for every command. Use the prepared bin directory under the lane root. Test each desk module from its directory with GOWORK=off. Use an isolated story directory. No integration or end-to-end runs.

For a formerly green test failure, stop and report names, commit and venue for investigation. Compare with last green, bisect and record product, test or venue cause on the story before a repair assignment. Keep every existing test enabled. Fetch and rebase before submitting. Preserve the candidate and redo against fresh heads if the rebase is nontrivial. Re-run the story suite on the submitted SHA. Supply branch, commit, commands, counts and exits, baseline and candidate evidence. Include Sprint, Story, Story-ID and Agent trailers. The manager owns merges, tags, proxy publication, pin updates and pushes. Use host roles in all public evidence.

Confirm the manager’s current gate lane reservation before each test run.

Supervisor observed two baseline Session suite hangs over 35 minutes at bashy 6d88b2ac, during session.bsh demo invoking sprint add, following two errors and one failure. Investigate on the gate host with bounded commands before feature work. Report failing and hanging test names, last-green comparison, bisection and classification for the manager to record here before a fix.

## Baseline investigation

The last recorded green Session suite at b7d70e4c ran 65 tests. At 6d88b2ac, run 198 bisected the unrelated-workspace registration test failure to 610c959f (parent b28edcec). Bare serve now starts the host listener. The test fixture still expected a standalone build and exit. The fixture repair at e7d329a4 exercises the supported standalone build with an unrelated GOWORK and retains its assertions. All five registration tests passed on the gate in 147.737 seconds.

The real registration rehearsal and the demo pipe and SIGINT tests also encountered cold Go builds under each test’s temporary HOME. Run 198 classified this as a venue issue. The lane wrapper now supplies explicit warm GOCACHE and GOMODCACHE and honors per-run overrides (umbrella 3d9c0e594). With the original deadlines, the pipe test passed in 25.6 seconds, SIGINT in 51.5 seconds and registration rehearsal in 107.4 seconds.

At e7d329a4 the full gate suite ran 65 tests in 796.140 seconds. Both dispatch forms of Flows.test_demo_verb_and_dag failed the same unchanged snapshot assertion. Run 210 traced the eleven extra paths to Go 1.27.4 telemetry during the cold DAG adapter build before the demo enters its sandbox. The test is unchanged since b7d70e4c. Commit 8a36ca1f moved DAG dispatch from the binary to the Go-built adapter. Warm module and build caches had removed the dependency files from the temporary home, leaving the Go telemetry files. The unchanged snapshot test passed with an isolated XDG_CONFIG_HOME (53.147 seconds) or a source-matched warm adapter cache (44.240 seconds). The supervisor classified the ordering as a fixture defect. Run 213 warms the DAG adapter in the same temporary environment before the initial snapshot. Both dispatch forms then passed, and a deliberate demo write still failed both assertions.

Run 199 observed two live demo parents and 19 descendants, including a session-server, after the cold SIGINT readiness assertion failed before the fixture sent the signal. The fixture did not register cleanup for that early exit. Both warm dispatch forms passed and left zero descendants. The supervisor authorized a small independent fixture teardown repair or a follow-up todo if the repair requires product or tooling changes. This investigation does not block fresh feature assignment once the full current baseline is green.

## Fresh feature assignment

The supervisor-approved fixture repair landed at bashy f00ac06f, umbrella pin c6f1e78ab. The manager verified the exact merged head on gate lane 2 with GOWORK=off. The Session Go build and Go units exited zero. The full Python suite ran 65 tests in 780.660 seconds, exit zero, with no remaining descendants. Confirm the source and matching receipt before editing. Start the feature fresh from this pushed head. The abandoned pre-baseline feature is reference only.

Use the existing event log for owner and participant authors, the prescribed history fields, and undo of each owner change specified above. Exercise the normal command entry points and preserve existing log readability. The independent demo-fixture teardown has a separate worker. The manager has reserved gate lane 2 for this assignment. Build and test within the full checkout, run the focused Session tests while iterating, then run the entire Session Go and Python unit suites on the final commit with a descendant guard. Report the candidate SHA as soon as it is ready for review, and the gate receipts as soon as they finish.
