---
id: c24d882a44c9
kind: bug
title: Resolve registered resource refs through the existing uniform ref contract
seq: 524
status: assigned
priority: p1
labels:
    - refs
    - resource
created: 2026-11-19T11:20:06.798836Z
weave: 95
assignee: codex-gpt6-sol
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

The shipped uniform ref design (dhnt-docs/docs/uniform-ref-addressing.md D10-D14, commit 145e0fab) requires UUID, scoped slug and local seq handles for every addressable entity. Registered resources currently lack those persisted handles and a shared ref resolver; the effective kind/name is only an implementation lookup. Add resource handle persistence and resolve all three through the existing pkg/ref and bashy define/scopeLookup seams. Reuse the shipped resolver, without a parallel identity catalog. Cover cross-stack lookup from UUID and scoped slug, local seq confinement, aliases, and stable identity across rename/host transport. Prior audit/fix examples are closed umbrella stories 53b78fabbe9f and f5bf8d3422e7. Sprint 666 #523 is a separate physical claim-address collision fix and does not close this contract gap.

Public implementation lane: own Yoke fleet Resource plus agent definition, tool, model, host and skill family persistence and the existing shared ref/define seams. Add stable UUID, scoped slug and local sequence handles without replacing registered names or claim semantics. Conversation agent Instance is a different entity and must retain its identity. Resource and fleet known-handle lookup must resolve the same persisted record by all three handles, reject ambiguous scope/name input, and keep private inventory details behind existing authorization. Name and alias inputs to claim acquisition must converge on that persisted Resource identity before the physical claim key is selected. Cover legacy records with on-demand persisted handle minting, duplicate/rename behavior, and focused CLI/JSON round trips. Bashy internal/agentos/refs.go and the authorized discovery front door belong to #528, not this worker. Use isolated Yoke worktrees, accurate Agent trailers, focused tests and cross-platform vet; no coreutils or shell source changes. The manager will merge this lane with unpublished Sprint 666 claim fix before final pins.

The sprint also includes an all-kind D14 audit, including agents, todos and sprints, without assuming the resource gap is exhaustive. For each kind, distinguish authorized discovery/search across Cloudbox, Satellite and Outpost from resolution of an already known handle. Implement confirmed gaps as bounded Sprint 666 stories, and verify that UUID, scoped slug and local sequence resolve through the established shared seam with the intended authorization and scope rules.
