---
id: 876cd327a5e6
kind: feature
title: 'A5 whiteboard: verbs for what the local whiteboard service exposes (boards list, new, export, share link)'
seq: 240
status: todo
priority: p1
labels:
    - parity
    - app
created: 2026-11-13T17:39:23.524452Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

READ docs/shapeable-apps-worker-brief.md. Custom command only: extend bashy/examples/whiteboard/whiteboard.bsh (currently install/start/stop/status/source), never the bashy core. The excalidraw fork is a browser app over the local /whiteboard collab service, so first establish with A1 which page actions are server-backed (board create/open, scene save/load, share/collab link, export png/svg/json) and which are page-only drawing with no server API. Add verbs for the server-backed ones (boards list/new/show/rm, export, share), same rules as A2 (--json, --dry-run on writes, page-equivalent denied result, A2's verb grammar). For page-only actions record the reason in the parity row instead of filing a gap.

Coordinate with S5b, which strips Firebase/analytics from the same fork pin. Tests: targeted unit tests runnable without the fork; runtime proof only on the claimed gate-linux. Done when every whiteboard page action listed by A1 has a verb or a recorded reason, the stale whiteboard rows are replaced, tests pass, no-phone-home gate green, commits carry the provenance trailers.
