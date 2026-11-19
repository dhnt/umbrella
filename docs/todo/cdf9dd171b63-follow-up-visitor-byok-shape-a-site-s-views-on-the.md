---
id: cdf9dd171b63
kind: feature
title: 'Follow-up: visitor BYOK, shape a site''s views on the visitor''s own outpost'
seq: 475
status: wontfix
priority: p2
labels:
    - shaping
    - llm
    - superseded
created: 2026-11-18T20:47:25.51336Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:28.991165Z
---

Deferred from Sprint 615 (operator 2026-11-18: that sprint focuses on the site owner). A signed-in visitor with their own outpost renders views on their own capacity: a per-request route of their own (their bashy llm or a provider key, used for one call, never stored or logged, outside the owner's allowance), or on the CLI website.bsh view URL with their own bashy llm. Only data the visitor's tier may see is sent. Builds on 615 S9/S12.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. Visitor-supplied model keys and visitor-host rendering are outside MVP; owner-configured route remains supported.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
