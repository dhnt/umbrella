---
id: 3aa3e25a8c8f
kind: bug
title: Permit same-origin framing of whiteboard, table and klatch faces
seq: 670
status: todo
labels:
    - page
    - cross-app
created: 2026-11-23T13:39:53.067727Z
---

Sprint 696 story 655 (01efa4b05a24) made desk page embed blocks link out, never frame, when the ref targets a non-kit engine: /whiteboard, /table, /klatch (also under /apps/), and /demo-queue (tracked in 3b16b02e6b1a). These engines are not built on desk-kit, so they lack the SecurityOptions{Embeddable: true} opt-in that viewer, notepad, chart, calendar, form and brainstorm use. Each would need a narrow same-origin opt-in (frame-ancestors 'self' only, on its main handler, keeping any sandboxed raw-asset CSP) with a test proving framing stays same-origin, after which examples/desk/page can drop it from linkOnlyEngines (block_content.go) and frame it inline.
