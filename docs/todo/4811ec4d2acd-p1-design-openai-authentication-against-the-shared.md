---
id: 4811ec4d2acd
kind: spike
title: P1 Design OpenAI authentication against the shared Cloudbox gateway
seq: 335
status: todo
priority: p1
labels:
    - openai-integration
created: 2026-11-15T13:18:37.599279Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Reconcile OpenAI requirements with S643 auth story 31424ce68e52; reuse one gateway and identity model. Specify OAuth 2.1, protected-resource and issuer discovery, PKCE S256, supported client registration/callbacks, resource/audience validation, refresh and revocation; scoped bearer access for headless clients. Map credentials to Cloudbox principals, membership and action/target grants; no forwarding local administrative tokens as user credentials. Evaluate existing identity-provider capability without claiming deployed support. Acceptance: per-client auth sequence, scope/tenant matrix, denied/expired/revoked credential scenarios and unresolved issuer decisions. Source: https://developers.openai.com/plugins/build/auth .
