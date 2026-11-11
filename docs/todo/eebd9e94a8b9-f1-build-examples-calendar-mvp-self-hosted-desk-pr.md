---
id: eebd9e94a8b9
kind: feature
title: F1 Build examples/calendar MVP (self-hosted, Desk primitives, ICS + Google import/export)
seq: 122
status: todo
priority: p1
labels:
    - collaboration-followup
created: 2026-11-11T09:56:30.56162Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Decided in Sprint 614 S8: bashy docs/calendar-decision.md section 5 is the draft story. Build examples/calendar from examples/desk/kit + notepad patterns: event entity with explicit IANA tz, agenda page, add/show/set/list/cancel/open/share/close/serve/export/import/save/load verbs with --json and --dry-run on writes, Desk owner/invite/member audience (404 for non-members), save/load to a Git dir, ICS import/export with idempotent source.uid, Google import/export composing examples/google. Placement examples/ only, not in bashy-defaults. Done when: desk contract test, Go tests and browser round trip pass; every page action has a CLI verb with the same denied result; creating an event executes nothing; no recurrence/RSVP/reminders/CalDAV/sync.
