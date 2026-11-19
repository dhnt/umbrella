---
id: aa95d6b1f5ad
kind: feature
title: Preserve authorized entity refs and discovery across Cloudbox and Outpost
seq: 527
status: assigned
priority: p1
labels:
    - refs
    - cloud
created: 2026-11-19T11:31:53.778828Z
weave: 97
assignee: codex-gpt6-astra
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

Integrate the existing D14 UUID/scoped-slug/local-seq and shared resolver contract across Cloudbox/Satellite entity persistence, API projections and Outpost inventory transport. Private Agent/Task/Sprint already have UUID primary keys but need scoped slug and local seq persistence; add compatible fields/migration in their owning schema and entity paths after coordinating schema/export ownership. Separate authorized discovery/search from resolving a known handle. Preserve entity UUIDs already primary in private storage; do not remint, expose private identifiers/content, add a global registry, or deploy. Use isolated private and Outpost worktrees; coordinate with active Cloudbox owner before shared route/schema/export changes. Own private entity schema/migration and API projection/discovery plus Outpost transport files only, no public Yoke identity-store edits. Verify agent/todo/sprint and fleet asset persistence/projection/roundtrip across transport with authenticated member/outsider tests, legacy name compatibility, scoped ambiguity and no visibility widening. Exact source, standalone build/test and no-release evidence before manager integration.
