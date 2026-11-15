---
id: 3bdfa5496ff8
kind: spike
title: P1 Design subscription-backed Codex as the agentic tools on Outposts
seq: 356
status: todo
priority: p1
labels:
    - openai-integration
created: 2026-11-15T13:47:49.887811Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

## Required outcome B
Use Codex with the subscription service as the agentic tools on Outposts. This is co-primary with OpenAI online web/mobile as the full-stack UI (outcome A), not an optional executor variant. Research/design only; no implementation, provisioning, live account checks, agent launches or sprint start.

## Design work
Inventory existing Bashy fleet launch/steering/JSON event support, Codex managed installation and MCP setup, and Outpost dispatch/attachment capabilities. Start with yoke/pkg/fleet/baseline/tools/codex.yaml and bashy/internal/agentos/installagent_mcp_test.go; distinguish source support from deployed behavior.
Define authorized onboarding per Outpost OS: installation/version pin, subscription account/workspace/seat, headless login, credential isolation/storage, refresh/revocation, and readiness checks. Qualify supported unattended use and concurrency for the chosen plan without assuming account sharing or unlimited capacity.
Specify task dispatch, workspace and target selection, Bashy tools/skills, permission profile and approval delivery to the web/mobile UI. Compare Codex exec/structured events and persistent-session adapters using documented capabilities. Define progress/artifact/evidence reporting, cancel/resume, process restart, Outpost outage, duplicate dispatch and one execution owner.
Report subscription quota/rate limits and authentication blockers. No automatic switch to API billing or another subscription identity. Gateway user authorization and worker subscription identity stay separately attributable.

## Source baseline inspected 2026-11-15
https://learn.chatgpt.com/docs/auth distinguishes ChatGPT subscription login from API-key billing. It documents device-code login for headless CLI (beta), cached credentials with refresh during use, and Enterprise access tokens for trusted noninteractive local workflows where permitted. These establish options to qualify, not proof that the intended account or Outpost is ready.

## Acceptance
A source-backed Outpost OS/client-version/plan/auth matrix; existing-capability/gap inventory; launch/session/tool/approval/result contracts; subscription limits and recovery behavior; onboarding and reproducible future qualification scenarios. End-to-end design must show an OpenAI web/mobile request reaching subscription-backed Codex on an authorized Outpost, using Bashy and returning verified evidence through the shared gateway. UI workstation can be offline while the selected Outpost continues. Keep all live feasibility claims unverified until tested.
