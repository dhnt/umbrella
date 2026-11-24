---
id: db381608aa6f
kind: feature
title: S3 Relay by reference on mb, inbox and sprint comments
seq: 511
status: wontfix
priority: p1
labels:
    - coordination
    - security
created: 2026-11-19T06:27:28.297632Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
closed: 2026-11-24T18:21:48.321987Z
---

A relay embeds the original record (id, hash, signature) and adds the relayer's signature over it plus any comment; paraphrase is only a comment. Spec: docs/sprint-667-master-execution-plan.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The group model gives every participant a cloudbox identity on the owner's host and membership is mutual, so provenance for shaping is carried by the relationship stamp and the revision author; a second signature chain adds nothing for shaping. Agent-governance pieces (grants with scope, critical-operation guard, audit) retire with the sprint; refile against umbrella docs/access-tiers.md if wanted. Retired, not delivered.
