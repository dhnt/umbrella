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
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

No dependency on S1: Session is event-sourced (examples/session/lib/run.py log) and serves the same contract from the log it already keeps. Every event records its author (owner, or the participant's name). session history N [--json] lists the log in the contract's JSON (revision, author, created, event, step). session undo N reverses the last owner change: time, reorder, pause/resume, skip, done; the reorder event also records the order it replaced. goto stays the verb for going back to any step. No new store. Unit tests in examples/session/tests/test_run.py: author on events, history shape, undo of each event kind, undo with an empty log refused. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

Read the sprint card and execution plan. Work in an isolated bashy checkout. Fetch touched repositories and siblings, check origin default heads, umbrella pins and bashy mod drift. The one-pin bashy/ycode cycle is expected. Record the base SHA and pass the story build and unit suite before editing. Stop and report if scope must expand.

Run builds and unit tests only in the assigned gate-host Linux lane. The manager reserves the lane and releases it after evidence. Require gate-lane check to print ok, then use gate-lane run for every command. Use the prepared bin directory under the lane root. Test each desk module from its directory with GOWORK=off. Use an isolated story directory. No integration or end-to-end runs.

For a formerly green test failure, stop and report names, commit and venue for investigation. Compare with last green, bisect and record product, test or venue cause on the story before a repair assignment. Keep every existing test enabled. Fetch and rebase before submitting. Preserve the candidate and redo against fresh heads if the rebase is nontrivial. Re-run the story suite on the submitted SHA. Supply branch, commit, commands, counts and exits, baseline and candidate evidence. Include Sprint, Story, Story-ID and Agent trailers. The manager owns merges, tags, proxy publication, pin updates and pushes. Use host roles in all public evidence.

The manager reserved gate lane 3 for this story.
