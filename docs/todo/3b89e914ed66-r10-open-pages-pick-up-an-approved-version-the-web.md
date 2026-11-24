---
id: 3b89e914ed66
kind: feature
title: 'R10 Open pages pick up an approved version: the website template polls the active version id'
seq: 724
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T20:46:03.432041Z
due: 2026-12-04T00:00:00Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Part of the A/O/C case on R5 (5c1b07e994f1): everyone sees an approved change as fast as shaping allows. Today the website template's shaping.js reloads only after the viewer's own action. KISS: the template serves the active version id, and an open page polls it (a few seconds) and reloads, or shows a one-line notice while the viewer is editing, when it changes. No SSE and no new server. Acceptance: Go/DOM unit test that an approve on the host changes the served id and a page holding the old id reloads; no reload loop when the id is unchanged.
