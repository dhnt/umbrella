---
id: d007d138f153
kind: feature
title: 'O2 Vendor-neutral worker adapter: auth.check_exec/config_dir_env, vault subscription credential projection, worker-state JSON'
seq: 360
status: todo
priority: p1
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:43.197274Z
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
---

Spec: docs/vendor-chat-gateway-mvp.md (decisions 4-5).

Finish the Sprint 584 adapter contract (yoke/docs/agent-cli-adapters.md):
- Add the auth.check_exec and config_dir_env YAML fields.
- Move the hard-coded checks out of yoke/pkg/chat/delegate_guard.go into the claude, codex, agy and muse files under yoke/pkg/fleet/baseline/tools.

Credentials, using each vendor's documented headless method only and never an API-key fallback:
- claude: CLAUDE_CODE_OAUTH_TOKEN from the vault through secrets.ResolveAgentKey/PreserveEnvNames, with a per-worker CLAUDE_CONFIG_DIR.
- codex: ChatGPT device-code login cached in the worker's config dir.
- agy: one interactive sign-in, then persisted.
- muse: subscription credential, with Contributor mode pinned off.

Add `bashy agents workers --json` reporting ok/missing/expired/plan-limit/offline, and a daily probe that sends Sprint 620 alerts.

Policy: see kb outpost-workers-on-vendor-subscriptions-official-cli-documented.

Done when: unit tests cover each vendor's YAML and the state classification. No live sign-in.

## Worker rules (Sprint 646 manager, 2026-11-15)
- Read docs/vendor-chat-gateway-mvp.md in the umbrella repository, including the Task wire contract section, before writing code.
- Work only in your weave workspace.
- Run unit tests on touched packages only (GOWORK=off go test ./<pkg>/...); the full suites are deferred to QA.
- Commit trailers: Sprint: #646, Story/Story-ID for this story, Agent: <your agent name>.
- Never read, print or commit a credential value. Never fall back to an API key for a subscription worker.
- Submit with `bashy sprint submit 646 <story> -m "<evidence: commits, tests run>"`.
