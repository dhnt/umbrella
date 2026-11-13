---
id: 152dcd981ebd
kind: task
title: 'S4b board: stub the web crash-report SDK too; make board-console buildable in-repo'
seq: 231
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-13T14:50:31.758229Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md. From the S4 review (conductor 2026-11-13): (1) the shipped web bundle still imports @sentry/react; it is inert (no DSN is ever set) but the rule is remove, not disable: alias @sentry/react to a no-op stub like sentry-stub.ts does for the API. (2) examples/board/board-console embeds dist/api.mjs, which exists only after install, so go vet/test inside examples/board fails on a clean checkout; make the in-repo copy build (e.g. a placeholder dist with a build tag, or keep the console as a .tmpl copied at install, like examples/notes/shape_version.go.tmpl).
