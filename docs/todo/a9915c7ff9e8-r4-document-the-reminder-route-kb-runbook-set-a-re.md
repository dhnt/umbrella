---
id: a9915c7ff9e8
kind: doc
title: 'R4 Document the reminder route: kb runbook ''set a reminder'' + calendar README line'
seq: 278
status: done
priority: p2
labels:
    - docs
created: 2026-11-14T22:23:12.776352Z
assignee: claude-fable5.2
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
closed: 2026-11-26T02:02:32.6976Z
closed_by: claude-fable5.2
---

There is no kb page for reminders (bashy kb search reminder finds nothing; re-checked 2026-11-25).
Write one kb runbook (agent-directed Bash#, scrubbed generic names) in bashy kb/defaults: bashy notify --at HH:MM / --in DUR --to <person agent or role> SUBJECT as the reminder primitive; schedule add --at for a command; where it lands (inbox, mb, bus subscribe --sink exec|tool-cmd; desktop via the agent-hub skill functions on macOS/Linux; no desktop toast on Windows yet, todo 77b9b977826d); the engine must be running, and how the R1 hint and schedule list engine line show it (depends on R1 80394689a60f).
Add one line to bashy/examples/calendar/README.md naming notify --at/--in beside bashy schedule as the reminder route.
Triage 2026-11-25: the two acceptance notes for Sprint 616 story eebd9e94a8b9 are dropped. Sprint 616 is done; the calendar README already documents the reminder route and the non-member result is settled at 404.
Done when: kb page registered and found by bashy kb search reminder; README line added.
