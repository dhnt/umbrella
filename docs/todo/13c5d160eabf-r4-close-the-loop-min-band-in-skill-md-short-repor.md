---
id: 13c5d160eabf
kind: doc
title: 'R4 close the loop: min-band in SKILL.md, short report, runbook fixes'
seq: 785
status: done
priority: p1
labels:
    - conform
created: 2026-11-26T11:23:44.601594Z
assignee: claude-fable5.2-s726
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
closed: 2026-11-26T21:34:29.135354Z
closed_by: claude-fable5.2-s726
---

Write the measured min-band into the second app's SKILL.md with the bindings and date; a short report (results table keyed to digests, limitations); update the three kb runbooks with every point where an agent had to guess, and validate the pages that proved out. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (2026-11-26)

Unchanged, with one emphasis from the operator: the two runbooks used by the roles, `shapeware-spec-from-app` (source to spec) and `shapeware-source-from-spec` (spec to source), are tested by this sprint and improved from it. Every guess or wrong instruction noted in R1 to R3 becomes an edit, made with the `bashy kb` verbs in the umbrella store and carried to bashy `kb/defaults`. The report follows `docs/sprint-731-report.md`.

## Result (2026-11-26)

- **Bounds** in bashy `examples/desk/notepad/SKILL.md` (bashy `a5edf39a`), by binding and date.
- **Report:** `docs/sprint-726-report.md` (every run with its classification, seven findings, limits, input for Sprints 730 and 734).
- **Runbooks,** edited with `bashy kb update` in the umbrella store: `shapeware-spec-from-app` (stays validated; now also proven by an agent author on a second app), `spec-to-source-drill` (stays validated; a new section for service apps), `shapeware-source-from-spec` (stays a candidate: no builder was seen using it). The two pages that ship were carried to bashy `kb/defaults` (`a5edf39a`). Only wording that is certain was applied; what needs a decision, a judge change or a lint rule is in Sprint 734, story `def02641e735` (twelve generic items, nine for notepad only).
- Not done here, by ruling: the fix of the lifecycle test's `installed` check (Sprint 734, item 11), spec v1.1, a further build round.
