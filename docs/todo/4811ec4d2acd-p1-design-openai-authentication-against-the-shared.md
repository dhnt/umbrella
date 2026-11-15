---
id: 4811ec4d2acd
kind: spike
title: P1 Design OpenAI authentication against the shared Cloudbox gateway
seq: 335
status: wontfix
priority: p1
labels:
    - openai-integration
created: 2026-11-15T13:18:37.599279Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
closed: 2026-11-15T15:08:19.234171Z
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Reconcile OpenAI requirements with S643 auth story 31424ce68e52; reuse one gateway and identity model. Specify OAuth 2.1, protected-resource and issuer discovery, PKCE S256, supported client registration/callbacks, resource/audience validation, refresh and revocation; scoped bearer access for headless clients. Map credentials to Cloudbox principals, membership and action/target grants; no forwarding local administrative tokens as user credentials. Evaluate existing identity-provider capability without claiming deployed support. Acceptance: per-client auth sequence, scope/tenant matrix, denied/expired/revoked credential scenarios and unresolved issuer decisions. Source: https://developers.openai.com/plugins/build/auth .

## Web/mobile review requirements (2026-11-15)
Separate three authorizations: OpenAI account/workspace access, device pairing for host-backed Remote, and the Cloudbox gateway principal/grants. Pairing is not gateway OAuth consent. Specify web/plugin redirect and mobile sign-in/return flows, wrong-workspace denial, expired credentials, reconnect and revocation. For host-backed calls record which host holds the gateway credentials; for Cloud require independent credentials/connectivity. No token copying through prompts. Source-backed surface distinctions and references: f0cabeb9c6e3, review update.

## Operator clarification: UI plus Outpost agent (2026-11-15)
Treat subscription sign-in for the Codex worker on each Outpost as a fourth identity boundary, separate from the UI account, gateway principal and any optional device pairing. Specify account/seat ownership, supported noninteractive provisioning after authorized login, credential storage/isolation, refresh/revocation and attribution. The UI caller's gateway grant must not implicitly grant another subscription identity. Qualify plan and workspace eligibility; do not assume unlimited usage or silently fall back to API billing.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
