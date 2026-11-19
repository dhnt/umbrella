---
id: 2e23a562a1b6
kind: feature
title: 'CLI parity: a person signs in from the CLI (browser loopback/device flow) so member invitations and accept work without the web UI'
seq: 505
status: todo
priority: p1
labels:
    - cli
    - members
    - parity
    - cloudbox
created: 2026-11-19T06:02:58.780629Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Operator 2026-11-18 (Sprint 615 recruiter test): accepting a membership needed the web Members page (row menu, then Accept). bashy member invitations and bashy member accept ID --circle C exist, but they need a bearer token for the INVITEE's account. bashy login pairs a machine, not a person, and bashy token create only attenuates an existing token, so an invitee without a paired machine has no CLI path (UI to CLI parity is one-way: every web action needs a CLI path). Add a person sign-in for the CLI: bashy login --person, or bashy account login cloudbox, opening the provider sign-in in the browser with a loopback or device code, minting a short-lived members:read/write token stored by reference in the vault, never printed. Then: bashy member invitations, bashy member accept ID. Also verify the web row menu offers Accept for an inactive membership (the operator could not find it). Public wire contract only.
