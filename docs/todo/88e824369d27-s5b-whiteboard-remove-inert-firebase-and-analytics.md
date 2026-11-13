---
id: 88e824369d27
kind: task
title: 'S5b whiteboard: remove inert Firebase and analytics code; refresh ui-cli-parity whiteboard rows'
seq: 232
status: done
priority: p2
labels:
    - shaping
created: 2026-11-13T14:52:38.388904Z
weave: 68
assignee: claude-opus5
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:46:24.794315Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md. From the S5 review (conductor 2026-11-13): the pinned excalidraw fork build is safe (backends point to the local /whiteboard service; no Firebase config, so FIREBASE_CONFIG falls back to {}; trackEvent needs VITE_APP_ENABLE_TRACKING=true and window.sa_event, neither present), but the rule is remove, not disable: strip excalidraw-app/data/firebase.ts usage and the trackEvent/analytics paths (and the Excalidraw+ export/links) in the fork patch. Also docs/ui-cli-parity.md lines ~138 and ~170 cite deleted files (examples/whiteboard/server/index.html, desk.go, cli.go); update them for the new wrapper and re-check UI->CLI parity (every web action needs a CLI path).

ALSO (peer review): the fork pin a2ec2889 as committed still has a live Sentry init with a hard-coded DSN, @sentry/browser and the Google Fonts preconnect; only the install-time web-prefix.patch strips them. Commit the removals into qiangli/excalidraw-shape itself (as S2b did for the files fork) and repin, so the pin is clean on its own.
