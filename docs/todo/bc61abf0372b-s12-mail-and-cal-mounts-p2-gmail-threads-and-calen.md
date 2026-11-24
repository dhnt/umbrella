---
id: bc61abf0372b
kind: feature
title: 'S12 mail: and cal: mounts (p2): Gmail threads and Calendar events as read-only entries over google.bsh gmail-list|gmail-get and calendar-list'
seq: 301
status: wontfix
priority: p2
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:54.038227Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:25.445947Z
---

Planned vendor: glm. Example level, after S4. Entries carry subject/date/participants attrs; cat returns the thread/event as markdown; email.read rod where present; no write verbs. Accept: trove ls trove:mail/ and trove:cal/ list; cat returns md; hermetic fakes; refused without a read grant. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
