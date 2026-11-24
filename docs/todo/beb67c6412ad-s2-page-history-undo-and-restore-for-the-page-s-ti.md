---
id: beb67c6412ad
kind: feature
title: 'S2 Page: history, undo and restore for the page''s title and body'
seq: 686
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-24T07:30:48.916131Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

After S1. examples/desk/page adopts the kit revision store for authored content only (title and body): page history ID, page undo ID, page restore ID REV, page set --base-rev R; the organizer face lists revisions with a restore button. Votes, timers, hands, participants, block owner keys and the live frame counter stay out of history and are untouched by undo or restore. Only the organizer writes content, as today; the author recorded is the organizer's participant identity. Without --base-rev a save is a recorded overwrite (today's behavior). Unit tests in examples/desk/page: content save recorded with author, stale base 409 with both revisions, undo and restore bring the body back and leave votes, timers and participants intact, a participant action creates no revision; existing tests stay green. 3 points. Plan: docs/sprint-684-685-master-execution-plan.md.
