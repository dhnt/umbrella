---
id: 14bb7d2b5eab
kind: test
title: F2 Deployed suite-to-circle sharing e2e on a satellite (200/403/401, live revoke)
seq: 123
status: todo
priority: p1
labels:
    - collaboration-followup
created: 2026-11-11T09:56:30.912325Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Sprint 614 S9 shipped suites and circle shares (cloudbox 07411af server + console, yoke d0ba2a11 bashy suite, outpost ee1c3344 apps share --circle) verified at unit level and against the fake master only. Run once on the Linux test host with the existing cloudbox e2e harness against a satellite built from those commits: owner creates a named circle, a suite of two apps on two hosts, shares the suite with the circle; member in circle gets 200 on both apps, member outside 403, no credential 401; moving the member out of the circle and removing an app from the suite flip to 403 without re-share; console and CLI show the same suites/grants. Evidence tied to candidate commits.
