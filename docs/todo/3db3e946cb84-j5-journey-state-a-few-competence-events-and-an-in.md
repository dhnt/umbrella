---
id: 3db3e946cb84
kind: feature
title: 'J5 Journey state: a few competence events and an invitation table, as data'
seq: 316
status: assigned
priority: p2
labels:
    - software-shaping
created: 2026-11-15T02:58:08.980397Z
weave: 103
assignee: claude-sonnet5.5
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the try-now showcase — a visitor shapes ai.dhnt.io inside the owner''s declared boundary, proven Red-Green-Refactor'
---

Law 2 of docs/dhnt-journey-design.md: the next rung is offered only after the current one has been USED. That needs state, and KISS says it is a handful of events, not a subsystem.

Scope: named events in the same document J2 already stores (shaped, undone, invitation shown, taken, dismissed); the invitation rules as a SMALL DATA TABLE (condition -> invitation id -> the one action it offers), itself shapeable so a person can silence or reorder their own invitations; bashy journey status|next --json so an agent reads the same state; one invitation implemented end to end — rung 2, attach your machine — shown only after a first shape and a first undo.

Acceptance: a fresh account sees no invitation; after one shape and one undo the rung-2 invitation appears exactly once; dismissal sticks; the table is a file an edit can extend; --json parity.

## Working rules (conductor, 2026-11-19)

- Deadline: land on cloudbox dev (or outpost main) before Sprint 666 reports green; the next cloudbox build (v0.18.77) ships it and closes Sprint 641. No tag, release or deploy by the worker.
- Disk and builds: the dev box was at 100% today. Run focused package tests only (the packages you touch); no full suites, no cache wipes, no module downloads you do not need. Cloudbox handlers/server/api tests are Linux-only: run them on the Windows test host WSL, claiming it by its bare registered resource name as shown by `bashy claim list` (never the host:<name> form; queue behind the holder; never force), per cloudbox docs/kb/pages/run-cloudbox-hub-unit-tests-from-a-non-linux-dev-box.md. Use `ssh -n`, print sha256 before copying files out, never kill mid-write.
- Cloudbox schema: dev is at SchemaRevision 30. If you add a table take 31, add it to BOTH export lists, and regenerate schema goldens (default and -tags cloudbox_satellite) and all 4 route goldens on Linux.
- Handler tests use TestMain's shared db.DB; never testutil.TwoUsers in internal/handlers (it swaps the global DB and breaks later tests).
- Commit trailers: Sprint #641, Story #<seq>, Story-ID, Agent = your assigned name. Root cause before any fix of a red test that was green.
- Decision (conductor, per the operator's "don't wait"): the rung-2 invitation leads with "your own files in reach" (the plan's recommendation; docs/sprint-641-master-execution-plan.md, operator decision 2). The invitation table is a data file an edit can extend. Store competence events, not traffic. Add `bashy desktop` --json parity for reading the journey state and dismissing the invitation.
