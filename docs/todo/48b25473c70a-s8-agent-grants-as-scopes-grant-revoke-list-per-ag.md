---
id: 48b25473c70a
kind: feature
title: 'S8 Agent grants as scopes: grant, revoke, list per agent principal with scope and expiry'
seq: 516
status: todo
priority: p1
labels:
    - coordination
    - security
    - authorization
created: 2026-11-19T06:31:38.685166Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
---

Owner grants named permissions (deploy, release, secrets:read, share:write) bound to the agent principal and seat key, scoped (host, app, sprint, vault path), expiring, revocable; same vocabulary and attenuation as cloudbox token scopes. Builds on docs/bashy-agent-permissions.md section 5 (principal-bound @guard cap). Spec: docs/sprint-667-master-execution-plan.md
