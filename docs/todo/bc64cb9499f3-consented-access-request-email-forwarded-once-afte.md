---
id: bc64cb9499f3
kind: feature
title: 'Consented access request: email forwarded once after explicit consent, api/request, owner grants by invite'
seq: 476
status: todo
priority: p1
labels:
    - shaping
    - cloudbox
    - privacy
created: 2026-11-18T20:52:37.077331Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

A signed-in non-member who wants circle-scoped data presses Request access. The cloudbox edge holds the request to the app's declared api/request path behind a consent prompt (share your email with the owner of <host>?). Only after confirmation is X-Periscope-User forwarded, for that one request, marked X-Periscope-Consent: access-request, and the consent is audited. Declining forwards nothing. The site server records {email, wanted circle, message, time} and notifies the owner; the owner grants with the existing members invite EMAIL --circle C. No new cloudbox request store. Tests: no email without consent; consent covers one request only. Spec: docs/sprint-615-master-execution-plan.md (section: Moved to Sprint 665)
