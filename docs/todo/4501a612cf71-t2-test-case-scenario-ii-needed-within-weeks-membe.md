---
id: 4501a612cf71
kind: test
title: 'T2 test case (scenario ii, needed within weeks): members contribute project submissions; a shaped review presenter summarizes and scores them; each consumer sees their granted view'
seq: 303
status: wontfix
priority: p2
labels:
    - shaping
    - content
    - trove
    - scenario
created: 2026-11-14T23:54:31.681289Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:15.61754Z
---

Planned vendor: claude + glm. A TEST CASE for the general product, not a feature. Setup: an owner's trove with a 'projects' mount; members contribute SYNTHETIC submissions (short clips + blurb; committed fixtures, no PII, generic names) through S3; the owner shapes a 'review' presenter (S2/S8 hook: transcribe + video.understand + text against the group's own scoring guide in presenters.json) whose output is a summary plus scores labelled as presenter output, never a grade of record; grants (S6) give staff everything and the public showcase only marked entries; if contributors must see only their own entries, the owner adds a shaped grant rule for this trove (recorded here; generalized into S6 only when a second case appears). The whole flow is one short Bash# skill-script composing trove verbs. Media stages on the claimed GPU gate host, text path on the dev box. First instance: a film-making club. Rod, not fish: small --json verbs with meaningful exit codes; any higher flow is a short Bash# skill-script composing them, itself shapeable. Accept: owner, a contributor, a staff member and an anonymous visitor see the expected subsets on CLI and explorer; the presenter was shaped, verified and undone through bashy shape; evidence from the gate host recorded. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
