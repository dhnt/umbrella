---
id: f0cabeb9c6e3
kind: spike
title: P1 Research OpenAI client compatibility and recommend a full-stack remote-access pilot
seq: 324
status: todo
priority: p1
labels:
    - software-shaping
    - dots-integration
    - openai-integration
created: 2026-11-15T07:29:24.506109Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'OpenAI clients to the full Cloudbox stack: access from any supported machine through one shared remote gateway'
---

## Request and boundary
Operator-approved rescope following research on 2026-11-15: any supported OpenAI client or Codex, from any supported machine, should reach the full Cloudbox / Satellite / Outpost / Bashy stack through one shared remote gateway. "Any machine" means no dependency on the originating workstation, subject to client availability, authorization and network reachability. It does not promise support for an arbitrary OpenAI-compatible client without a tool transport.

Planning only: no coding, deployment, provisioning, live account checks or agent launches. Keep in backlog without appointing a manager. This update records research and remaining design work; it does not establish working integration or close the story.

## Research findings (source/document inspection, not live verification)
- ChatGPT web uses remote MCP through plugins. Local Codex clients support Streamable HTTP with OAuth or bearer authentication. Existing Bashy Codex installation config launches local stdio via bashy mcp serve; it is not remote onboarding.
- dots runs in the cloud and supports desktop browser, desktop app and mobile app; mobile web is explicitly unsupported.
- Responses API exposes remote MCP via server_url and caller-supplied authorization; the authorization value must be supplied again on each request. Agents API and Agents SDK also expose MCP connections. Validate each surface independently.
- OpenAI plugin OAuth requires protected-resource metadata, authorization-server discovery, resource binding and PKCE S256. Existing Cloudbox scoped bearer contracts do not establish OAuth interoperability.
- MCP Events is documented for Work web, desktop Work with Cloud selected, and dots. Do not infer universal Codex/mobile/API event support. Durable status/result retrieval must work without push.
- yoke/mcp/transport.go refuses non-loopback HTTP binding. Preserve that boundary.
- outpost/docs/mcp.md documents local administration tools with a separate bearer and a non-loopback override; that override alone is not an account-scoped remote gateway.
- yoke/pkg/fleet/satellite_read.go implements satellite list/show; outpost/internal/agent/mcpapi/tools_satellite.go exposes attachment tools. The Outpost MCP guide describes one attachment, while current tool text describes multiple attachments. Reconcile against authoritative implementation before designing routing.
- yoke/docs/cloudbox-members-attach-wire.md is explicitly a draft backed by cloudboxfake fixtures. Separate public contracts/client code from deployed service evidence. Private Cloudbox implementation was not inspected.

## Shared architecture and dependencies
Reuse the vendor-neutral gateway proposed in Sprint 643 (UUID b3afcef3-bce0-5e7f-bbe0-400e1c629958), not a second OpenAI-specific backend. Gateway authenticates the Cloudbox principal, checks grants and routes through established stack connections and Bashy operations. Satellite is a discoverable management target and routing component where applicable; do not assume every operation traverses a Satellite.
S643 auth story 31424ce68e52 and routing story 598058346ae0 own the shared design baseline. S642 records OpenAI-specific requirements and reconciles them against that baseline. Reuse S643 UI/text design db637f3c8ca5 and no-push recovery design 71e63b97abfb; relate notifications to S620 rather than duplicating communications.
Retain direct, steward-mediated and hybrid comparison. Prefer direct bounded deterministic operations, with optional explicit delegation for sustained work; one execution owner per task, explicit ownership transfer. A reasoning agent is not required merely to execute deterministic operations.

## This story: compatibility and pilot synthesis
Produce a sourced matrix covering ChatGPT web/desktop/mobile, dots, Codex CLI/IDE/app/cloud, Responses API, Agents API and Agents SDK. For each: client/version, plan/workspace restrictions, connection origin, remote transport, auth, tool/UI/events support, setup, cost implications, evidence level and unsupported/unverified cases. Do not extrapolate local CLI support to hosted Codex.
Compare direct/delegated/hybrid UX, reliability and operational cost. Recommend a pilot spanning an interactive client, remote Codex and a headless API caller, with dependencies and unresolved decisions.
Other S642 stories cover auth, capability routing, task semantics, presentation/events and acceptance/onboarding.

## Acceptance
A source-backed compatibility matrix and pilot recommendation; known limitations explicit; shared S643 dependencies identified; full-stack access is the objective and software shaping is one end-to-end acceptance journey, not the only capability.

## Sources inspected 2026-11-15
- https://learn.chatgpt.com/docs/extend/mcp?surface=cli
- https://learn.chatgpt.com/docs/dots
- https://developers.openai.com/plugins/build/auth
- https://developers.openai.com/plugins/build/mcp-events
- https://developers.openai.com/api/docs/guides/tools-connectors-mcp
- https://developers.openai.com/api/docs/guides/agents-api/tools/mcp
- https://openai.github.io/openai-agents-python/mcp/
- Local sources: yoke/mcp/transport.go; yoke/mcp/direct.go; yoke/docs/cloudbox-members-attach-wire.md; yoke/pkg/fleet/satellite_read.go; outpost/docs/mcp.md; outpost/internal/agent/mcpapi/tools_satellite.go; bashy/internal/agentos/installagent_mcp_test.go.
Revalidate changing product claims during design. Keep private service internals, credentials and raw restricted evidence outside this public repository.
