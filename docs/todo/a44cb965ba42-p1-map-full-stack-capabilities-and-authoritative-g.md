---
id: a44cb965ba42
kind: spike
title: P1 Map full-stack capabilities and authoritative gateway routing
seq: 336
status: wontfix
priority: p1
labels:
    - openai-integration
created: 2026-11-15T13:18:37.738785Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
closed: 2026-11-15T15:08:19.429606Z
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Inventory Cloudbox, Satellite, Outpost and Bashy operations, map each to established verbs/tools and distinguish implemented code, draft contracts, absent capability and live-unverified service behavior. Include account/member discovery, satellite management, host/attachment discovery, apps/services and Bashy workflows. Reuse S643 routing story 598058346ae0. Specify stable target identifiers and permission-filtered discovery, routing through existing connections, ambiguity/offline errors and version negotiation. Satellite is both a management target and a routing component where applicable, not a mandatory hop. Reconcile single- versus multiple-attachment documentation against actual source. Preserve local MCP boundaries and established Bashy execution/effect policy. Acceptance: capability-to-verb matrix for all four components, route diagrams/contracts and explicit implementation gaps; no direct public exposure of local admin endpoints.

## Web/mobile review requirements (2026-11-15)
Add route diagrams for web Work -> remote plugin gateway -> authorized stack target; Codex Cloud -> qualified gateway connection -> target; and mobile Remote -> paired desktop execution host -> gateway -> target. Label connection origin and credential holder at each boundary. The OpenAI remote-control relay is not an assumed public gateway API. Include originating-workstation offline versus actual target offline as separate cases. See f0cabeb9c6e3 for sources and unverified capabilities.

## Operator clarification: UI plus Outpost agent (2026-11-15)
Make the primary agentic route OpenAI web/mobile -> shared gateway -> durable dispatch -> selected Outpost -> subscription-backed Codex -> Bashy/local tools -> evidence/results. Inventory existing Bashy fleet/Codex launch, JSON event decoding, MCP installation and Outpost transport before proposing adapters. Distinguish the UI orchestrator from the Outpost execution worker; no recursive redispatch. Codex Cloud is an optional executor comparison, not completion of the Outpost requirement.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
