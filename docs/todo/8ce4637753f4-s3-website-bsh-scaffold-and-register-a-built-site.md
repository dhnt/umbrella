---
id: 8ce4637753f4
kind: feature
title: 'S3 website.bsh: scaffold and register a built site (Vite/React) as a shaped app'
seq: 283
status: todo
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-14T22:42:22.319631Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: codex. Example bashy/examples/shaping/website/website.bsh. scaffold DIR adds checks/build.bsh (bashy npm ci && bashy npx vite build, fail on diff vs committed public/), contract.bsh @effects(read,write,exec,net) like examples/clip, shaped.json genie examples, site.json, relative vite base guard, routing-mode detection (flags S4 need). register NAME --git URL = app add --type shaped --source URL (GITHUB_TOKEN) then shape remote set upstream URL. status NAME. Accept: scaffold on a sample Vite app registers; bashy shape verify passes in the verifier's scrubbed env on the dev box and on gate-linux. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
