---
id: eac13ecfc779
kind: spike
title: 'E2 data-safe shaping: wishes that touch data on a running app with seeded data'
seq: 228
status: todo
priority: p3
labels:
    - shaping-eval
created: 2026-11-13T14:34:20.244527Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

THINK OUT OF THE BOX (operator, 2026-11-13): software shaping breaks away from the traditional SDLC, so its practices for software upgrade and data management must too. Design them the agentic-friendly way (agents do the rebasing, migrating, verifying and explaining; owners approve in plain words) instead of copying release trains, change tickets and DBA runbooks. Prior art to beat, not to copy: Sprint 625 X1 (consensus vs personal), X3 (expand-migrate-contract), X6 (upstream releases). Scope: Linux + web UI; runtime proofs only on the claimed gate-linux resource, never the dev box. READ docs/shapeable-apps-worker-brief.md.
Goal: on apps with real seeded data (table first), run wishes that change data or schema (a new field, a derived status, a reminder rule). Each must go through a safe, previewable migration or be refused with a reason; undo must never lose data; another user's view must be unaffected. Measure: data loss incidents (target 0), refused vs migrated, undo fidelity. Design the agent-friendly data practice (snapshots, shadow copies, reversible migrations, plain-language diffs of data impact).
