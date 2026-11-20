---
id: 3d3ca7b1c6ca
kind: feature
title: 'G3 Artifact revisions in the shared kit: save is a revision, history, revert, stale save refused'
seq: 578
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:42:54.820612Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

Implement the revision rule once in examples/desk/kit so shaped artifact apps (notepad first) get it without each inventing it: every save records author (member, and agent name when acting through one) and time; list revisions; revert to one; a save whose base is not the latest revision is refused with both revisions returned; reopen and reconnect show the latest. No live merge engine. CLI verbs with --json for list, revert and save-with-base. Contract: G1, docs/plan-group-participation.md.
