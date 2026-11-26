---
id: 13c5d160eabf
kind: doc
title: 'R4 close the loop: min-band in SKILL.md, short report, runbook fixes'
seq: 785
status: todo
priority: p1
labels:
    - conform
created: 2026-11-26T11:23:44.601594Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

Write the measured min-band into the second app's SKILL.md with the bindings and date; a short report (results table keyed to digests, limitations); update the three kb runbooks with every point where an agent had to guess, and validate the pages that proved out. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (2026-11-26)

Unchanged, with one emphasis from the operator: the two runbooks used by the roles, `shapeware-spec-from-app` (source to spec) and `shapeware-source-from-spec` (spec to source), are tested by this sprint and improved from it. Every guess or wrong instruction noted in R1 to R3 becomes an edit, made with the `bashy kb` verbs in the umbrella store and carried to bashy `kb/defaults`. The report follows `docs/sprint-731-report.md`.
