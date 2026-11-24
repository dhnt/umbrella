---
id: 097a9f60a441
kind: feature
title: S5 Scope and expiry for signed authorizations
seq: 513
status: wontfix
priority: p1
labels:
    - coordination
    - security
created: 2026-11-19T06:27:28.619398Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
closed: 2026-11-24T18:21:27.507129Z
---

A statement names what it authorizes and until when; verifiers refuse replays outside scope or past expiry. Spec: docs/sprint-667-master-execution-plan.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The group model gives every participant a cloudbox identity on the owner's host and membership is mutual, so provenance for shaping is carried by the relationship stamp and the revision author; a second signature chain adds nothing for shaping. Agent-governance pieces (grants with scope, critical-operation guard, audit) retire with the sprint; refile against umbrella docs/access-tiers.md if wanted. Retired, not delivered.
