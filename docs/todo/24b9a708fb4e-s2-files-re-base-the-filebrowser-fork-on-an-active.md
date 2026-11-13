---
id: 24b9a708fb4e
kind: task
title: 'S2 files: re-base the filebrowser fork on an active Apache-2.0 upstream; audit command runner and JWT session revocation'
seq: 208
status: todo
priority: p0
labels:
    - shaping
created: 2026-11-13T11:33:41.648454Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified. Upstream filebrowser/filebrowser archived 2026-09-01 (no security fixes). Candidate upstream: gtsteffaniak/filebrowser (Apache-2.0, Go). Audit applies whether or not we re-base.
