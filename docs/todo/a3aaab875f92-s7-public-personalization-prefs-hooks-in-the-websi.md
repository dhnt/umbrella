---
id: a3aaab875f92
kind: feature
title: 'S7 Public personalization: prefs hooks in the website scaffold + schema-driven Personalize panel in badge tier 1'
seq: 287
status: wontfix
priority: p2
labels:
    - shaping
    - examples
    - superseded
created: 2026-11-14T22:42:22.902669Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
closed: 2026-11-19T14:02:17.858961Z
---

Planned vendor: glm. Example. website scaffold adds prefs.js: per-visitor preferences object in the visitor's browser applied via data-* attributes and CSS variables (theme, density, text size, language, mobile/desktop text variants, favorites). badge.js tier 1 gains a schema-driven Personalize panel (no LLM, no engine call) shown only when the policy's public level is on; reset restores defaults. Accept: on the sample site a visitor changes theme/density/language; only that browser changes; reload keeps it; reset clears; public level off hides the panel. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M6 (`5d23ad18f7a1`). Declared-property personalization retained; a separate badge toolchain is deferred.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
