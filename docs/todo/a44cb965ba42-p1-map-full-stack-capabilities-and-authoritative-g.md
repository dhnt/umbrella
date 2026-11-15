---
id: a44cb965ba42
kind: spike
title: P1 Map full-stack capabilities and authoritative gateway routing
seq: 336
status: todo
priority: p1
labels:
    - openai-integration
created: 2026-11-15T13:18:37.738785Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Inventory Cloudbox, Satellite, Outpost and Bashy operations, map each to established verbs/tools and distinguish implemented code, draft contracts, absent capability and live-unverified service behavior. Include account/member discovery, satellite management, host/attachment discovery, apps/services and Bashy workflows. Reuse S643 routing story 598058346ae0. Specify stable target identifiers and permission-filtered discovery, routing through existing connections, ambiguity/offline errors and version negotiation. Satellite is both a management target and a routing component where applicable, not a mandatory hop. Reconcile single- versus multiple-attachment documentation against actual source. Preserve local MCP boundaries and established Bashy execution/effect policy. Acceptance: capability-to-verb matrix for all four components, route diagrams/contracts and explicit implementation gaps; no direct public exposure of local admin endpoints.
