---
id: fcaa3d3e6109
kind: feature
title: 'S6 table: records grid with personal views as a shapeable custom command'
seq: 212
status: assigned
priority: p2
labels:
    - shaping
created: 2026-11-13T11:33:42.183391Z
weave: 49
assignee: codex-gpt6-sol
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified. Base: gristlabs/grist-core (Apache-2.0); fallback Baserow MIT core only. Uses the S3 template.

TEMPLATE (S3, accepted 2026-11-13): copy bashy/examples/notes (notes.bsh install/start/stop/status/source, pinned fork under qiangli/<name>-shape, install-time pin + LICENSE + no ee/ checks, web-prefix.patch, shaped.json, contract.bsh, checks/, register.sh, notes_test.sh). Also run script/no-phone-home.sh on the pinned source and explain every hit; remove third-party telemetry and use bashy OTel (owner-only, env-gated).

VENUE (conductor 2026-11-13): a demo container ran on the dev box during run #49; the conductor stopped and removed it. Runtime/container proof only on the claimed gate host; dev-box container evidence does not count. If no gate host is available, finish code + unit tests and mark the runtime proof open.
