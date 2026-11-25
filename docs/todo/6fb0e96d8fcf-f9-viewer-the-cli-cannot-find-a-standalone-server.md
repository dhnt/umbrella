---
id: 6fb0e96d8fcf
kind: bug
title: 'F9 Viewer: the CLI cannot find a standalone server, and the close-out template cannot read the sprint card'
seq: 702
status: wontfix
priority: p2
labels:
    - app
created: 2026-11-24T12:56:16.168661Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
closed: 2026-11-25T04:10:39.481683Z
---

Seen 2026-11-24 while publishing the Sprint 684 close-out. (1) After bashy viewer serve on its default address, viewer add/append/open failed with 'cannot discover viewer: ... no running instance recorded'; they worked only with VIEWER_ADDR and VIEWER_DATA set by hand. The CLI should find the standalone server it just started. (2) viewer append --template close-out with a book created by --sprint N failed with 'sprint card not found in sprint show output'; the x-source: sprint fill does not parse the current bashy sprint show --json. Worked only when the data supplied the sprint object itself. Unit tests for both. 3 points.

## Won't do (2026-11-24, operator: close Sprint 703)

Not needed for the MVP or the supported workflows (anonymous visitor, member, owner sharing and group shaping). Reopen with a new plan if a need appears.
