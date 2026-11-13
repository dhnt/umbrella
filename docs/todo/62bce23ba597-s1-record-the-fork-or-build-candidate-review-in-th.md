---
id: 62bce23ba597
kind: doc
title: S1 record the fork-or-build candidate review in the private spec
seq: 207
status: done
priority: p1
labels:
    - shaping
created: 2026-11-13T11:33:41.512601Z
assignee: claude-opus5.5-s631
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
closed: 2026-11-13T12:04:58.023769Z
closed_by: claude-opus5.5-s631
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (MIT/Apache-2.0/BSD/ISC, LICENSE file read, no open-core ee/), >=1k stars, maintained -> fork + make shapeable; else build. Ships as a custom command in bashy/examples/<job>/, never core. Neutral job-only wording in public files. Candidate review: private spec of Sprint 631. Done = shaping demo (wish, candidate, verify, preview, approve, undo; visible only to the requester) + license re-verified.
