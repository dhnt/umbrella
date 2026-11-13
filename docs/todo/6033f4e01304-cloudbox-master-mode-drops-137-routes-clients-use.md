---
id: 6033f4e01304
kind: requirement
title: cloudbox master mode drops 137 routes clients use (vault, suites, host grants, sprints) - decide before the prod switch
seq: 205
status: todo
priority: p1
labels:
    - cloudbox
    - master-mode
created: 2026-11-13T09:39:48.15606Z
---

Found 2026-11-13 switching prod ai.dhnt.io to CLOUDBOX_MODE=master (after superadmin removed the last tunnel-paired host (another account's, offline) via cloudbox v0.18.68): master mode mounts 309 of 446 standalone routes. Missing and in use: /api/v1/secrets (the bashy vault: every agent's 'bashy secret' got 404 within minutes), /api/v1/suites + /api/v1/hosts/* shares/grants (S619 relationship data), /api/v1/sprints + /api/v1/tasks (board/weave reporting), fleet, peer, backup, chat, ca, /v1 model gateway, /matrix/h tunnels. Rolled back to standalone after ~5 min; prod = v0.18.68 standalone, healthy. Cause: routes_catalog.go and other registrations are standalone-only by design ('master = coordination only'), but S619 assumed the master holds relationships and the vault. Needs a decision: which surfaces master mode serves (or where they move) before the switch. Rollback spec is the live standalone spec; the master-mode spec = CLOUDBOX_MODE=master, CLUSTER_ENABLED=false, no CLUSTER_UPSTREAM.
