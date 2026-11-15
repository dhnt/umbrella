---
id: 85f4544b48fc
kind: feature
title: P2 Design cross-client durable tasks, Scheduled Actions, S620 alerts and no-push recovery for Google clients
seq: 344
status: todo
priority: p2
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:37:05.603884Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
---

## Scope
Design durable cross-client execution, no-push recovery and notification integration for Google clients, reusing Sprint 643 `71e63b97abfb` and Sprint 620 (`docs/comms-strategy.md`); design only.

## Requirements to design
- Single-owner task model (steward / conductor / explicitly delegated agent) with idempotency keys and `task_id` recovery across Google and non-Google clients (e.g., start wish on Gemini iOS/Android, check/approve from `agy` CLI or Gemini CLI).
- Out-of-band completion, blocker and approval alerts via Sprint 620 channels (`docs/comms-strategy.md`, webhook ingress C8 `cd9d0870e0a2`).
- Evaluate `gemini.google.com` **Scheduled Actions** (daily/weekly/monthly recurring prompts invoking `@cloudbox`) as a native consumer/workspace recurring trigger, with idempotency and rate/cost guardrails.

## Done when
Cross-client recovery, Scheduled Actions usage and S620 notification paths are documented. No implementation.
