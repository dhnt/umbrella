---
id: de7494c07c04
kind: test
title: P2 Specify remote onboarding and full-stack acceptance matrix
seq: 339
status: todo
priority: p2
labels:
    - openai-integration
created: 2026-11-15T13:18:38.230974Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

Planning/design only; no implementation, deployment, provisioning, live account checks or agent launches. Keep sprint in backlog without appointing a manager. Research/spec: story f0cabeb9c6e3.

Design acceptance scenarios, do not execute live tests. Cover ChatGPT web/desktop/mobile, dots, Codex CLI/IDE/app/cloud, Responses API, Agents API and SDK with explicit supported/unsupported/unverified verdicts, versions, account gates and connection origin. On a clean supported remote client machine without the stack installed, sign in, discover only authorized Cloudbox/Satellite/Outpost/Bashy capabilities, select stable targets, perform bounded operations and retrieve the same durable task from another client. Include cross-account denial, scope restriction, credential revocation, ambiguous/multiple attachments, offline hosts, retries, cancellation and evidence provenance. Walk wish -> candidate -> verify -> preview -> approve -> activate -> undo from interactive and headless callers. Acceptance: reproducible onboarding/config templates without secrets, client x component coverage, expected outcomes and pilot implementation handoff; explicitly separate documentation/source checks from future live proof.
