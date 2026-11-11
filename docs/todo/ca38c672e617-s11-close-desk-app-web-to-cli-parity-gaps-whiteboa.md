---
id: ca38c672e617
kind: bug
title: S11 Close desk-app web-to-CLI parity gaps (whiteboard, brainstorm, form answer, chart join)
seq: 109
status: done
priority: p1
labels:
    - collaboration-mvp
    - parity
created: 2026-11-11T04:01:42.389783Z
assignee: codex-gpt6-sol-w91
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
closed: 2026-11-11T04:40:04.916511Z
closed_by: claude-opus5.5-s614
---

Found by S1 (53b78fabbe9f; audit in bashy docs/ui-cli-parity.md, "Sprint 614 S1" section). Parity is one-way: every web/app action needs a bashy CLI path; CLI-only features need no page. Four desk apps expose page/HTTP actions with no CLI verb:

- Whiteboard: draw, clear, lock, invite revoke, JSON/PNG download (examples/whiteboard/server/index.html:115-120 vs server/cli.go:63-106).
- Brainstorm: idea edit/delete, vote, invite revoke, JSON/Markdown download (examples/brainstorm/server/index.html:147-159,182-188 vs server/cli.go:110-130).
- Form: respondent `answer` is page/HTTP only; CLI `join` prints a URL and has no `answer` (examples/desk/form/server/main.go:345-367 vs server/cli.go:432-440).
- Chart: HTTP `join` has no CLI case (examples/desk/chart/main.go:191-210 vs cli.go:112-121).

Fix: add the missing CLI verbs by calling each app's existing /api/action handlers (no new storage, no new identity), with --json, --dry-run on writes, the same owner/facilitator/member checks and the same denied result (404 for non-members) as the page. Prefer the existing per-app cli.go switch; keep each verb independently usable. Add a row per action to the S1 matrix.

Done when: each listed page action has a CLI verb returning the app's JSON envelope; a denied-access case per app matches the page; the apps' existing tests plus new verb tests pass (targeted, per app module). S6 re-verifies in the journey.
