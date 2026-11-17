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
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: maturity (hidden/experimental verbs) is a hand-kept list, not a measured fact (pillar recipe step 5).
Behavior: yoke/docs/claims.md with per-command and per-family scores in the model of bashsharp/docs/claims.md; bashy commands derives stable/beta/experimental from the scores instead of the hand-kept hidden list.
Depends on: S1.
Verification: ledger numbers equal gate output for the same commit; bashy commands view matches.
