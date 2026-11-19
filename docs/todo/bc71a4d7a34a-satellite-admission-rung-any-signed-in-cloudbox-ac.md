---
id: bc71a4d7a34a
kind: feature
title: 'Satellite admission rung: any signed-in cloudbox account (the signed-in tier for shaped sites)'
seq: 485
status: wontfix
priority: p1
labels:
    - shaping
    - cloudbox
    - privacy
    - superseded
created: 2026-11-18T21:26:49.629511Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:28.347738Z
---

Found in the Sprint 615 live prep (2026-11-18, operator chose to defer): host apps are served only through satellites, and satellite admission (grant.Admits via SatellitesAPI.admittedBy) matches mutual members only, while the master refuses a non-admitted sign-in to the satellite. So a signed-in non-member is always anonymous on the engine face and the 'signed-in' tier of docs/sprint-615-master-execution-plan.md cannot be shown. Add an owner-chosen admission rung 'any signed-in account' (public wire contract; never quote hosted internals in public docs). Such a session reaches only require_login=false apps as a non-member: app grants are unchanged, and outpost (c4e1154) already turns the address into a per-app pseudonym. Accept: admission unit cases (rung off: non-member refused; rung on: admitted, still not a member for host grants), then the S14 signed-in step on the showcase.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`), M3 (`f876f5deafea`). Explicit signed-in non-member admission for public apps retained without widening member grants.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
