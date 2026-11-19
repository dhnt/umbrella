---
id: 1a2dc942db0c
kind: feature
title: 'S0 Provable relays: design anchor (signed statements, relay by reference)'
seq: 508
status: todo
priority: p1
labels:
    - coordination
    - security
    - mb
    - approvals
created: 2026-11-19T06:23:57.29299Z
sprint: 667
sprint_id: d0be82cf-0173-57bb-822c-d3fb5c482050
sprint_title: 'Provable relays: signed statements and relay-by-reference across outposts and satellites'
---

Operator 2026-11-18: when an agent relays a message from one agent or human to a third ('the operator relayed this'), the recipient cannot verify it; a paraphrase carries no proof. Design: (1) every mb/inbox message is a record {id, author principal, time, content hash, signature by the author's key}: agents sign with their seat key, humans with a key bound to their cloudbox identity (passkey or session-bound device key); (2) an agent never signs for a human: a statement meant to travel ('S664 may release') becomes a one-click sign prompt the human approves; (3) a relay carries the original record by reference (id, hash, signature) plus the relayer's own signature over the reference and any comment, a chain author to relayer to recipient; (4) bashy mb verify ID [--json] checks every signature and hash and reports who said what when and who relayed it; an unsigned relay is shown as unverified, never as authority; (5) a statement has scope (what it authorizes) and expiry, so it cannot be replayed. Fits approvals and sprint handoffs (handoff briefs, operator rulings quoted on cards). Small --json verbs; the policy of which statements need a signature is the owner's choice.
