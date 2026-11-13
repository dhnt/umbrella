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
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

Found by the S11 gate: filebrowser/frontend/src/views/files/Editor.vue:177 sets the Ace base path to https://cdn.jsdelivr.net/npm/ace-builds@<ver>/src-min-noconflict/, so opening the editor fetches modes and themes from a third-party CDN (phone-home, and it breaks offline). Serve the needed ace-builds modules from the embedded dist instead, regenerate fbembed/dist.zip, bump the pins. Keep the fork's OTel as is: it exports only when OTEL_EXPORTER_OTLP_ENDPOINT is set. READ docs/shapeable-apps-worker-brief.md FIRST.

CARRIED TO SPRINT 632: re-check first; the files app moved to the Quantum fork (S2b), which removed its Ace CDN origins, so this may only apply to the old filebrowser fork kept for recovery.
