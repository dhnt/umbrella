---
id: 89e608a24d53
kind: bug
title: 'genie: vault fallback calls ''bashy secret get'', which does not exist'
seq: 502
status: todo
priority: p1
labels:
    - genie
    - secrets
    - windows
created: 2026-11-19T04:08:24.658995Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Found 2026-11-18 on the operator's Windows host: genie:gemini-free (model kind api, api_key_ref GEMINI_API_KEY) failed with 'credential GEMINI_API_KEY is not in the environment, not bound in secrets.map, and not a vault secret by that name', and the log shows 'secret: unknown command "get" for "secret"'. The key IS in the vault (bashy secret list shows it). The vault lookup shells out to a verb the CLI no longer has. Workaround in place: GEMINI_API_KEY_API_KEY=@GEMINI_API_KEY in secrets.map. Fix: resolve through the same API secret exec uses; add a test.
