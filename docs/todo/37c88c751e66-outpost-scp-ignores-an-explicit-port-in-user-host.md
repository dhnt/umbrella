---
id: 37c88c751e66
kind: bug
title: outpost scp ignores an explicit :port in user@host:port:path (goes to 2222)
seq: 434
status: wontfix
priority: p3
labels:
    - outpost
created: 2026-11-17T20:39:11.798831Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-22T13:41:44.77798Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 656 ended): not critical for the next release, which is v1.0.0-rc.40 under Sprint 692 (docs/plan-sprint-692-release-thin-bashy.md).

2026-11-17: 'outpost scp <file> admin@<macOS QA host>:22:/path' dialed :2222 (lan-direct) and failed on password auth, while 'outpost ssh admin@<host>:22 -- ...' honours :22. Plain scp -P 22 worked. Fix parsing for parity with outpost ssh; unit test.
