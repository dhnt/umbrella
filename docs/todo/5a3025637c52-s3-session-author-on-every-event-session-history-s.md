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
