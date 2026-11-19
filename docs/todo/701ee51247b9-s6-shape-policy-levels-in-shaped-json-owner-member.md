---
id: 701ee51247b9
kind: feature
title: 'S6 Shape policy levels in shaped.json: owner/member/public, allow-lists, request mode, invariants'
seq: 286
status: wontfix
priority: p1
labels:
    - shaping
    - core
    - superseded
created: 2026-11-14T22:42:22.756833Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
closed: 2026-11-19T14:02:18.748524Z
---

Planned vendor: codex/claude. Core, medium. shaped.json levels: name, who (principals|circle|authenticated|anonymous), mode shape|request|personalize|off, allow/deny globs, effects subset, properties (typed schema extending today's name list), examples. appserver/manifest.go parse+validate; wish intake resolves principal→level→mode (request reuses fileRequest); the level's deny list joins the app protected list passed to candidateTouchesProtected; verifier caps effects to the subset; shaped.json protected for non-owners; Shape page shows level + allow-list; bashy shape status --json reports level. Invariants at every level: engine/core, protected rows, effect cap, declared properties, per-principal activation. Accept: member wish touching a denied path refused naming the path; request mode records and builds nothing; non-owner candidate editing shaped.json refused; owner path unchanged; --json parity. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md

COMPOSITION WITH M4 (Sprint 641, 2026-11-14) — build these as two halves of ONE boundary, not two policies. A level says WHO and in which mode; the feature list (M4, 928fb2c3584e) says WHAT, in the app's own words, with flags and invariants. Contract between them: the feature's shapeable ceiling wins, a level can only narrow it and never widen it; a refusal prefers the feature's name over the glob that implemented it; shaped.json carries both keys and refuses unknown ones. Whoever lands first defines the shared parse/validate and the refusal wording for the other.

ROLE NAMES ARE THE CMS ONES (operator 2026-11-14, docs/sprint-641-feature-matrix.md): do not invent a role model. Default levels take the familiar names — visitor (anonymous, read), signed-in user (subscriber: personalize own view), member-contributor (propose content, cannot publish), member-author (publish own content), maintainer (editor: everyone's content), owner (administrator: configuration + content), staff (super admin: code and releases) — and each is a BUNDLE OF CAPABILITIES an owner may redefine, the way circles are owner-defined, not a fixed ladder. Inherited by name: content/configuration/code separation, separation of duties (a candidate is an unpublished revision, approve is publish), no editing core in production (protected rows + the release path, binding staff too), revisions with rollback and an audit trail, and appearance permissions as their own right — which is why personalize is a mode, not weaker shaping.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M3 (`f876f5deafea`). One authorization vocabulary and typed declared surface retained; public visitors do not code-shape.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
