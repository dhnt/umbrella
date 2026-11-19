---
id: 5d09e99b4545
kind: feature
title: Audit portable fleet family identities and references
seq: 529
status: wontfix
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
closed: 2026-11-19T13:04:31.031088Z
---

Audit public fleet agent definitions, tools, models, hosts and skills against their existing IDs, parent references and local sequences. Resource is a separate #524 story; a conversation Instance is not the agent definition. Preserve legacy names and aliases, scope sequence to the correct parent, reject ambiguous cross-host slugs, and use the existing shared pkg/ref/define seam without a parallel registry. Add persisted identity only where a documented independent portable identity need cannot be met by a parent-qualified sequence; do not assume every record needs a UUID or backfill. An authorized producer accessor for Outpost #527 must carry the same identity without reminting a response-only UUID. Coordinate shared fleet files and ref vocabulary with #524; do not edit its Resource or claim files concurrently. Preserve isolated source, reviews and no-release status. Future focused gates run only on claimed test hosts after separate authorization. This story is in planned inactive Sprint 668 and does not block Sprint 666 MVP closure.
