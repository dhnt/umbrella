---
id: 5d09e99b4545
kind: feature
title: Persist D14 identities for fleet agent/tool/model/host/skill families
seq: 529
status: todo
priority: p1
labels:
    - refs
    - fleet
created: 2026-11-19T11:42:28.668656Z
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

Implement the established D14 UUID, scoped slug and parent-local sequence contract for public fleet agent definitions, tools, models, hosts and skills. Resource is a separate #524 story; a conversation Instance is not the agent definition. Persist handles in each owning fleet record, preserve legacy names and aliases, scope seq to the correct parent, reject ambiguous cross-host slugs, and resolve all three through the existing shared pkg/ref/define seam without a parallel registry. Expose a stable authorized producer accessor so Outpost #527 transports the same identity rather than reminting a response-only UUID. Coordinate shared fleet files and ref vocabulary with #524; do not edit its Resource or claim files concurrently. Include legacy on-demand persistence, rename/alias and duplicate-host cases; focused tests, three shipping OS vet, scrub and independent review. No private inventory leak or production deployment. This is in Sprint 666 and must land before closure, not a deferred audit.
