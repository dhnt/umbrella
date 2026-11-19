---
id: a3d0bf57d3ea
kind: feature
title: Give communications durable portable refs
seq: 526
status: assigned
priority: p1
labels:
    - refs
    - comms
created: 2026-11-19T11:31:53.527602Z
weave: 98
assignee: claude-opus5.5
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

Implement the shipped D14 handles on Yoke message-board posts, bus events, Meet rooms and chat transcripts using their owning stores. MB already persists UUIDv7: expose and resolve it, including archive, without reminting. Keep reusable Meet room numbers as pointers, distinct from permanent room identity; preserve directed/private visibility and existing authorization. Bus and chat need persisted UUID, scoped slug and local seq with stable old handles. Own pkg/bus, pkg/meet room-ref and pkg/chat resolver/store files only; do not edit fleet Resource, pkg/ref vocabulary or work todo/sprint/run files. Test handle roundtrips, collisions, cross-scope/archived reads, private content refusal and legacy compatibility; focused Go tests/cross-OS vet. Isolated workspace, true Agent trailers, no push before manager review.
