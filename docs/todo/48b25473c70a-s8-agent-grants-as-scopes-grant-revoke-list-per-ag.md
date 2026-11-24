---
id: 48b25473c70a
kind: feature
title: 'S8 Agent grants as scopes: grant, revoke, list per agent principal with scope and expiry'
seq: 516
status: wontfix
priority: p1
labels:
    - coordination
    - security
    - authorization
created: 2026-11-19T06:31:38.685166Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
closed: 2026-11-24T18:21:31.974133Z
---

Owner grants named permissions (deploy, release, secrets:read, share:write) bound to the agent principal and seat key, scoped (host, app, sprint, vault path), expiring, revocable; same vocabulary and attenuation as cloudbox token scopes. Builds on docs/bashy-agent-permissions.md section 5 (principal-bound @guard cap). Spec: docs/sprint-667-master-execution-plan.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The group model gives every participant a cloudbox identity on the owner's host and membership is mutual, so provenance for shaping is carried by the relationship stamp and the revision author; a second signature chain adds nothing for shaping. Agent-governance pieces (grants with scope, critical-operation guard, audit) retire with the sprint; refile against umbrella docs/access-tiers.md if wanted. Retired, not delivered.
