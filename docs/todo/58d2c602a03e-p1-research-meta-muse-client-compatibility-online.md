---
id: 58d2c602a03e
kind: spike
title: P1 Research Meta Muse client compatibility (online chatboxes and mobile clients) and recommend pilots for the UI and outpost-agent goals
seq: 347
status: wontfix
priority: p1
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:44:52.759914Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.322435Z
---

## Request and scope
Meta/Facebook-vendor sibling of Sprint 642 (OpenAI, 7b4a9392-be5f-5398-a236-fba1d0868fae) and Sprint 643 (Claude, b3afcef3-bce0-5e7f-bbe0-400e1c629958). Operator goals, Meta vendor only:
- Goal A (user interface): Meta Muse clients drive the full Cloudbox / Satellite / Outpost / Bashy stack.
- Goal B (outpost agent): the same Muse Code CLI / subscription service is the resident agentic tool on outposts.
Planning only: no coding, deployment, provisioning, live account checks or agent launches. Backlog, no manager. Keep private Cloudbox implementation details out of this public repository; public wire contracts only.

## Meta client inventory (primary sources inspected 2026-11-15; source review, not live evidence)
| Surface | Form | Reaches the stack via | Auth |
|---|---|---|---|
| Muse personal agent: muse.ai web chatbox | online chatbox; per-user Muse Secure VM (dedicated Linux computer + browser); works after app closes; returns for approval before sensitive actions | Muse Connector Platform directory connector (reviewed); no user-configured arbitrary MCP documented | Muse account; connector OAuth or API key per submission |
| Muse personal agent: iOS / Android apps | mobile clients (US rollout; AI glasses announced as coming) | same directory connector | same |
| Muse personal agent in WhatsApp | messaging chatbox | same connector, zero channel code | same |
| Meta AI assistant: meta.ai + Meta AI app (iOS/Android) + AI glasses | online/mobile chatbox, powered by Muse Spark | Meta AI Connectors developer preview (admission in waves): guided UI or MCP onboarding, turns an existing API into tools | OAuth account linking |
| Muse Code CLI (macOS/Linux/Windows) | terminal + CI; no mobile app in Meta docs | mcp_servers: stdio or streamable_http; muse serve session protocol + TypeScript SDK for embedding | OAuth 2.1 (muse mcp login) or headers; model auth via browser sign-in or API key |
| Meta Model API (headless) | inference API, OpenAI SDK compatible | build our own agent/app; server-side tooling | API key |
| WhatsApp Business Platform Cloud API | stack-owned messaging channel (option, not Meta AI) | Cloud API + webhooks fronting the gateway/steward | Meta app + business assets |

## Non-obvious findings that shape the design
1. Two different connector programs, do not conflate: Muse Connector Platform (Muse agent surfaces; describe -> submit for functional/security/legal review -> directory) vs Meta AI Connectors preview (Meta AI app/web/glasses; live REST API required; selected in waves).
2. Muse connector guidelines: tools classified Read / Write / Sensitive-write; sensitive writes require approval on EVERY use (no Always allow); offer a Read Only OAuth option where possible; complete the task inside the connector; no blind retries (check status first, prevent duplicates); a dedicated test account is mandatory; submission accepts API or MCP documentation, endpoint and credentials.
3. Muse Code MCP tools are NOT sandboxed (Meta docs warning); approval still applies, containment does not. Read-only declared tools can run without a prompt under on-request approvals; run.toolset selects tools by name/pattern.
4. Goal B auth: a Muse Code subscription (flat monthly, 4 tiers, Meta Account) applies to the API key automatically connected during CLI onboarding; that credential is for Muse Code only. Any additional API keys are pay-as-you-go. CI/headless uses META_API_KEY from a secret store. Meta Managed Account users must use an API key (no browser sign-in).
5. Contributor mode is ON by default on subscriptions (content may train future models), is saved per computer, and headless behavior depends on settings-file state. Outpost design must pin it OFF explicitly on every run (--contributor-mode off or environment) and verify per host role.
6. Stack state (re-verified in workspace): every stack MCP surface is loopback-only (outpost/docs/mcp.md; yoke/mcp/transport.go refuses a non-loopback bind without authorization issuer, resource URI and audience). The public Cloudbox wire is scoped Bearer tokens with an executable fake (yoke/docs/cloudbox-members-attach-wire.md, yoke/pkg/fleet/cloudboxfake). Satellite host-mapping and per-satellite detail gaps stand (docs/satellite-operations-workflow.md). Cloudbox runs no OAuth authorization server and no remote MCP endpoint today (per S643 spec story 50291ed35646).

## Recommended architecture to evaluate (shared with S642/S643)
One Cloudbox-hub-hosted remote MCP gateway, vendor-neutral: one Cloudbox identity, OAuth 2.1 for interactive clients and scoped Bearer for headless; the hub routes to satellites and outposts over existing links where bashy verbs do the work; host-side MCP stays loopback. Meta-specific work is adapters/registrations only: (A) Muse directory connector + Meta AI Connectors application backed by the gateway; Muse Code remote-MCP profile per machine. (B) Muse Code installed per outpost, launched through the existing agentlaunch binding (yoke/pkg/agentlaunch), working locally through bashy and loopback outpost MCP. Direct, steward-mediated and hybrid execution compared; one execution owner per task.

## Alternatives to record
- Per-outpost public endpoints: rejected (many endpoints/sign-ins, relay traffic) as in S643.
- Satellite-hosted gateway: owner-run variant of the same contract.
- Stack-owned WhatsApp Business number instead of Muse-in-WhatsApp: Meta-independent mobile UI, extra channel/policy cost; decision in the WhatsApp story.
- muse serve / TypeScript SDK thin mobile client: fallback if both connector programs stall.
- Browser-driving web consoles: rejected by the agentic-way rule (bashy verbs only).

## Deliverables
Verified matrix with sources and evidence levels; pilot recommendation in gating order (1: Muse Code local + remote profile, no Meta review; 2: outpost Muse Code onboarding design; 3: connector submissions, Meta-timed); shaping lifecycle (wish -> candidate -> verify -> preview -> approve -> activate -> undo) from one mobile client and one headless client; open decisions. Close gaps: live revalidation of meta.ai (fetch returned 403 at research time), Messenger/Instagram messaging primary docs (not verified; do not assume Meta AI Connectors reach them).

## Sources (inspected 2026-11-15)
- https://about.fb.com/news/2026/09/introducing-muse-personal-ai-agent/
- https://muse.ai/
- https://platform.muse.ai/
- https://platform.muse.ai/docs
- https://ai.meta.com/blog/introducing-muse-spark-msl/
- https://dev.meta.ai/products/connectors
- https://dev.meta.ai/docs/overview.md
- https://dev.meta.ai/resources/blog/build-with-muse-spark
- https://dev.meta.ai/docs/muse-code.md
- https://dev.meta.ai/docs/muse-code/configuration.md
- https://dev.meta.ai/docs/muse-code/extending.md
- https://dev.meta.ai/docs/muse-code/auth.md
- https://dev.meta.ai/docs/muse-code/subscriptions.md
- https://developers.facebook.com/documentation/business-messaging/whatsapp/about-the-platform
- Local: docs/todo/50291ed35646-p1-evaluate-claude-client-options-for-the-full-sta.md; docs/todo/f0cabeb9c6e3-p1-research-openai-client-compatibility-and-recomm.md; outpost/docs/mcp.md; yoke/mcp/transport.go; yoke/docs/cloudbox-members-attach-wire.md; docs/satellite-operations-workflow.md

## Completion boundary
Completes when the comparison and pilot recommendation are documented with evidence and remaining decisions. Implementation and live or paid account checks need separate operator authorization.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
