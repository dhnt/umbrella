---
id: 6a4586c79dfe
kind: spike
title: 'E3 beachhead scenario vs baseline: unpaid-orders reminder + stats page, shaping vs AI coding agent + SaaS config'
seq: 229
status: todo
priority: p1
labels:
    - shaping-eval
created: 2026-11-13T14:34:20.439103Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

THINK OUT OF THE BOX (operator, 2026-11-13): software shaping breaks away from the traditional SDLC, so its practices for software upgrade and data management must too. Design them the agentic-friendly way (agents do the rebasing, migrating, verifying and explaining; owners approve in plain words) instead of copying release trains, change tickets and DBA runbooks. Prior art to beat, not to copy: Sprint 625 X1 (consensus vs personal), X3 (expand-migrate-contract), X6 (upstream releases). Scope: Linux + web UI; runtime proofs only on the claimed gate-linux resource, never the dev box. READ docs/shapeable-apps-worker-brief.md.
Scenario: a small-business owner with no programming skills says: 'every order unpaid for more than 3 days, remind the customer automatically, and add a statistics page'. Run it on the shaped table app with seeded orders (a non-programmer persona issues the wish), and run the same task with the baseline: a general AI coding agent plus SaaS configuration/automation. Measure for both: success, wall time, owner effort, token and money cost, breakage caught by verification, reversibility. Report honestly, including where the baseline wins. Conductor-run (judgment needed).
