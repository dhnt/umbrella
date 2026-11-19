---
id: 8cd6d833c61e
kind: feature
title: S1 Shape page prefill from ?page= and ?element= (shape.js/shape.html)
seq: 281
status: wontfix
priority: p1
labels:
    - shaping
    - core
    - superseded
created: 2026-11-14T22:42:22.020728Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
closed: 2026-11-19T14:02:18.011599Z
---

Planned vendor: codex. Core, small. yoke pkg/webconsole/artifact/shape.js + shape.html read URLSearchParams page/element, show chip 'from page … · pointing at …', include both in the POST, history.replaceState to clean the URL; verifydom test. Server already accepts page/element (handleShapeCreate); CLI --page/--element unchanged. Accept: GET /shape/x/?page=/pricing&element=… shows chip, textarea focused; created candidate shows 'from page /pricing'. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`), M5 (`1948f3a043de`). Preserve page/element context through sign-in and candidate creation.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
