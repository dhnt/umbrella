---
id: 834feb47a654
kind: feature
title: O1 Conductor directives run/delegate/approve/cancel with idempotency and result write-back; conductor as a host service
seq: 359
status: todo
priority: p1
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:43.046828Z
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
---

Spec: docs/vendor-chat-gateway-mvp.md (decision 2, pull route).

Reuse: yoke/pkg/weave SessionClient and weave conduct consumeDirectives/applyDirective (today: say/add/prio/kill).

Scope:
- Add directive verbs run, delegate, approve and cancel.
- Map each idempotency key to one task id, so a sync->pull fallback never runs the work twice.
- Write back events for state (queued/running/needs-approval/done/failed/cancelled), the result, and asserted vs verified success.
- Install bashy weave conduct as a host service unit, matching on Windows, macOS and Linux.

Done when: unit tests cover duplicate directives, cancel races and result events.

## Worker rules (Sprint 646 manager, 2026-11-15)
- Read docs/vendor-chat-gateway-mvp.md in the umbrella repository, including the Task wire contract section, before writing code.
- Work only in your weave workspace.
- Run unit tests on touched packages only (GOWORK=off go test ./<pkg>/...); the full suites are deferred to QA.
- Commit trailers: Sprint: #646, Story/Story-ID for this story, Agent: <your agent name>.
- Never read, print or commit a credential value. Never fall back to an API key for a subscription worker.
- Submit with `bashy sprint submit 646 <story> -m "<evidence: commits, tests run>"`.
