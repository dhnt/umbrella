---
id: 634ddcb4b657
kind: spike
title: P2 Design OpenAI plugin presentation and optional MCP Events
seq: 338
status: todo
priority: p2
labels:
    - openai-integration
created: 2026-11-15T13:18:38.062308Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Reuse the shared gateway and S643 UI/text story db637f3c8ca5. Design plugin metadata, discoverable bounded tools, structured text results and optional rich UI only where client support is verified. MCP Events is documented for Work web, desktop Work with Cloud selected and dots; do not infer support elsewhere. Specify signed callback verification, authorization-filtered subscriptions, refresh/expiry, duplicate delivery and revocation behavior. Use durable status/result tools as the universal recovery path; align external alerts with S620. A UI click or chat yes cannot bypass server-side approval. Acceptance: per-client UI/event matrix, text-only workflow, no-push recovery and event contracts with current source references. Source: https://developers.openai.com/plugins/build/mcp-events .
