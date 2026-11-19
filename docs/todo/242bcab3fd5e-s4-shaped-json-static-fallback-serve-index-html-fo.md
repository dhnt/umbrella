---
id: 242bcab3fd5e
kind: enhancement
title: 'S4 shaped.json static.fallback: serve index.html for extensionless misses (SPA history routing)'
seq: 284
status: wontfix
priority: p2
labels:
    - shaping
    - core
    - superseded
created: 2026-11-14T22:42:22.464856Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
closed: 2026-11-19T14:02:18.305504Z
---

Planned vendor: codex. Core, required only if the site uses history routing. yoke pkg/shape/appserver/manifest.go new key static.fallback; pkg/webconsole/shaped.go serveTree serves public/index.html for extensionless GET/HEAD misses, never under api/; same for preview/history/draft. Accept: /x/pricing and /shape/x/preview/<id>/pricing return index.html with Genie injected; /x/missing.png still 404. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. SPA fallback is not required by the initial server-rendered app and existing-site companion fixtures; add only if a supported journey proves a blocker.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
