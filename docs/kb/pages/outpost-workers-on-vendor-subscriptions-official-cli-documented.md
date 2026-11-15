---
id: 01a1df7a-716c-7697-9879-c4a9e679e4b8
seq: 15
form: page
type: lesson
title: 'Outpost workers on vendor subscriptions: official CLI + documented long-lived token only'
description: 'WHEN designing an outpost-hosted agentic worker powered by a consumer AI subscription (Claude, ChatGPT/Codex, agy, Muse): authenticate the vendor''s OFFICIAL CLI with its documented headless credential (e.g. claude setup-token -> CLAUDE_CODE_OAUTH_TOKEN, one-year, model-requests-only) and treat subscription OAuth in any third-party client or SDK as a terms-of-service risk to re-verify at design time (Anthropic restricted subscription tokens to official clients 2026-02; wording shifted 2026-10-26). Design for the token''s reduced scope (no vendor-cloud extras), vault storage with per-worker config-dir isolation, and a credential-expiry probe wired to owner alerts, since expiry silently halts unattended work. Verify plan gating and client capabilities against the vendor''s own support/docs pages, not third-party blogs. Learned 2026-11-15 on Sprint 643.'
status: candidate
source:
    tool: claude
created: "2026-11-15T13:51:46Z"
---
