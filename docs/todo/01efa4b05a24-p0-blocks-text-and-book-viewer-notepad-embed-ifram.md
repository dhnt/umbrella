---
id: 01efa4b05a24
kind: feature
title: 'P0 blocks: text and book (viewer, notepad), embed (iframe), timer'
seq: 655
status: todo
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.951769Z
sprint: 696
---

Native blocks book:<id>/pN (viewer page rendered inline) and note:<id> (notepad note); embed:<same-origin path or URL> as an iframe for whiteboard, table, Klatch and the demo-queue projector (needs the kit CSP option); timer:<name> with facilitator start/stop/reset and ticks over SSE, visible to all. Each block kind is one small renderer under blocks/ plus a template so a shaping wish can add a kind. Spec: docs/page-live-group-page.md.
