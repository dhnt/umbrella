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
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

Implement the shipped D14 handles on Yoke message-board posts, bus events, Meet rooms and chat transcripts using their owning stores. MB already persists UUIDv7: expose and resolve it, including archive, without reminting. Keep reusable Meet room numbers as pointers, distinct from permanent room identity; preserve directed/private visibility and existing authorization. Bus and chat need persisted UUID, scoped slug and local seq with stable old handles. Own pkg/bus, pkg/meet room-ref and pkg/chat resolver/store files only; do not edit fleet Resource, pkg/ref vocabulary or work todo/sprint/run files. Test handle roundtrips, collisions, cross-scope/archived reads, private content refusal and legacy compatibility; focused Go tests/cross-OS vet. Isolated workspace, true Agent trailers, no push before manager review.
