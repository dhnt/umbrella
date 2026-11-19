---
id: 74083e97e887
kind: feature
title: Give todos, sprints and runs portable three-handle refs
seq: 525
status: assigned
priority: p1
labels:
    - refs
    - work
created: 2026-11-19T11:31:53.264738Z
weave: 96
assignee: claude-sonnet5.5
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

Implement the shipped D14 UUID, scoped slug and parent-local sequence contract for Yoke todo, sprint and Weave run records. Preserve existing Story-ID 12-hex aliases, persisted sprint UUID/slug migration, run identity distinct from conversation Instance, and all legacy name/number lookups. Own pkg/issue, pkg/todo and pkg/weave work-ref resolver files; do not edit fleet Resource or the shared ref vocabulary (owned by #524). Add ambiguity-safe ancestral scope lookup and portable output, with read/write persistence rather than response-only UUID fabrication. Verify old and new handles, duplicate local seq, cross-scope UUID lookup and unchanged authorization with focused Go tests and three-OS vet. Isolated workspace, true Agent trailers, no push until manager review.
