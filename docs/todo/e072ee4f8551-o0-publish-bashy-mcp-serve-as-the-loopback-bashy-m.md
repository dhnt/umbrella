---
id: e072ee4f8551
kind: feature
title: O0 Publish bashy mcp serve as the loopback bashy-mcp outpost app for the gateway sync route
seq: 358
status: todo
priority: p1
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:42.894484Z
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
---

Spec: docs/vendor-chat-gateway-mvp.md (Sprint 646, decision 2).

Scope: publish `bashy mcp serve --transport http` as a loopback outpost app named bashy-mcp, reachable only through the outpost tunnel. It trusts the hub-forwarded caller identity only together with a per-host app secret, and keeps the yoke/mcp effect policy and audit unchanged. The non-loopback refusal in yoke/mcp/transport.go stays.

Done when: the app registers on the outpost; it refuses a request without the app secret; tools/list matches `bashy mcp tools --json`; a destroy/spend/cred/priv tool is refused unless approved. Unit tests only, in bashy, outpost and yoke.

## Worker rules (Sprint 646 manager, 2026-11-15)
- Read docs/vendor-chat-gateway-mvp.md in the umbrella repository, including the Task wire contract section, before writing code.
- Work only in your weave workspace.
- Run unit tests on touched packages only (GOWORK=off go test ./<pkg>/...); the full suites are deferred to QA.
- Commit trailers: Sprint: #646, Story/Story-ID for this story, Agent: <your agent name>.
- Never read, print or commit a credential value. Never fall back to an API key for a subscription worker.
- Submit with `bashy sprint submit 646 <story> -m "<evidence: commits, tests run>"`.
