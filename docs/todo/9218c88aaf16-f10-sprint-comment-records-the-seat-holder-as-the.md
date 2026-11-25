---
id: 9218c88aaf16
kind: bug
title: F10 sprint comment records the seat holder as the author, not the commenter
seq: 703
status: wontfix
priority: p3
labels:
    - sprint
created: 2026-11-24T12:56:16.420377Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
closed: 2026-11-25T04:10:41.722973Z
---

Seen throughout Sprints 684 and 685: comments posted by the supervisor (BASHY_AGENT=claude-fable5.2 bashy sprint comment N ...) appear on the thread under the manager's name (codex-gpt6.2-astra, agy-gemini4-hydrogen). A reader cannot tell a manager's note from a supervisor's ruling, and the ledger attributes rulings to the wrong agent. The thread entry should carry the commenter's identity. Unit test. 2 points.

## Won't do (2026-11-24, operator: close Sprint 703)

Not needed for the MVP or the supported workflows (anonymous visitor, member, owner sharing and group shaping). Reopen with a new plan if a need appears.
