---
id: a3aaab875f92
kind: feature
title: 'S7 Public personalization: prefs hooks in the website scaffold + schema-driven Personalize panel in badge tier 1'
seq: 287
status: todo
priority: p2
labels:
    - shaping
    - examples
created: 2026-11-14T22:42:22.902669Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: glm. Example. website scaffold adds prefs.js: per-visitor preferences object in the visitor's browser applied via data-* attributes and CSS variables (theme, density, text size, language, mobile/desktop text variants, favorites). badge.js tier 1 gains a schema-driven Personalize panel (no LLM, no engine call) shown only when the policy's public level is on; reset restores defaults. Accept: on the sample site a visitor changes theme/density/language; only that browser changes; reload keeps it; reset clears; public level off hides the panel. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
