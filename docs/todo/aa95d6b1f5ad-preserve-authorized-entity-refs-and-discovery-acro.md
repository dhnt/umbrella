---
id: aa95d6b1f5ad
kind: feature
title: Preserve authorized entity refs and discovery across Cloudbox and Outpost
seq: 527
status: wontfix
priority: p1
labels:
    - refs
    - cloud
created: 2026-11-19T11:31:53.778828Z
weave: 97
assignee: codex-gpt6-astra
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
closed: 2026-11-19T13:04:28.649414Z
---

Audit the existing hierarchical reference contract across Cloudbox/Satellite projections and Outpost inventory transport before changing schema. Private Agent/Task/Sprint already have UUID primary keys; preserve them and existing parent/sequence semantics. A parent-qualified local sequence can identify a child without a new per-record UUID or backfill. Add fields or a migration only for a demonstrated gap that cannot be resolved with existing identities. Separate authorized discovery/search from resolving a known handle. Do not remint, expose private identifiers/content, add a global registry, or deploy. Preserve isolated private and Outpost worktrees and coordinate with the schema/export owner before future shared changes. Verify authenticated member/outsider behavior, transport roundtrips, legacy compatibility, scoped ambiguity and no visibility widening on claimed test hosts before any separately authorized integration.
