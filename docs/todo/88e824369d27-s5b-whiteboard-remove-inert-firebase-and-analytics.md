---
id: 88e824369d27
kind: task
title: 'S5b whiteboard: remove inert Firebase and analytics code; refresh ui-cli-parity whiteboard rows'
seq: 232
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-13T14:52:38.388904Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md. From the S5 review (conductor 2026-11-13): the pinned excalidraw fork build is safe (backends point to the local /whiteboard service; no Firebase config, so FIREBASE_CONFIG falls back to {}; trackEvent needs VITE_APP_ENABLE_TRACKING=true and window.sa_event, neither present), but the rule is remove, not disable: strip excalidraw-app/data/firebase.ts usage and the trackEvent/analytics paths (and the Excalidraw+ export/links) in the fork patch. Also docs/ui-cli-parity.md lines ~138 and ~170 cite deleted files (examples/whiteboard/server/index.html, desk.go, cli.go); update them for the new wrapper and re-check UI->CLI parity (every web action needs a CLI path).
