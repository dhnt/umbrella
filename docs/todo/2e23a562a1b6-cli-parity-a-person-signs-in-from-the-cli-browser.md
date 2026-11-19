---
id: 2e23a562a1b6
kind: feature
title: 'CLI parity: a person signs in from the CLI (browser loopback/device flow) so member invitations and accept work without the web UI'
seq: 505
status: wontfix
priority: p1
labels:
    - cli
    - members
    - parity
    - cloudbox
    - superseded
created: 2026-11-19T06:02:58.780629Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:30.252503Z
---

Operator 2026-11-18 (Sprint 615 recruiter test): accepting a membership needed the web Members page (row menu, then Accept). bashy member invitations and bashy member accept ID --circle C exist, but they need a bearer token for the INVITEE's account. bashy login pairs a machine, not a person, and bashy token create only attenuates an existing token, so an invitee without a paired machine has no CLI path (UI to CLI parity is one-way: every web action needs a CLI path). Add a person sign-in for the CLI: bashy login --person, or bashy account login cloudbox, opening the provider sign-in in the browser with a loopback or device code, minting a short-lived members:read/write token stored by reference in the vault, never printed. Then: bashy member invitations, bashy member accept ID. Also verify the web row menu offers Accept for an inactive membership (the operator could not find it). Public wire contract only.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`). Person CLI authentication and invitation parity retained; never print bearer credentials.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
