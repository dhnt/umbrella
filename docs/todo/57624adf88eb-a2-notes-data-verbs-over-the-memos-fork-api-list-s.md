---
id: 57624adf88eb
kind: feature
title: 'A2 notes: data verbs over the memos fork API (list, show, add, set, archive, search, export)'
seq: 237
status: assigned
priority: p1
labels:
    - parity
    - app
created: 2026-11-13T17:39:23.094789Z
weave: 64
assignee: codex-gpt6-astra
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

READ docs/shapeable-apps-worker-brief.md. Custom command only: extend bashy/examples/notes/notes.bsh (currently install/start/stop/status/source), never the bashy core. Add the data verbs a notes user has on the page: list, show, add, set (edit content/tags/visibility), archive/unarchive, rm, search, export (markdown/json). Each verb calls the pinned fork's own API on the running local instance with the principal's local token (no new storage, no new identity), returns the app's JSON envelope with --json, supports --dry-run on writes, and reproduces the page's denied result for a non-owner.

This story is the model for A3-A5: keep the verb grammar and the error envelope consistent (see examples/desk/kit/README.md common verbs). Record the verbs as rows in bashy/docs/ui-cli-parity.md (A1 owns the section; add your rows there).

Tests: targeted unit tests for the command (argument parsing, dry-run manifest, envelope shape) runnable without the fork. Runtime proof against the running fork only on the claimed gate-linux, never the dev box; if no gate host, say the runtime proof is open.

Done when: every notes page action listed by A1 has a verb or a recorded reason; tests pass; no-phone-home gate (script/no-phone-home.sh) unchanged/green for the fork; commits carry Sprint/Story/Story-ID/Agent trailers.
