---
id: 50291ed35646
kind: spike
title: P1 Evaluate Claude client options for the full stack and recommend a gateway pilot
seq: 328
status: todo
priority: p1
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:32.37057Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Request and scope
Any Claude client — claude.ai web, desktop and mobile apps, Cowork, Claude Code on any machine, Claude Code on the web and scheduled tasks, the Agent SDK, the Messages API MCP connector and Managed Agents — must be able to call out to Cloudbox, satellites, outposts and Bashy from any remote machine. Sibling of Sprint 642 (ChatGPT/dots); the gateway designed here serves both vendors. Planning only: no coding, deployment, provisioning, live account checks or agent launches.

## Claude equivalent of OpenAI dots
Claude Duet (research preview since 2026-10-21; US Pro/Max/Ultra waitlist; iOS/Android): always-on cloud agent on its own VM and browser, memory, account connectors, approval before sending, paying, signing or deleting. It is a possible later front end on top of this gateway, not the target.

## Current state (source review, not live evidence)
- Every stack MCP surface is loopback-only: outpost streamable HTTP with a static bearer (outpost/docs/mcp.md); `bashy mcp serve` refuses a non-loopback bind without an authorization issuer, resource URI and audience (yoke/mcp/transport.go; tools and effect policy in yoke/mcp/direct.go).
- Cloudbox issues scoped bearer tokens (public draft contract yoke/docs/cloudbox-members-attach-wire.md) and is an OAuth client only; it runs no OAuth authorization server and no remote MCP endpoint.
- Result: no Claude client off-host reaches the stack unless bashy is installed locally.

## Client support matrix (docs revalidated 2026-11-14; rows marked verify need a live check)
| Claude client | Remote MCP | Auth | MCP Apps UI |
|---|---|---|---|
| claude.ai web | custom connector | OAuth 2.1 + PKCE, callback claude.ai/api/mcp/auth_callback; Free = 1 connector | yes |
| desktop / mobile apps | account connectors | same OAuth | yes (mobile since 2026-03) |
| Cowork | custom connectors | same OAuth | yes |
| Claude Duet | account connectors; custom: verify | same OAuth | n/a |
| Claude in Chrome / Slack / Office add-ins | account connectors: verify per surface | same OAuth | varies |
| Claude Code CLI, any machine | `claude mcp add --transport http` | OAuth or bearer header | n/a |
| Claude Code on the web / scheduled tasks / self-hosted runners | connectors or repo .mcp.json | OAuth or env-secret bearer | n/a |
| Agent SDK | HTTP MCP config | bearer | n/a |
| Messages API MCP connector | mcp_servers | authorization_token (bearer) | n/a |
| Managed Agents API | remote HTTP MCP only | vault credentials | n/a |
Connector calls originate from Anthropic's cloud, so the endpoint must be public HTTPS. No Claude client supports MCP Events yet (anthropics/claude-code#101434; ChatGPT has since 2026-09-29).

## Recommended architecture to evaluate
One Cloudbox-hub-hosted remote MCP gateway: one sign-in reaches every host of the user; the hub routes tool calls to satellites and outposts over the existing hub-outpost link where bashy verbs do the work; host-side MCP stays loopback. Two auth modes on one identity (the Cloudbox account): OAuth 2.1 for interactive clients, scoped Cloudbox bearer tokens for headless clients. Agent-mediated tool set; MCP Apps where rendered, text elsewhere; Claude skill package; shared with Sprint 642.

## Alternatives to record
- Satellite-hosted gateway: owner-run variant of the same contract.
- Per-outpost endpoints: rejected (many endpoints and sign-ins, relay traffic).
- Bashy skill in the claude.ai code-execution sandbox with a pasted scoped token: zero-server-code throwaway pilot; token enters the sandbox, egress allow-list issues reported.
- Claude Code self-hosted runner or Remote Control on an outpost: real-host path; runners are Team/Enterprise beta.
- Claude in Chrome driving web consoles: rejected by the agentic-way rule (bashy verbs only).
- Managed Agents doing the work instead of the steward: optional, per-token cost; steward is the default.

## Deliverables
Verified matrix with sources; cost, plan gate and exposure per option; shaping lifecycle (wish -> candidate -> verify -> preview -> approve -> activate -> undo) from one interactive and one headless client; pilot recommendation with dependencies and open decisions. Relate to Sprint 642 and Sprint 620 (docs/comms-strategy.md) rather than duplicating them.

## Sources
- https://claude.com/resources/articles/claude-duet
- https://support.claude.com/en/articles/17631495-get-started-with-claude-duet
- https://claude.com/resources/articles/claude-duet-safety-privacy-and-security
- https://claude.com/docs/connectors/custom/remote-mcp
- https://claude.com/blog/interactive-tools-in-claude
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/self-hosted-environments
- https://code.claude.com/docs/en/remote-control
- https://platform.claude.com/docs/en/managed-agents/webhooks
- https://github.com/anthropics/claude-code/issues/101434
- OpenAI comparison: https://learn.chatgpt.com/docs/dots, https://developers.openai.com/plugins/build/mcp-events, https://developers.openai.com/plugins/build/auth

## Completion boundary
Completes when the comparison and pilot recommendation are documented with evidence and remaining decisions. Implementation and live or paid account checks need separate operator authorization. Keep private Cloudbox implementation details out of this public repository.
