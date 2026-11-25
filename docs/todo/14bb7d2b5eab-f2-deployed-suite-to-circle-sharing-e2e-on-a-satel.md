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
sprint: 710
sprint_id: 063b46d6-77e0-5d5b-8dc0-2fd08f8234a2
sprint_title: 'Owner sharing: apps and suites to circles and members, public apps, invites that arrive'
---

Sprint 614 S9 shipped suites and circle shares (cloudbox 07411af server + console, yoke d0ba2a11 bashy suite, outpost ee1c3344 apps share --circle) verified at unit level and against the fake master only. Run once on the Linux test host with the existing cloudbox e2e harness against a satellite built from those commits: owner creates a named circle, a suite of two apps on two hosts, shares the suite with the circle; member in circle gets 200 on both apps, member outside 403, no credential 401; moving the member out of the circle and removing an app from the suite flip to 403 without re-share; console and CLI show the same suites/grants. Evidence tied to candidate commits.

## Sprint 710 H6 (2026-11-24): extended acceptance

Moved from the backlog into Sprint 710 (owner sharing) as its acceptance story. Besides the checks above: the circle is an owner-named custom circle; a publicly published app answers an anonymous visitor and a logged-in non-member identically (as anonymous); re-inviting a pending member delivers the mail; the CLI share listing (H1, S14) matches the console. Record the outpost grant-cache TTL as the "live revoke" bound. Green twice on the Linux test host after H1-H5 merge. Plan of record lives with the sprint card.
