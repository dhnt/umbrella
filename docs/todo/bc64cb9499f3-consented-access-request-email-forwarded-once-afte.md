---
id: bc64cb9499f3
kind: feature
title: 'Consented access request: email forwarded once after explicit consent, api/request, owner grants by invite'
seq: 476
status: wontfix
priority: p1
labels:
    - shaping
    - cloudbox
    - privacy
    - superseded
created: 2026-11-18T20:52:37.077331Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:29.325579Z
---

A signed-in non-member who wants circle-scoped data presses Request access. The cloudbox edge holds the request to the app's declared api/request path behind a consent prompt (share your email with the owner of <host>?). Only after confirmation is X-Periscope-User forwarded, for that one request, marked X-Periscope-Consent: access-request, and the consent is audited. Declining forwards nothing. The site server records {email, wanted circle, message, time} and notifies the owner; the owner grants with the existing members invite EMAIL --circle C. No new cloudbox request store. Tests: no email without consent; consent covers one request only. Spec: docs/sprint-615-master-execution-plan.md (section: Moved to Sprint 665)

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M3 (`f876f5deafea`), M6 (`5d23ad18f7a1`). Access request shares identity only after explicit one-request consent, then uses existing invite/circle grants; distinct from a change request.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
