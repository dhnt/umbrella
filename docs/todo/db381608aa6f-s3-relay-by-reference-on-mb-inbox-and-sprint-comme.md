---
id: db381608aa6f
kind: feature
title: S3 Relay by reference on mb, inbox and sprint comments
seq: 511
status: todo
priority: p1
labels:
    - coordination
    - security
created: 2026-11-19T06:27:28.297632Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
---

A relay embeds the original record (id, hash, signature) and adds the relayer's signature over it plus any comment; paraphrase is only a comment. Spec: docs/sprint-667-master-execution-plan.md
