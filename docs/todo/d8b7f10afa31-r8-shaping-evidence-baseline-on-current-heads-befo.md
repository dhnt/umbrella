---
id: d8b7f10afa31
kind: test
title: R8 Shaping evidence baseline on current heads before R5 (1a/1b record)
seq: 620
status: wontfix
priority: p2
labels:
    - shaping
created: 2026-11-21T21:59:33.759421Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T20:13:52.776835Z
---

Record one shared evidence record that consumer (per-person version) and producer (wish, verify, approve, undo, restore, release, offer/adopt for web apps) shaping pass on current heads: targeted unit tests for yoke/pkg/shape/..., yoke/pkg/src/... and bashy internal/agentos shape tests, run on the gate host (never the dev box). Light verification only.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Folded into R5 (5c1b07e994f1) step 0: the CLAUDE.md start-on-current-heads rule already requires the bump, build and unit tests R5 runs; R5 records that run as this baseline evidence record.
