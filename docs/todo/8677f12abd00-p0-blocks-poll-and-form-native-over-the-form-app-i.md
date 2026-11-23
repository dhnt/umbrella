---
id: 8677f12abd00
kind: feature
title: 'P0 blocks: poll and form (native over the form app), identity is the respondent key'
seq: 654
status: todo
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.805583Z
sprint: 696
---

Adapter over form's /api/action and /api/state; page block add poll --options ... (calls form add --poll) and page block add form --def ...; the page participant identity (handle@address or the principal) is the respondent, carried to form through a per-participant cookie jar held by the page server; one answer and one vote budget per identity, resubmit replaces; facilitator open, close, results visibility from the page; results view handle -> answer and option -> votes (handles); --anonymous hides handles everywhere including export; tallies pushed over the kit SSE stream. Proof: a three-votes-per-participant ballot with distinct fake identities on both doors, one refreshing and re-voting, counted once. Spec: docs/page-live-group-page.md.
