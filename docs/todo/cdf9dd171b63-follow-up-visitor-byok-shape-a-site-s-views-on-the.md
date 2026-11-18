---
id: cdf9dd171b63
kind: feature
title: 'Follow-up: visitor BYOK, shape a site''s views on the visitor''s own outpost'
seq: 475
status: todo
priority: p2
labels:
    - shaping
    - llm
created: 2026-11-18T20:47:25.51336Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Deferred from Sprint 615 (operator 2026-11-18: that sprint focuses on the site owner). A signed-in visitor with their own outpost renders views on their own capacity: a per-request route of their own (their bashy llm or a provider key, used for one call, never stored or logged, outside the owner's allowance), or on the CLI website.bsh view URL with their own bashy llm. Only data the visitor's tier may see is sent. Builds on 615 S9/S12.
