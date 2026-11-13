---
id: c49679cb7173
kind: feature
title: 'A4 table: verbs over the grist fork API (documents, tables, records list, show, add, set, rm, export csv)'
seq: 239
status: todo
priority: p1
labels:
    - parity
    - app
created: 2026-11-13T17:39:23.381062Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

READ docs/shapeable-apps-worker-brief.md. Custom command only: extend bashy/examples/table/table.bsh (currently install/start/stop/status/source), never the bashy core. Add the verbs a table user has on the page: docs list/add/show; tables list/add; columns list/add; records list/add/set/rm (with --where filters); views list; export (csv/json); import csv. Same rules as A2: call the pinned fork's own REST API on the running local instance with the principal's local API key, --json envelope, --dry-run on writes, page-equivalent denied result. Follow A2's verb grammar.

This is the data-bearing app, so the write verbs must respect the shaping data rules already in the engine (never bypass the app API; no direct database edits). Record the rows in bashy/docs/ui-cli-parity.md (A1 section). Tests: targeted unit tests runnable without the fork; runtime proof only on the claimed gate-linux. Done when every table page action listed by A1 has a verb or a recorded reason, tests pass, the no-phone-home gate stays green on the fork, commits carry the provenance trailers.
