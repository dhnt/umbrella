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

## Worker rules

Read the sprint card and execution plan. Work in an isolated bashy checkout. Fetch touched repositories and siblings, check origin default heads, umbrella pins and bashy mod drift. The one-pin bashy/ycode cycle is expected. Record the base SHA and pass the story build and unit suite before editing. Stop and report if scope must expand.

Run builds and unit tests only in the assigned gate-host Linux lane. The manager reserves the lane and releases it after evidence. Require gate-lane check to print ok, then use gate-lane run for every command. Use the prepared bin directory under the lane root. Test each desk module from its directory with GOWORK=off. Use an isolated story directory. No integration or end-to-end runs.

For a formerly green test failure, stop and report names, commit and venue for investigation. Compare with last green, bisect and record product, test or venue cause on the story before a repair assignment. Keep every existing test enabled. Fetch and rebase before submitting. Preserve the candidate and redo against fresh heads if the rebase is nontrivial. Re-run the story suite on the submitted SHA. Supply branch, commit, commands, counts and exits, baseline and candidate evidence. Include Sprint, Story, Story-ID and Agent trailers. The manager owns merges, tags, proxy publication, pin updates and pushes. Use host roles in all public evidence.
