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
---

Deferred from Sprint 615 (operator 2026-11-18: that sprint focuses on the site owner). A signed-in visitor with their own outpost renders views on their own capacity: a per-request route of their own (their bashy llm or a provider key, used for one call, never stored or logged, outside the owner's allowance), or on the CLI website.bsh view URL with their own bashy llm. Only data the visitor's tier may see is sent. Builds on 615 S9/S12.
