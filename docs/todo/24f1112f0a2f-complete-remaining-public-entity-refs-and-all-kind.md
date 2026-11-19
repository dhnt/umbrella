---
id: 24f1112f0a2f
kind: feature
title: Complete remaining public entity refs and all-kind conformance gate
seq: 528
status: assigned
priority: p1
labels:
    - refs
    - conformance
created: 2026-11-19T11:32:01.779468Z
weave: 99
assignee: claude-sonnet5
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

Audit remaining public entity kinds not owned by resource/fleet, work or communications lanes: person, role, episode, out and app. Reuse existing IDs, parent-qualified local sequences and content digests where they already distinguish the intended entity; a UUID is required only when independent portable identity is demonstrated. Preserve role/person authority, conversation Instance distinct from agent definition, and reusable pointers distinct from entities. Own pkg/principal, pkg/execlog, pkg/reduce and pkg/ref/app integration, plus Bashy internal/agentos/refs.go and the existing CLI discovery front door. Authorized discovery/search remains separate from known-handle Resolve and must return a handle resolving to the same entity. Test duplicate local sequences under different parents, outsider non-disclosure, archive/offline and ambiguity on a claimed test host. No new registry or shell/coreutils production change. Preserve isolated source and review evidence pending separate authorization.
