---
id: 0f9898f928bb
kind: feature
title: 'S4 board: kanban fork as a shapeable custom command'
seq: 210
status: assigned
priority: p2
labels:
    - shaping
created: 2026-11-13T11:33:41.915952Z
weave: 56
assignee: muse-conductor
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified. Base: usekaneo/kaneo (MIT); alt kanboard (MIT). Uses the S3 template.

TEMPLATE (S3, accepted 2026-11-13): copy bashy/examples/notes (notes.bsh install/start/stop/status/source, pinned fork under qiangli/<name>-shape, install-time pin + LICENSE + no ee/ checks, web-prefix.patch, shaped.json, contract.bsh, checks/, register.sh, notes_test.sh). Also run script/no-phone-home.sh on the pinned source and explain every hit; remove third-party telemetry and use bashy OTel (owner-only, env-gated).

RESUME (conductor 2026-11-13): run #50 hit its 1h20m max-runtime with the work uncommitted. It is saved on bashy branch salvage/s4-board-run50 (examples/board, 11 files). Start from that branch; commit early and often.
