---
id: 47a76966edf4
kind: feature
title: G2 Share verbs address an item (HOST/APP/ITEM) with a role; member invites inside a circle
seq: 577
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:42:54.605828Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

Extend bashy share add|ls|rm|who to take an item path and a role instead of adding a new command family. Reuse the existing rule evaluator and JSON. A member (not only the owner) may add a circle member, human or agent, to an item at a role no higher than their own; the owner-only setting refuses with a logged, actionable message. Same JSON on the web page and the CLI. Unit tests on the evaluator table; one CLI test for member-invite and for the cap. Contract: G1, docs/plan-group-participation.md.
