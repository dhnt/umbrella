---
id: 9bc0dd7f28a1
kind: feature
title: 'S5 whiteboard: fork as a shapeable custom command'
seq: 211
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-13T11:33:42.049695Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified. Base: excalidraw/excalidraw (MIT) + small collab/storage service; fold in examples/whiteboard and brainstorm. Uses the S3 template.
