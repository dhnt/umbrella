---
id: a13e32879db6
kind: bug
title: 'Single sign-out: signing out of the master should end satellite sessions'
seq: 506
status: wontfix
priority: p1
labels:
    - cloudbox
    - satellite
    - auth
    - superseded
created: 2026-11-19T06:11:45.594015Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:28.191892Z
---

Found in the Sprint 615 live run (2026-11-18, operator): after signing out of the cloudbox master, a shaped site on a satellite still showed the signed-in view, because the satellite keeps its own session cookie on its own origin. Counterpart of 8d8cc6ec (sign-in does not carry to satellites). Want: master sign-out also ends that account's sessions on satellites (front-channel logout fan-out, or a session generation the satellite checks), and a satellite /cloud/logout that accepts ?next= to return to a page. Interim: shaped-site panels offer Sign out on their own origin. Public wire contract only.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`). Cross-origin sign-out/account-switch isolation retained.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
