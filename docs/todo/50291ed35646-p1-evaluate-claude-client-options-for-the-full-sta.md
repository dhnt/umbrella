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

## Goal (operator, 2026-11-15)
Two pieces on one Cloudbox identity:
- (a) **UI**: the claude.ai web chat and mobile apps are the user interface for the full cloudbox/bashy stack — one custom connector to the Cloudbox gateway, MCP Apps cards inline, no web UI of ours required in the loop.
- (b) **Executor**: Claude (the owner's Claude subscription) is the agentic tool on the outpost — the outpost supervises a Claude Code worker authenticated by `claude setup-token` that does the delegated work with bashy verbs on the host.
The broad client matrix stays as context; the pilot and the story designs optimize for (a)+(b). Headless API/SDK rows become secondary consumers, not the execution engine.

## Claude equivalent of OpenAI dots
Claude Duet (research preview since 2026-10-21; US Pro/Max/Ultra waitlist; iOS/Android): always-on cloud agent on its own VM and browser, memory, account connectors, approval before sending, paying, signing or deleting. It is a possible later front end on top of this gateway, not the target.

## Current state (source review, not live evidence)
- Every stack MCP surface is loopback-only: outpost streamable HTTP with a static bearer (outpost/docs/mcp.md); `bashy mcp serve` refuses a non-loopback bind without an authorization issuer, resource URI and audience (yoke/mcp/transport.go; tools and effect policy in yoke/mcp/direct.go).
- Cloudbox issues scoped bearer tokens (public draft contract yoke/docs/cloudbox-members-attach-wire.md) and is an OAuth client only; it runs no OAuth authorization server and no remote MCP endpoint.
- Result: no Claude client off-host reaches the stack unless bashy is installed locally.

## Client support matrix (docs revalidated 2026-11-15; rows marked verify need a live check)
| Claude client | Remote MCP | Auth | MCP Apps UI |
|---|---|---|---|
| claude.ai web | custom connector, add + use; all plans incl. Free (Free = 1 custom connector; Team adds are Owner-only, Enterprise needs the libraries permission) | OAuth 2.1 + PKCE, callback claude.ai/api/mcp/auth_callback | yes; side panel + full-site views rolling out with the new Claude experience |
| desktop app / Cowork | custom connector, add + use | same OAuth | yes |
| mobile apps (iOS/Android) | use connectors added on web/desktop/Cowork; adding on mobile is beta — point setup guides at the web | same OAuth | yes, inline, all plans since 2026-01-26 launch; no side panel or full-site views on mobile yet |
| Claude Duet | reuses connectors already connected in the Claude account (official doc names directory apps only; custom connector reuse: verify live); mobile-only, US research preview, Pro/Max/Ultra, no Team/Enterprise | same OAuth | n/a |
| Claude in Chrome / Slack / Office add-ins | account connectors: verify per surface | same OAuth | varies |
| Claude Code CLI, any machine | `claude mcp add --transport http` | OAuth or bearer header | n/a |
| Claude Code on the web / scheduled tasks / self-hosted runners | connectors or repo .mcp.json | OAuth or env-secret bearer | n/a |
| Agent SDK | HTTP MCP config | bearer | n/a |
| Messages API MCP connector | mcp_servers | authorization_token (bearer) | n/a |
| Managed Agents API | remote HTTP MCP only | vault credentials | n/a |
Connector calls originate from Anthropic's cloud, so the endpoint must be public HTTPS. No Claude client supports MCP Events yet (anthropics/claude-code#101434; ChatGPT has since 2026-09-29; rechecked 2026-11-15, spec still draft).

Verified 2026-11-15 (web+mobile research pass):
- Custom-connector MCP Apps need no directory listing: any MCP server may serve a `ui://` resource (mime `text/html;profile=mcp-app`) that Claude renders in a sandboxed iframe on web, desktop, mobile and Cowork; directory submission adds design/security/testing review but a private custom connector renders without it. Feeds story db637f3c.
- OAuth client registration options per the official custom-connector guide: Claude's published identity (recommended), dynamic client registration, or your own OAuth client with the allow-listed claude.ai callback. Feeds story 31424ce6.
- New since filing: Claude Code channels (research preview) — a local stdio MCP server pushes events into an interactive Claude Code session (`notifications/claude/channel`), optionally two-way with a reply tool, sender allowlist gating, and permission-prompt relay to a remote approver. Custom channels sit behind an allowlist/dev flag (org `allowedChannelPlugins` on Team/Enterprise) and are ignored in `-p`/Agent SDK headless mode. This is a push path into Claude Code on a user's machine, not into claude.ai web or mobile. Feeds story 71e63b97.

## Recommended architecture to evaluate
One Cloudbox-hub-hosted remote MCP gateway: one sign-in reaches every host of the user; the hub routes tool calls to satellites and outposts over the existing hub-outpost link where bashy verbs do the work; host-side MCP stays loopback. Two auth modes on one identity (the Cloudbox account): OAuth 2.1 for interactive clients, scoped Cloudbox bearer tokens for headless clients. Agent-mediated tool set; MCP Apps where rendered, text elsewhere; Claude skill package; shared with Sprint 642.

Pilot shape per the goal: claude.ai web/mobile custom connector → Cloudbox gateway → hub-outpost link → outpost-supervised Claude Code worker (subscription) → bashy verbs on the host.

## Outpost executor on the Claude subscription (verified 2026-11-15, code.claude.com/docs/en/authentication)
- `claude setup-token` mints a one-year OAuth token (browser flow once, on any machine), set as `CLAUDE_CODE_OAUTH_TOKEN` on the outpost; documented for "CI pipelines, scripts, or other environments where interactive browser login isn't available". Requires Pro/Max/Ultra/Team/Enterprise; usage draws on the plan's limits, no per-token API billing.
- Token scope: model requests only — no Remote Control, no claude.ai connectors, no `/schedule` routines from the worker; locally configured MCP servers still work. Bare mode (`--bare`) does not read the token.
- Policy boundary: Anthropic's Authentication and Credential Use policy (2026-02) restricts subscription OAuth tokens to official Anthropic clients. Claude Code CLI on the outpost is compliant; subscription auth through the Agent SDK was explicitly disallowed and the restriction's wording changed 2026-10-26 — treat SDK-on-subscription as verify-before-use and design the worker around the CLI.
- Operational design inputs: credential lives in the vault and lands on the host as env (Linux fallback store is `~/.claude/.credentials.json` 0600); `CLAUDE_CONFIG_DIR` isolates the worker's account/config from any interactive login on the same host; expiring/expired credential halts unattended work, so the outpost needs a credential-expiry probe wired to Sprint 620 alerts; renewal is re-running setup-token (operator action), about once a year.

## Alternatives to record
- Satellite-hosted gateway: owner-run variant of the same contract.
- Per-outpost endpoints: rejected (many endpoints and sign-ins, relay traffic).
- Bashy skill in the claude.ai code-execution sandbox with a pasted scoped token: zero-server-code throwaway pilot; token enters the sandbox, egress allow-list issues reported.
- Claude Code self-hosted runner or Remote Control on an outpost: real-host path; runners are Team/Enterprise beta.
- Claude in Chrome driving web consoles: rejected by the agentic-way rule (bashy verbs only).
- Managed Agents doing the work instead of the outpost worker: optional, per-token API cost; the outpost-supervised subscription worker is the default per the goal.

## Deliverables
Verified matrix with sources; cost, plan gate and exposure per option; shaping lifecycle (wish -> candidate -> verify -> preview -> approve -> activate -> undo) from one interactive and one headless client; pilot recommendation with dependencies and open decisions. Relate to Sprint 642 and Sprint 620 (docs/comms-strategy.md) rather than duplicating them.

## Sources
- https://claude.com/resources/articles/claude-duet
- https://support.claude.com/en/articles/17631495-get-started-with-claude-duet
- https://claude.com/resources/articles/claude-duet-safety-privacy-and-security
- https://claude.com/docs/connectors/custom/remote-mcp
- https://support.claude.com/en/articles/11175166-getting-started-with-custom-connectors-using-remote-mcp
- https://support.claude.com/en/articles/13454812-use-interactive-connectors-in-claude
- https://claude.com/resources/articles/interactive-tools-in-claude
- https://claude.com/docs/connectors/building/mcp-apps/design-guidelines
- https://code.claude.com/docs/en/channels-reference
- https://code.claude.com/docs/en/authentication (setup-token, credential precedence/storage)
- https://code.claude.com/docs/en/routines
- https://code.claude.com/docs/en/self-hosted-environments
- https://code.claude.com/docs/en/remote-control
- https://platform.claude.com/docs/en/managed-agents/webhooks
- https://github.com/anthropics/claude-code/issues/101434
- OpenAI comparison: https://learn.chatgpt.com/docs/dots, https://developers.openai.com/plugins/build/mcp-events, https://developers.openai.com/plugins/build/auth

## Completion boundary
Completes when the comparison and pilot recommendation are documented with evidence and remaining decisions. Implementation and live or paid account checks need separate operator authorization. Keep private Cloudbox implementation details out of this public repository.
