---
id: 770e6e1fa548
kind: feature
title: 'J3b Refused wish -> ''Suggest it to the owner'': a stored request with consent, identical wishes combined, owner reads by CLI'
seq: 521
status: todo
priority: p1
labels:
    - desktop
created: 2026-11-19T09:41:02.942195Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
---

Operator request 2026-11-19 (J3 live check): a refused wish must be impossible to miss (red alert, done in cloudbox 3041a08), say the owner could grant it, and offer an optional feedback link. Operator chose a stored request (slice of Sprint 638 S11 349ecc908c9b for the hosted desktop). Scope: wish refusals carry code not_grantable (model error or schema refusal) or no_change; desktop_requests table (schema rev 30) storing words only, keyed by normalized wish, people counted once each; POST /api/v1/desktop/request (desktop:write, own account) and GET/DELETE /api/v1/desktop-policy/requests (superadmin or satellite owner); export/import admit the tables; CLI 'bashy desktop request WORDS [--reason R]' and 'bashy desktop policy requests ls|rm ID --json'; UI qualifier + link, consent before sending, 'Sent. N people asked for this.' No extra allowance charge (the refusal already counted). Guardrails from S11: words never effects; stored text is untrusted data; identical wishes aggregate; nothing sent without the click. Done when: store + handler tests (aggregation, own-account only, owner-only read, no side effect), CLI tests, UI check in a browser, released and verified live on the J3 recording.
