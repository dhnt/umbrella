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

Implement D14 persisted UUID, scoped slug and parent-local sequence for remaining public entity kinds not owned by resource/fleet, work or communications lanes: person, role, episode, out and app. Preserve content digests as content identity and existing role/person authority; do not treat a conversation instance as an agent definition or a reusable pointer as an entity. Own pkg/principal, pkg/execlog, pkg/reduce and pkg/ref/app integration, plus Bashy internal/agentos/refs.go and the existing CLI discovery front door. Provide authorized discovery/search separately from known-handle Resolve; search returns a portable UUID or scoped handle that resolves to the SAME entity. Test duplicate slug and local seq on different hosts, outsider non-disclosure, archive/offline and ambiguous outcomes explicitly. Add comprehensive all-kind conformance after vocabulary owner #524 lands. No new registry, no coreutils or shell production changes. Isolated Yoke and Bashy worktrees, focused Go tests and three-OS vet; manager merges after upstream interface is stable.
