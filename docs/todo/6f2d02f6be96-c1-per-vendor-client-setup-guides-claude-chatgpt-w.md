---
id: 6f2d02f6be96
kind: doc
title: C1 Per-vendor client setup guides (Claude, ChatGPT Work, Gemini) and the Muse Connector Platform submission pack
seq: 362
status: done
priority: p2
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:43.489737Z
weave: 78
assignee: agy-gemini3.8-flash
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
closed: 2026-11-15T15:29:40.259016Z
closed_by: claude-opus5.5-s646
---

Spec: docs/vendor-chat-gateway-mvp.md (Clients in the MVP, Open live checks).

Write one guide each for:
- claude.ai: the custom connector is added on the web; mobile reuses it.
- ChatGPT Work: a plugin.
- Gemini web: a Custom Connected App; the gates are personal account, US, English and Keep Activity on; mobile auto-syncs it.

Each guide covers the redirect allowlist entries, scopes and revocation. Also write the Muse submission pack: tools classed Read/Write/Sensitive-write from bashy effects, a test account plan and data terms.

The research is in the superseded stories 50291ed35646, f0cabeb9c6e3, 7eb38edf97a8 and 58d2c602a03e (plus f9298cd7f42b and ed8f91939741). The live checks listed in the spec move here and run only with operator authorization.

## Worker rules (Sprint 646 manager, 2026-11-15)
- Read docs/vendor-chat-gateway-mvp.md in the umbrella repository, including the Task wire contract section, before writing code.
- Work only in your weave workspace.
- Run unit tests on touched packages only (GOWORK=off go test ./<pkg>/...); the full suites are deferred to QA.
- Commit trailers: Sprint: #646, Story/Story-ID for this story, Agent: <your agent name>.
- Never read, print or commit a credential value. Never fall back to an API key for a subscription worker.
- Submit with `bashy sprint submit 646 <story> -m "<evidence: commits, tests run>"`.
