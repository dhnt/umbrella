---
id: 242bcab3fd5e
kind: enhancement
title: 'S4 shaped.json static.fallback: serve index.html for extensionless misses (SPA history routing)'
seq: 284
status: todo
priority: p2
labels:
    - shaping
    - core
created: 2026-11-14T22:42:22.464856Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: codex. Core, required only if the site uses history routing. yoke pkg/shape/appserver/manifest.go new key static.fallback; pkg/webconsole/shaped.go serveTree serves public/index.html for extensionless GET/HEAD misses, never under api/; same for preview/history/draft. Accept: /x/pricing and /shape/x/preview/<id>/pricing return index.html with Genie injected; /x/missing.png still 404. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
