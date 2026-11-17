---
id: fc4eabfabcdd
kind: refactor
title: S7 Consolidate the three claim implementations onto the contract
seq: 420
status: todo
priority: p2
labels:
    - yoke
created: 2026-11-17T18:49:47.042712Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: claim exists three times with different behavior: yoke pkg/ask/claim.go, pkg/steward/cli.go, pkg/policy/coord/cli.go.
Behavior: one claim implementation conforming to the contract; the others delegate or are retired under the capability change policy (replace before remove, proven per OS, compat reader).
Depends on: S0.
Verification: existing claim tests green; gate scores claim conforming; no regression in formerly green coverage.
