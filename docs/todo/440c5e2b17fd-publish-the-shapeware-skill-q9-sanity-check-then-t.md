---
id: 440c5e2b17fd
kind: task
title: 'Publish the shapeware skill: Q9 sanity check, then the spec, agent card and scripts as a shapeware folder in the shapeware org'
seq: 754
status: todo
priority: p2
labels:
    - software-shaping
    - docs
created: 2026-11-25T15:44:23.11992Z
---

Operator-approved follow-on from Sprint 712 (Q1, Q9; docs/sprint-712-recommendation.md section 10).

1. Q9 sanity check: confirm that the 1992-95 Shapeware Corporation (later Visio) USPTO filings are dead before public use of the word. This is not a registration; shapeware is a category word.
2. Then publish, as a shapeware folder itself (dogfood D18), in the github.com/shapeware org: the spec (docs/shapeware-spec-v0.md, updated after the vendor review), the agent card (references/shapeware.md) and the lint and release-class skill-scripts (spec Appendix B).
Acceptance: the folder passes its own lint and the strict skills-ref validator; a fresh agent with no context can run the lint on hello from the published copy.
