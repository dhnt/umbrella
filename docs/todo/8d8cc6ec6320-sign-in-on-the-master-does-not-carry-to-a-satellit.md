---
id: 8d8cc6ec6320
kind: bug
title: Sign-in on the master does not carry to a satellite; satellite /signin is a 404
seq: 499
status: wontfix
priority: p1
labels:
    - cloudbox
    - satellite
    - shaping
    - superseded
created: 2026-11-19T00:28:50.92201Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:27.879267Z
---

Found in the Sprint 615 live run (2026-11-18, operator confirmed): a visitor signed in on the cloudbox master is anonymous on a satellite's app pages and must sign in again on the satellite (its root page, provider buttons); /signin on a satellite renders the SPA 404. Shaped sites linked visitors to /signin; the template now uses the satellite root. Hosted fix wanted: carry the master session to the satellite (or a one-click handoff), and serve /signin on satellites. Public wire contract only.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`). Master/satellite destination-preserving sign-in and account continuity retained; verify current implementation first.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
