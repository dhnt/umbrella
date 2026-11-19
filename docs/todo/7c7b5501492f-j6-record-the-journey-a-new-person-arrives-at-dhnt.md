---
id: 7c7b5501492f
kind: test
title: 'J6 Record the journey: a new person arrives at dhnt.io, shapes their desktop, is invited onward'
seq: 317
status: todo
priority: p1
labels:
    - software-shaping
created: 2026-11-15T02:58:09.1208Z
---

The MVP's acceptance, recorded once with ids and screenshots where they help.

The walk: arrive at dhnt.io not signed in and see the Shape badge and the taste; sign in with OAuth2 (email identity is required before any real shape); land on the desktop; change the look and the tile order by hand; ask for a change in words and get it; ask for something outside the schema and be refused in the schema's terms; undo; see the allowance decrement; reload and find the change still there; check that a second account's desktop is untouched; then see the rung-2 invitation appear — and only then.

Acceptance: every step recorded with the revision numbers and the refusal texts; a second account proves per-person isolation; the pool-down path exercised once by disabling the route, showing settings still work; no step needed a machine, an install or a repository from the person.

## Carry-over (2026-11-19)

Sprint 641 was ended by the operator. This story is unlinked from it and stays open as a follow-up. State at carry-over:
- Evidence so far: the operator walked the journey live on dhnt.io (v0.18.77) on 2026-11-19 — sign-in, hand changes, wishes applied, a refused wish in the red alert, undo, suggest-to-owner, and the rung-2 invitation shown and answered. Journey events confirmed via `GET /api/v1/desktop/journey`.
- Remaining for acceptance: one written record with revision numbers and refusal texts, the second-account isolation check, and the pool-down path (route disabled, settings still work), preferably on a satellite rather than the master.
