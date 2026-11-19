---
id: 3d9357e5575f
kind: spike
title: 'E1 upgrade survival: personal shapes survive an upstream upgrade of each catalog app'
seq: 227
status: wontfix
priority: p3
labels:
    - shaping-eval
    - shelved
created: 2026-11-13T14:34:20.095378Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-19T14:31:20.598906Z
---

THINK OUT OF THE BOX (operator, 2026-11-13): software shaping breaks away from the traditional SDLC, so its practices for software upgrade and data management must too. Design them the agentic-friendly way (agents do the rebasing, migrating, verifying and explaining; owners approve in plain words) instead of copying release trains, change tickets and DBA runbooks. Prior art to beat, not to copy: Sprint 625 X1 (consensus vs personal), X3 (expand-migrate-contract), X6 (upstream releases). Scope: Linux + web UI; runtime proofs only on the claimed gate-linux resource, never the dev box. READ docs/shapeable-apps-worker-brief.md.
Goal: for each catalog app (notes, form, clip, site, table, board, whiteboard, files), apply a personal shape, move the pinned fork to a newer upstream, and show the shape still works, or is clearly flagged with an agent-proposed fix the owner can approve. Never a silent break or a lost shape. Measure: survived / auto-rebased / flagged / broken per app. Design the agent-first upgrade flow (who notices the new upstream, who rebases, how the owner hears about it) and record it.

## Review disposition against Sprint 669 (2026-11-19)

Operator confirmed replacement reference is Sprint 669 (2f346ac0-20ce-5354-88b9-b74ef3f567a9) and authorized closing or shelving irrelevant remaining Sprint 632 work. E1 all-eight-catalog-app upgrade survival and replay/regeneration evaluation is outside Sprint 669. M8 (29b32352db14) and M11 (b28bcd4d2620) retain exact-instance compatible/incompatible upgrades and reversal evidence, not general upstream rebase/replay success. Shelve broad catalog testing; no replay engine or upgrade result is claimed.

Closed wontfix to shelve remaining scope, not accepted as delivered. Original requirements and prior evidence/failures preserved above. Accepted phase-one stories remain unchanged. No coding, workers, fresh tests, installation, deployment or publication. Existing security and release gates remain binding.
