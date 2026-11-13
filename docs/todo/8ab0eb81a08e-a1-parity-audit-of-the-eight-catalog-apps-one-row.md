---
id: 8ab0eb81a08e
kind: task
title: 'A1 parity audit of the eight catalog apps: one row per web action in bashy/docs/ui-cli-parity.md'
seq: 236
status: done
priority: p1
labels:
    - parity
    - app
created: 2026-11-13T17:39:22.949144Z
weave: 62
assignee: agy-gemini3.8-flash
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:22:53.979343Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md and bashy/docs/ui-cli-parity.md (rule at lines 1-30; pattern = the "Sprint 614 S1" section and done story ca38c672). Parity is one-way: every web/page/HTTP action of a catalog app needs a bashy verb (--json; --dry-run on writes; same owner/member checks and the same denied result as the page). CLI-only features need no page.

Scope: notes, form, clips, site (+ chat template), board, whiteboard, table, files. For each app enumerate the page and HTTP actions of the shipped build (the fork's UI plus our adapter routes) and write one row per action in a new "Sprint 632 A1" section: action | existing verb or GAP | evidence (file:line or command output). Refresh the stale whiteboard rows (they cite examples/whiteboard/server/cli.go, which no longer exists; the current whiteboard.bsh is lifecycle-only). Record for files that outpost's built-in File Browser is reached through bashy outpost connect/ssh/scp.

Hand each GAP to the owning story (A2 notes, A3 board, A4 table, A5 whiteboard, A6 form/clips/site) by listing the gap rows on that story's note; file a standalone todo (--no-sprint, label parity) only for a gap no phase-1 story owns.

Current state found by the review (verify, do not assume): notes/board/whiteboard/table expose only install/start/stop/status/source; form, clips and site have action verbs; form --help advertises append but not join while its case does the reverse.

Done when: every action of the eight apps has a row with verb-or-gap-or-reason, the whiteboard rows are current, and every gap is owned. Doc-only story: no runtime proof needed beyond reading the shipped builds; cite commands run.
