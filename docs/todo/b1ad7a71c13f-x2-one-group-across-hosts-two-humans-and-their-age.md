---
id: b1ad7a71c13f
kind: test
title: 'X2 One group across hosts: two humans and their agent members on two outposts shape one item and steer each other''s agents'
seq: 582
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:43:12.833961Z
sprint: 685
sprint_id: f684d38b-201d-5579-bd47-c70e26524188
sprint_title: 'Group shaping coverage: every bashy app as a test case, plus cross-outpost agent steering in one circle'
---

The group e2e on the fleet-mirror venue (throwaway instance, several fake accounts, satellite owner not equal to host owner). Human A on outpost 1 and human B on outpost 2 are in one circle; each registers an agent member (G5). Run the Sprint 684 group-shape skill-script on one shared item with all four participants, then: A steers B's agent through the X1 path and B approves a pending prompt of A's agent remotely; an outsider and a removed member are refused; history shows owner and agent for every revision; every action used has its CLI verb. Evidence tied to the candidate commits. Depends on G4, G5 and X1. Contract: docs/plan-group-participation.md.
