---
id: ec5677ccfbe8
kind: spike
title: P2 Design durable cross-client execution and ownership
seq: 337
status: todo
priority: p2
labels:
    - openai-integration
created: 2026-11-15T13:18:37.900493Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Compare direct bounded calls, steward delegation and hybrid handoff; retain one execution owner and explicit transfer. Reuse S643 recovery design 71e63b97abfb. Specify durable task IDs, idempotency keys, status/results/evidence, clarification, approval bound to action/target/candidate digest, cancellation and outcome, timeout/retry semantics, disconnect recovery and offline targets. Chat history and MCP transport sessions are not authoritative execution records. Acceptance: start from one client and retrieve from another; duplicate requests do not duplicate work; owner transfer avoids two coordinators; failed verification blocks activation; results distinguish asserted from verified success. Long-running execution must survive loss of the initiating client.
