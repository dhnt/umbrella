---
id: e4b4085b0474
kind: task
title: 'gate host evidence retention: System event log overwritten in ~8 h; bashy-supervisord.log has no timestamps'
seq: 440
status: todo
priority: p3
labels:
    - venue
created: 2026-11-17T21:03:06.800228Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

2026-11-17 Klatch investigation: System log is 20 MB circular, oldest record 11-17T13:07Z, flooded by Configuration-Change-Monitor event 1 every ~5 s, so Kernel-Power 41 / 6005/6006/6008 for the 11-16 resets are gone. Venue: enlarge the System log or silence that provider. Product (bashy): supervisord log lines need timestamps so unit transitions align with other logs.
