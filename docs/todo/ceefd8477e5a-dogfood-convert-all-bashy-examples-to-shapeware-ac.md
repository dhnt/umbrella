---
id: ceefd8477e5a
kind: task
title: 'Dogfood: convert all bashy examples to shapeware across vendor models (after spec v1.0 draft + form PoC)'
seq: 755
status: todo
priority: p2
labels:
    - software-shaping
created: 2026-11-25T16:08:17.164892Z
---

Operator proposal 2026-11-25 (Sprint 712, record D22; docs/sprint-712-recommendation.md section 10).
When: after the shapeware spec reaches a v1.0 draft and the form proof of concept (Sprint 721) is done.
What: convert every example under bashy/examples/ to a shapeware folder per the spec (type line and run block, dag.md lifecycle with source/build/test/install/run, features.yaml, checks with candidate.bsh, known issues). Assign conversions across models from different vendors (codex, agy/Gemini, muse, GLM, Claude) so the spec is tested by many readers, not one.
Gate per example: the lint passes; candidate.bsh grades a field change; one unaware-agent run uses it without hints.
Output: every point where a converting model guessed or got stuck becomes a spec issue. The spec moves from the v1.0 draft to v1.0. Absorbs bashy ae527623 (per-category pilots).
Plan as its own sprint, reviewed with the operator before it starts (it is a mass change: a written plan with scope, owners, budget and rollback first).
