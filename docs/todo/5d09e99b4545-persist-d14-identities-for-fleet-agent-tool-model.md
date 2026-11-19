---
id: 5d09e99b4545
kind: feature
title: Persist D14 identities for fleet agent/tool/model/host/skill families
seq: 529
status: assigned
priority: p1
labels:
    - refs
    - fleet
created: 2026-11-19T11:42:28.668656Z
weave: 100
assignee: claude-sonnet5.5
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

Implement the established D14 UUID, scoped slug and parent-local sequence contract for public fleet agent definitions, tools, models, hosts and skills. Resource is a separate #524 story; a conversation Instance is not the agent definition. Persist handles in each owning fleet record, preserve legacy names and aliases, scope seq to the correct parent, reject ambiguous cross-host slugs, and resolve all three through the existing shared pkg/ref/define seam without a parallel registry. Expose a stable authorized producer accessor so Outpost #527 transports the same identity rather than reminting a response-only UUID. Coordinate shared fleet files and ref vocabulary with #524; do not edit its Resource or claim files concurrently. Include legacy on-demand persistence, rename/alias and duplicate-host cases; focused tests, three shipping OS vet, scrub and independent review. No private inventory leak or production deployment. This is in Sprint 666 and must land before closure, not a deferred audit.
