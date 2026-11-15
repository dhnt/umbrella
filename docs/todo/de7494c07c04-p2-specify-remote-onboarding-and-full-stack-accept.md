---
id: de7494c07c04
kind: test
title: P2 Specify remote onboarding and full-stack acceptance matrix
seq: 339
status: wontfix
priority: p2
labels:
    - openai-integration
created: 2026-11-15T13:18:38.230974Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
closed: 2026-11-15T15:08:19.522456Z
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Design acceptance scenarios, do not execute live tests. Cover ChatGPT web/desktop/mobile, dots, Codex CLI/IDE/app/cloud, Responses API, Agents API and SDK with explicit supported/unsupported/unverified verdicts, versions, account gates and connection origin. On a clean supported remote client machine without the stack installed, sign in, discover only authorized Cloudbox/Satellite/Outpost/Bashy capabilities, select stable targets, perform bounded operations and retrieve the same durable task from another client. Include cross-account denial, scope restriction, credential revocation, ambiguous/multiple attachments, offline hosts, retries, cancellation and evidence provenance. Walk wish -> candidate -> verify -> preview -> approve -> activate -> undo from interactive and headless callers. Acceptance: reproducible onboarding/config templates without secrets, client x component coverage, expected outcomes and pilot implementation handoff; explicitly separate documentation/source checks from future live proof.

## Additional acceptance scenarios from web/mobile review (2026-11-15)
Design only; future live qualification must record exact OS/browser/app build, plan/seat, workspace permissions, mode, execution location and source date.
1. Clean desktop browser: open Work, install/connect the approved plugin, discover permitted targets across all four components and retrieve evidence.
2. Codex Cloud: select a published environment, qualify gateway tools/auth, start a task and retrieve it with the originating workstation offline.
3. iOS and Android separately: start/continue Cloud work where available; otherwise record the specific unsupported/unverified gate. Test phone app suspension, reconnect and approval detail visibility.
4. Host-backed Remote on both mobile OSes: pair from the desktop app; inspect host identity and inherited tools; test host sleep/offline and revoked pairing. Do not score this as workstation-independent Cloud access.
5. Cross-client recovery: retrieve the same gateway task by ID without relying on shared chat history; reject wrong-account, stale and duplicate approvals; cancel and verify terminal state.
6. Mobile browser and regular Chat: qualify independently, including text-only recovery and explicit unsupported verdicts where established. No parity assumption.
7. Disable notifications/events: retrieve status and results manually. Distinguish native mobile notifications from gateway event support.
Use the focused source matrix and open questions in f0cabeb9c6e3. None of these scenarios has been executed by this review.

## Operator clarification: UI plus Outpost agent (2026-11-15)
Required end-to-end scenario: from OpenAI web UI, authorize the shared gateway, discover stack targets, choose an Outpost, dispatch agentic work to subscription-authenticated Codex on that Outpost, execute Bashy tools, verify the result, and retrieve/approve it from iOS or Android with the originating workstation offline. Record worker/session and execution-target evidence; merely running in Codex Cloud does not pass. Cover both direct deterministic full-stack operations and this agentic path. Specify Outpost restart/offline, expired subscription login, quota limits, cancellation and denied cross-principal access; no automatic API-billed fallback. Earlier Cloud/headless scenarios are optional comparisons; the two operator outcomes govern acceptance.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
