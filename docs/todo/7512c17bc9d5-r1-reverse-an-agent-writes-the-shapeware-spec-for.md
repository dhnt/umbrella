---
id: 7512c17bc9d5
kind: feature
title: 'R1 reverse: an agent writes the shapeware spec for the second app'
seq: 782
status: todo
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.465764Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

One binding (spec author) writes CONTRACT.md, features.yaml, examples and the behaviour section of SKILL.md for the second app, following kb runbook shapeware-spec-from-app. Done when conform spec check is clean, the reference certifies (3 runs, no noisy assertion) and every mutant is killed, all on a gate lane. No change to the app's behaviour. The conductor gates; it does not write the spec. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.
