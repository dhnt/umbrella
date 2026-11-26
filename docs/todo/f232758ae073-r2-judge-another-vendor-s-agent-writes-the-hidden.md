---
id: f232758ae073
kind: test
title: 'R2 judge: another vendor''s agent writes the hidden cases and controls'
seq: 783
status: todo
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.856413Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

A binding from a different vendor than R1 writes independent hidden cases (private store) for the second app, following kb runbook spec-to-source-drill: documented behaviour only, one form of state per case, fresh HOME. Done when the reference passes 3 of 3 through the Sprint 723 grader and the empty workspace fails; digests recorded before any builder run. This binding is not a builder in R3. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.
