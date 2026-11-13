---
id: c2f2f915c54d
kind: feature
title: 'A3 board: verbs over the kaneo fork API (projects and tasks list, show, add, move, set, export)'
seq: 238
status: done
priority: p1
labels:
    - parity
    - app
created: 2026-11-13T17:39:23.238607Z
weave: 69
assignee: codex-gpt6-astra
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:28:30.504581Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md. Custom command only: extend bashy/examples/board/board.bsh (currently install/start/stop/status/source), never the bashy core. Add the verbs a board user has on the page: projects list/add/show/set/rm; tasks list/add/show/set/move (column/status)/rm; comments add; export (json/csv). Same rules as A2: call the pinned fork's own API on the running local instance with the principal's local token, --json envelope, --dry-run on writes, page-equivalent denied result. Follow A2's verb grammar.

Record the rows in bashy/docs/ui-cli-parity.md (A1 section). Tests: targeted unit tests runnable without the fork; runtime proof only on the claimed gate-linux. Done when every board page action listed by A1 has a verb or a recorded reason, tests pass, the no-phone-home gate stays green on the fork (coordinate with S4b, which touches the same fork), commits carry the provenance trailers.
