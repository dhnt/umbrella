---
id: 360426ad0ec7
kind: bug
title: 'S2c files: bundle the editor''s Ace modules instead of loading them from a public CDN'
seq: 220
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-13T12:18:16.36813Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

Found by the S11 gate: filebrowser/frontend/src/views/files/Editor.vue:177 sets the Ace base path to https://cdn.jsdelivr.net/npm/ace-builds@<ver>/src-min-noconflict/, so opening the editor fetches modes and themes from a third-party CDN (phone-home, and it breaks offline). Serve the needed ace-builds modules from the embedded dist instead, regenerate fbembed/dist.zip, bump the pins. Keep the fork's OTel as is: it exports only when OTEL_EXPORTER_OTLP_ENDPOINT is set. READ docs/shapeable-apps-worker-brief.md FIRST.
