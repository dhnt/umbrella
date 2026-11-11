---
id: "219450271297"
kind: bug
title: S10 Circles are owner-defined names; the four are defaults (wire, fake, docs)
seq: 108
status: todo
priority: p1
labels:
    - collaboration-mvp
    - boundary
created: 2026-11-11T03:31:16.652956Z
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
---

Operator intent (2026-11-10): a circle is any owner-chosen name; family, friend, team and guest are only the default circles. Root cause: the W0 wire-review ruling (cloudbox ticket a99e88ac item 3a, 2026-11-09) narrowed the original ask ("family|friend|team|guest; optional team:<name>") to a closed set, and the public wire contract, the fake and the docs followed it. Classified as a spec defect; the access rule is already generic (yoke pkg/boundary Allowed matches `g == m.Circle`; `llm peer --circle` passes any name).

Rule: a circle name is a lowercase slug `[a-z0-9-]`, 1-32 characters. `public` and `owner` are reserved. Defaults family|friend|team|guest are suggestions; new members still default to `guest`. No circle table: a circle exists while some member carries it; listings offer the defaults plus names in use.

Public scope (this story): yoke docs/cloudbox-members-attach-wire.md (circle field, closed-set text at the field definition and decision 4); yoke pkg/fleet/cloudboxfake (`Circles`/`validCircle` become defaults + slug check, reserved names refused); bashy `member` help text, docs/boundary.md and docs/README.md wording; a circle-name test on the client side (invite/set/ls with a custom circle, reserved and malformed names refused with an actionable error, `llm peer --circle custom` allowed for a mutual member in it). Server half: cloudbox todo deaa6ba1717f.

Done when: custom circles round-trip through `bashy member invite|set|ls --circle NAME` against the fake; reserved/malformed names fail closed with a plain reason; `boundary.Allowed` unit coverage includes a custom circle; no doc in bashy or yoke describes circles as a closed set. Unblocks S9 (share a suite with a named circle).
