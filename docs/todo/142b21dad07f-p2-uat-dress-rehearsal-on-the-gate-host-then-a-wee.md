---
id: 142b21dad07f
kind: test
title: 'P2 UAT: dress rehearsal on the gate host, then a weekly class on one page'
seq: 660
status: todo
priority: p2
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.687086Z
sprint: 696
---

Dress rehearsal on the claimed gate host with fake identities on both doors (satellite member, LAN anonymous), a ballot, a form collection, a timer and an export; then the live class on Sunday 2026-11-29 through the satellite door with the LAN door as fallback. Outcome and any defects recorded in the class repository and as todos here; bashy docs stay general (the class is a test case, not the product). If the rehearsal fails, the class runs on today's tools. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).
