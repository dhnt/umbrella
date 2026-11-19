---
id: 89e608a24d53
kind: bug
title: 'genie: vault fallback calls ''bashy secret get'', which does not exist'
seq: 502
status: wontfix
priority: p1
labels:
    - genie
    - secrets
    - windows
    - superseded
created: 2026-11-19T04:08:24.658995Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:29.950344Z
---

Found 2026-11-18 on the operator's Windows host: genie:gemini-free (model kind api, api_key_ref GEMINI_API_KEY) failed with 'credential GEMINI_API_KEY is not in the environment, not bound in secrets.map, and not a vault secret by that name', and the log shows 'secret: unknown command "get" for "secret"'. The key IS in the vault (bashy secret list shows it). The vault lookup shells out to a verb the CLI no longer has. Workaround in place: GEMINI_API_KEY_API_KEY=@GEMINI_API_KEY in secrets.map. Fix: resolve through the same API secret exec uses; add a test.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Replaced by M4 (`1fd4ec42ac31`), M5 (`1948f3a043de`). Repair unsupported vault fallback if still present on the onboarding candidate; no new vault product.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
