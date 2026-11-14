---
id: 701ee51247b9
kind: feature
title: 'S6 Shape policy levels in shaped.json: owner/member/public, allow-lists, request mode, invariants'
seq: 286
status: todo
priority: p1
labels:
    - shaping
    - core
created: 2026-11-14T22:42:22.756833Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: codex/claude. Core, medium. shaped.json levels: name, who (principals|circle|authenticated|anonymous), mode shape|request|personalize|off, allow/deny globs, effects subset, properties (typed schema extending today's name list), examples. appserver/manifest.go parse+validate; wish intake resolves principal→level→mode (request reuses fileRequest); the level's deny list joins the app protected list passed to candidateTouchesProtected; verifier caps effects to the subset; shaped.json protected for non-owners; Shape page shows level + allow-list; bashy shape status --json reports level. Invariants at every level: engine/core, protected rows, effect cap, declared properties, per-principal activation. Accept: member wish touching a denied path refused naming the path; request mode records and builds nothing; non-owner candidate editing shaped.json refused; owner path unchanged; --json parity. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
