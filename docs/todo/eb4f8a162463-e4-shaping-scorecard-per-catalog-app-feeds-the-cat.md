---
id: eb4f8a162463
kind: task
title: E4 shaping scorecard per catalog app (feeds the catalog-moat metrics)
seq: 230
status: todo
priority: p2
labels:
    - shaping-eval
created: 2026-11-13T14:34:20.590011Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

THINK OUT OF THE BOX (operator, 2026-11-13): software shaping breaks away from the traditional SDLC, so its practices for software upgrade and data management must too. Design them the agentic-friendly way (agents do the rebasing, migrating, verifying and explaining; owners approve in plain words) instead of copying release trains, change tickets and DBA runbooks. Prior art to beat, not to copy: Sprint 625 X1 (consensus vs personal), X3 (expand-migrate-contract), X6 (upstream releases). Scope: Linux + web UI; runtime proofs only on the claimed gate-linux resource, never the dev box. READ docs/shapeable-apps-worker-brief.md.
Per catalog app: success rate over 10 representative wishes, verifier catches, undo works, upgrade survival (from E1), data safety (from E2), cost per wish (tokens and money), time to first use. One compact table per app plus a roll-up; feeds the private investor metrics (catalog size, promoted shapes) and replaces the estimated per-change cost in the private cost comparison with measured numbers.
