---
id: d9d6786744e9
kind: feature
title: 'S9 Critical-operation guard: grant plus signed approval for deploy, release, secrets and share'
seq: 517
status: wontfix
priority: p1
labels:
    - coordination
    - security
    - authorization
created: 2026-11-19T06:31:38.836508Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
closed: 2026-11-24T18:21:44.007462Z
---

Principal-bound effect guard; a critical operation runs only with the grant and, where the owner's policy requires it, a fresh signed human approval for that exact operation; otherwise a loud refusal naming the fix; an explicit, logged owner override. Builds on docs/bashy-agent-permissions.md section 5 (principal-bound @guard cap). Spec: docs/sprint-667-master-execution-plan.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The group model gives every participant a cloudbox identity on the owner's host and membership is mutual, so provenance for shaping is carried by the relationship stamp and the revision author; a second signature chain adds nothing for shaping. Agent-governance pieces (grants with scope, critical-operation guard, audit) retire with the sprint; refile against umbrella docs/access-tiers.md if wanted. Retired, not delivered.
