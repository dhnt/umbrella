---
id: a7b376b417f5
kind: feature
title: S2 Claims ledger and measured command maturity
seq: 415
status: todo
priority: p2
labels:
    - yoke
created: 2026-11-17T18:49:46.30056Z
---

Problem: maturity (hidden/experimental verbs) is a hand-kept list, not a measured fact (pillar recipe step 5).
Behavior: yoke/docs/claims.md with per-command and per-family scores in the model of bashsharp/docs/claims.md; bashy commands derives each command's maturity from the scores instead of the hand-kept hidden list. Maturity uses the existing atlas stability vocabulary (experimental -> preview -> supported, yoke pkg/atlas Stabilities()); no second vocabulary (operator decision 2026-11-18: stable/beta/experimental meant the same tiers).
Depends on: S1.
Verification: ledger numbers equal gate output for the same commit; bashy commands view matches; the atlas stability coverage test stays green.
