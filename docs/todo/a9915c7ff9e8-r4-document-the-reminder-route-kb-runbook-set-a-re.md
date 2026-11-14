---
id: a9915c7ff9e8
kind: doc
title: 'R4 Document the reminder route: kb runbook ''set a reminder'' + calendar F1 acceptance notes'
seq: 278
status: todo
priority: p2
labels:
    - docs
created: 2026-11-14T22:23:12.776352Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

There is no kb page for reminders (bashy kb search 'calendar reminder' finds nothing). Write one kb runbook (agent-directed Bash#, scrubbed generic names): bashy notify --at HH:MM / --in DUR --to <person agent or role> SUBJECT as the reminder primitive; schedule add --at for a command; where it lands (inbox, mb, bus subscribe --sink exec|tool-cmd; desktop via the agent-hub skill functions on macOS/Linux; no Windows toast yet, see R5); the engine must be enabled (R1). Add two acceptance notes to Sprint 616 story eebd9e94a8b9 (calendar F1) via sprint comment, not by editing its body: the README documents notify --at as the reminder route; settle the 403 vs 404 non-member result (notepad returns 403, calendar-decision.md says 404; docs/sprint-616-master-execution-plan.md line 84). Done when: kb page registered and found by kb search 'reminder'; comment posted on eebd9e94a8b9.
