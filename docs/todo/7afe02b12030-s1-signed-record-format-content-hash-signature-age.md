---
id: 7afe02b12030
kind: feature
title: 'S1 Signed record format: content hash, signature, agent seat keys, public-key registry on the master'
seq: 509
status: todo
priority: p1
labels:
    - coordination
    - security
created: 2026-11-19T06:27:27.975572Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
---

Every mb/inbox/comment record carries id, author principal, time, content hash and signature; agents sign with their seat key; the master serves public keys by principal. Spec: docs/sprint-667-master-execution-plan.md
