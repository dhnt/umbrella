---
id: ec5677ccfbe8
kind: spike
title: P2 Design durable cross-client execution and ownership
seq: 337
status: wontfix
priority: p2
labels:
    - openai-integration
created: 2026-11-15T13:18:37.900493Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
closed: 2026-11-15T15:08:19.61564Z
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Compare direct bounded calls, steward delegation and hybrid handoff; retain one execution owner and explicit transfer. Reuse S643 recovery design 71e63b97abfb. Specify durable task IDs, idempotency keys, status/results/evidence, clarification, approval bound to action/target/candidate digest, cancellation and outcome, timeout/retry semantics, disconnect recovery and offline targets. Chat history and MCP transport sessions are not authoritative execution records. Acceptance: start from one client and retrieve from another; duplicate requests do not duplicate work; owner transfer avoids two coordinators; failed verification blocks activation; results distinguish asserted from verified success. Long-running execution must survive loss of the initiating client.

## Web/mobile review requirements (2026-11-15)
Specify web-to-iOS-to-Android continuation by gateway task ID independently of product chat-history sync. Cover backgrounding, app termination, reconnect, stale approval cards, duplicate taps, host switching and approvals arriving after cancellation or candidate changes. Bind each approval to principal, task, target, action and candidate; reject stale/replayed approval. Distinguish Cloud continuation from loss of a required desktop host. Work Cloud fallback must never silently replace the intended target or treat missing local tools as successful execution. See f0cabeb9c6e3 for sources.

## Operator clarification: UI plus Outpost agent (2026-11-15)
Specify the gateway task -> Outpost job -> Codex session mapping and one accountable execution owner. Handle worker crash, Outpost restart, subscription expiry/quota exhaustion, cancellation and reconnect without double execution or silent paid-provider fallback. UI-side orchestration and Outpost-side agentic execution are distinct roles; handoff must preserve target, authorization and evidence. Work may survive loss of the UI/originating workstation, but selected-Outpost offline is an explicit blocked/recovery state.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
