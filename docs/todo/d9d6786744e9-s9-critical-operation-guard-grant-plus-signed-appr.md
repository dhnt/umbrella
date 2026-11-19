---
id: d9d6786744e9
kind: feature
title: 'S9 Critical-operation guard: grant plus signed approval for deploy, release, secrets and share'
seq: 517
status: todo
priority: p1
labels:
    - coordination
    - security
    - authorization
created: 2026-11-19T06:31:38.836508Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
---

Principal-bound effect guard; a critical operation runs only with the grant and, where the owner's policy requires it, a fresh signed human approval for that exact operation; otherwise a loud refusal naming the fix; an explicit, logged owner override. Builds on docs/bashy-agent-permissions.md section 5 (principal-bound @guard cap). Spec: docs/sprint-667-master-execution-plan.md
