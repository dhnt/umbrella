---
id: a0a72ad338de
kind: test
title: 'E1 End-to-end acceptance on the fleet-mirror venue: three chat UIs x four outpost workers, sync and pull routes'
seq: 363
status: todo
priority: p1
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:43.636756Z
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
---

Spec: docs/vendor-chat-gateway-mvp.md. Venue: the fleet-mirror e2e venue (bashy e2e-fleet), never the dev box. Live vendor sign-ins need operator authorization.

Scenarios:
- From claude.ai, ChatGPT Work and Gemini web: hosts -> run a read verb -> delegate to each of claude/codex/agy/muse.
- route=sync for a satellite-attached host the caller is authorized on; route=pull for an unattached host.
- Kill the satellite mid-call: the call falls back to pull and the work runs once.
- Approve a gated action.
- Shape a wish to activation, then undo.
- Resume the task from a different vendor's client with the originating workstation offline.
- Outpost offline, and an expired or missing credential, show honest states.

Record raw evidence per scenario.
