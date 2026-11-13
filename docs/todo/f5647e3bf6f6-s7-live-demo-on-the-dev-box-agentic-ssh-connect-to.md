---
id: f5647e3bf6f6
kind: test
title: 'S7 live demo on the dev box: agentic ssh "connect to host gatehost" cold (forge) then warm (no model), scrubbed envelopes in the README'
seq: 251
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:17:59.714191Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Conductor-run on the dev box with the vendor tier (--train claude) or a door model once BASHY_LLM_API_KEY is bound. bashy claim host:gatehost --intent 'S7 demo' first, release after. Record: cold envelope (source forged, version 1, model, duration_ms), warm envelope (source script, model none, lower duration_ms), the saved ssh.bsh (scrubbed) and the graph ledger lines. Then force a refine: expire the elevation cookie or change the route and show the corrected version 2 and undo. Evidence into the README and the story; role names only (script/scrub-gate.sh). Depends on S6. Not a full gate run; coding sessions are not QA.
