---
id: 56b2cdbb7c91
kind: enhancement
title: Elevation 'Sign-in required' page should link to the launcher (and the host's Connect)
seq: 500
status: wontfix
priority: p2
labels:
    - cloudbox
    - ux
    - superseded
created: 2026-11-19T01:04:32.249073Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:28.659578Z
---

Found in the Sprint 615 live run (2026-11-18, operator): opening an owner-only app URL directly (e.g. the console Shape page) shows 'Sign-in required — Open the launcher (the cloudbox home page) and click this app's tile to sign in.' with nothing clickable; the operator read it as a broken sign-in. The fix is in the hosted plane's elevation check (AbortProxyAuthErrorWithTitle in the proxy elevation middleware): render a link to the launcher, ideally deep-linked to the host's Connect so that after unlocking the browser returns to the requested URL. Public wire contract only in public docs.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M1 (`d051f99be309`), M4 (`1fd4ec42ac31`). Clickable sign-in/elevation recovery with return destination retained.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
