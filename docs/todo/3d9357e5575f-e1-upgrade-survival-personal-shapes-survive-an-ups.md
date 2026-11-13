---
id: 3d9357e5575f
kind: spike
title: 'E1 upgrade survival: personal shapes survive an upstream upgrade of each catalog app'
seq: 227
status: todo
priority: p1
labels:
    - shaping-eval
created: 2026-11-13T14:34:20.095378Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

THINK OUT OF THE BOX (operator, 2026-11-13): software shaping breaks away from the traditional SDLC, so its practices for software upgrade and data management must too. Design them the agentic-friendly way (agents do the rebasing, migrating, verifying and explaining; owners approve in plain words) instead of copying release trains, change tickets and DBA runbooks. Prior art to beat, not to copy: Sprint 625 X1 (consensus vs personal), X3 (expand-migrate-contract), X6 (upstream releases). Scope: Linux + web UI; runtime proofs only on the claimed gate-linux resource, never the dev box. READ docs/shapeable-apps-worker-brief.md.
Goal: for each catalog app (notes, form, clip, site, table, board, whiteboard, files), apply a personal shape, move the pinned fork to a newer upstream, and show the shape still works, or is clearly flagged with an agent-proposed fix the owner can approve. Never a silent break or a lost shape. Measure: survived / auto-rebased / flagged / broken per app. Design the agent-first upgrade flow (who notices the new upstream, who rebases, how the owner hears about it) and record it.
