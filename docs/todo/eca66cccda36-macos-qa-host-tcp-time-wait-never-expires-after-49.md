---
id: eca66cccda36
kind: bug
title: 'macOS QA host: TCP TIME_WAIT never expires after 49.7 days uptime (venue); reboot before the rc.41 tier run'
seq: 749
status: todo
priority: p1
labels:
    - release
    - macos
created: 2026-11-25T11:43:46.006608Z
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
---

Root cause (venue, 2026-11-25): the macOS QA host has been up 57 days. Past 2^32 ms (49.7 days) the macOS TCP clock wraps and TIME_WAIT entries are never reaped: the count is frozen at 39163 across 10+ minutes, and outbound connects fail (curl to GitHub and to a localhost listener both return 000). Same symptom as the rc.40 macOS INCOMPLETE. Fix in the venue: reboot the host (operator approval), then add an uptime < 45 days preflight to the tier kit. No product change.
