---
id: caa3c8008950
kind: test
title: P2 Specify clean remote-machine and mobile-to-workstation acceptance scenarios for Google clients
seq: 346
status: wontfix
priority: p2
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:37:08.514732Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
closed: 2026-11-15T15:08:20.9409Z
---

## Scope
Specify end-to-end acceptance scenarios for Google web/mobile/`agy` UIs driving `agy` CLI/subscription execution on remote outposts; design only.

## Scenarios to specify
1. **Clean web-to-mobile onboarding**: Link Cloudbox remote MCP URL once in `gemini.google.com` (`Settings > Connected Apps`), complete OAuth, verify auto-sync and `@cloudbox` invocation on Gemini Android/iOS (with Keep Activity ON gate explicit).
2. **Mobile-to-outpost shaping lifecycle (`agy` on outpost)**: Start wish on Gemini mobile app -> Cloudbox hub routes to target outpost -> outpost steward delegates coding work to `agy` CLI (headless `-p --output-format stream-json` or `agy acp` using `agy` subscription + `bashy` shims/MCP) -> S620 approval alert -> inspect diff and approve by candidate digest from Gemini mobile, `gemini.google.com`, or `agy` CLI on another machine -> verify and undo.
3. **Headless ADK / `agy` print-mode**: Connect via scoped Cloudbox bearer token without browser OAuth; verify bounded read-only queries, idempotent `delegate`, and `task_id` recovery.
4. **Offline host, subscription & failure honesty**: Target outpost offline, expired Cloudbox token (401 `WWW-Authenticate`), expired/unauthenticated `agy` subscription on an outpost, and text fallback when MCP Apps UI is unavailable.

## Done when
Acceptance scenarios and pass/fail criteria are documented with source vs live-evidence boundaries clear. No implementation or live runs.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
