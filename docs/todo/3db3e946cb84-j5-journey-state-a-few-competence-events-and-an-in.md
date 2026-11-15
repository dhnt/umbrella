---
id: 3db3e946cb84
kind: feature
title: 'J5 Journey state: a few competence events and an invitation table, as data'
seq: 316
status: todo
priority: p2
labels:
    - software-shaping
created: 2026-11-15T02:58:08.980397Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the try-now showcase — a visitor shapes ai.dhnt.io inside the owner''s declared boundary, proven Red-Green-Refactor'
---

Law 2 of docs/dhnt-journey-design.md: the next rung is offered only after the current one has been USED. That needs state, and KISS says it is a handful of events, not a subsystem.

Scope: named events in the same document J2 already stores (shaped, undone, invitation shown, taken, dismissed); the invitation rules as a SMALL DATA TABLE (condition -> invitation id -> the one action it offers), itself shapeable so a person can silence or reorder their own invitations; bashy journey status|next --json so an agent reads the same state; one invitation implemented end to end — rung 2, attach your machine — shown only after a first shape and a first undo.

Acceptance: a fresh account sees no invitation; after one shape and one undo the rung-2 invitation appears exactly once; dismissal sticks; the table is a file an edit can extend; --json parity.
