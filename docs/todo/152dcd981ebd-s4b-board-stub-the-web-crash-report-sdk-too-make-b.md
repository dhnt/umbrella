---
id: 152dcd981ebd
kind: task
title: 'S4b board: stub the web crash-report SDK too; make board-console buildable in-repo'
seq: 231
status: done
priority: p2
labels:
    - shaping
created: 2026-11-13T14:50:31.758229Z
weave: 67
assignee: codex-gpt5.6-sol
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:22:56.284628Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md. From the S4 review (conductor 2026-11-13): (1) the shipped web bundle still imports @sentry/react; it is inert (no DSN is ever set) but the rule is remove, not disable: alias @sentry/react to a no-op stub like sentry-stub.ts does for the API. (2) examples/board/board-console embeds dist/api.mjs, which exists only after install, so go vet/test inside examples/board fails on a clean checkout; make the in-repo copy build (e.g. a placeholder dist with a build tag, or keep the console as a .tmpl copied at install, like examples/notes/shape_version.go.tmpl).
