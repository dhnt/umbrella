---
id: 9deb591a820c
kind: bug
title: outpost podman capability reports active/health ok when no podman socket is detected
seq: 438
status: done
priority: p2
labels:
    - outpost
created: 2026-11-17T21:03:06.511598Z
assignee: claude-fable5.1
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-22T13:44:37.768365Z
closed_by: claude-fable5.1
---

2026-11-17 gate host: daemon logs 'podman: unavailable, will re-probe reason=... no podman socket detected ... start the machine' then 'service state unit=podman from=starting to=active'; status shows podman active, health ok while the machine is stopped, so a 39 h Klatch outage raised no alert. Fix: absent socket -> inactive/degraded with the reason; health surfaces it. Unit test in capability_podman; build.
