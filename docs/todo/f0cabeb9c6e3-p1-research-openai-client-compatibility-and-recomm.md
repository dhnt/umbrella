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
Operator clarification (2026-11-15): two required outcomes:
A. Use OpenAI online web UI/chatbox and mobile clients as the user interface for the full Cloudbox / Satellite / Outpost / Bashy stack.
B. Use Codex with the subscription service as the agentic tools running on Outposts.

The intended route is OpenAI web/mobile UI -> shared S643 gateway -> authorized stack operation or durable task -> selected Outpost -> subscription-authenticated Codex -> Bashy/local tools -> results and approvals returned to the UI. Deterministic operations can execute directly; agentic work runs on the selected Outpost. The UI and execution agent are distinct roles even when both use OpenAI products.

Independence means the user's originating workstation need not stay online. The selected Outpost is an intentional execution dependency. Codex Cloud execution and an API-key worker are optional comparisons, not substitutes for outcome B. API/headless interoperability is secondary and must not become a prerequisite for the subscription-backed pilot. Do not promise arbitrary OpenAI-compatible clients without a supported tool transport.

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
Compare direct/delegated/hybrid UX, reliability and operational cost. Recommend a pilot joining OpenAI web/mobile UI to subscription-backed Codex on an Outpost, with dependencies and unresolved decisions. Keep API/headless and Codex Cloud execution as optional comparisons.
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

## Review update: online web UI/chatbox and mobile (2026-11-15)
Interpret the requested "oneline" as online/web access. Use official product names and separate presentation surface, execution location and gateway connection origin. Documentation below is source evidence only; no account or device was tested.

### Focused compatibility matrix
| Surface | Documented experience and execution | Gateway conclusion / remaining evidence |
| --- | --- | --- |
| ChatGPT web chatbox | Chat and Work are separate choices; Work supports projects, files and plugins [W]. | Prioritize Work for the full-stack pilot; do not infer identical tools in regular Chat. |
| Codex Cloud on web | Start a chat, choose Work in > Cloud; tasks have independent cloud workspaces and can continue while the user's computer sleeps [C]. | Candidate for workstation-independent coding. Verify the chosen environment's gateway connectivity/auth and plugin support separately. |
| iOS ChatGPT app | Codex mobile can start, steer and review Cloud tasks or tasks on a connected computer [M]. | Record Cloud and host-connected modes separately; the phone is not the Bashy executor. |
| Android ChatGPT app | Remote connections explicitly supports Android controlling a Mac/Windows host [R]; Codex Cloud is documented for mobile generally [H]. | Remote mode is documented. Exact Android Cloud UI, release and account availability remain unverified; do not infer iOS parity. |
| Mobile browser | The cited web/mobile guides do not establish feature parity for mobile browsers. | Separate row, unverified for this pilot; preserve the existing dots-specific mobile-web exclusion without generalizing it to every OpenAI surface. |
| Desktop host reached from mobile | Host provides tools, permissions and credentials; pairing requires matching account/workspace, an awake online host and potentially admin enablement [R]. | Optional host-backed pilot, not proof of independence from that host. Remote MCP configured there originates there. |
| CLI / IDE | Local host MCP supports stdio and Streamable HTTP; configuration is shared on that host [T]. | Retain as reference clients; their support does not prove hosted web/mobile support. |

### Evidence and implications
- [W] https://learn.chatgpt.com/docs/web — web entry uses Chat versus Work and supports follow-up prompts, projects, files and plugins.
- [C] https://learn.chatgpt.com/docs/cloud — cloud coding entry point and environment-based execution across web, mobile and desktop.
- [M] https://learn.chatgpt.com/docs/mobile — mobile task list, composer, progress, approvals, changed files/diffs and environment/host selection; rollout/workspace gates apply.
- [R] https://learn.chatgpt.com/docs/remote-connections — current supported mobile setup begins in the desktop app, not CLI/IDE. Each device pairs with each host. Phone-to-SSH workflows still connect through the desktop host.
- [H] https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex — Work Cloud, Codex Local and Codex Cloud have separate access controls. Published cloud environments are prepared on desktop/web before mobile selection. Desktop Codex remote chats are not automatically added to ordinary web/mobile history. Plan sign-in and API-key billing differ.
- [T] https://learn.chatgpt.com/docs/extend/mcp — web MCP is packaged through plugins; a remote endpoint alone does not make a plugin web-compatible. Local configuration is not automatically a cloud connection.
- [L] https://learn.chatgpt.com/docs/changelog — 2026-05-14 remote mobile launch, 2026-05-29 Windows support, 2026-06-25 Remote GA 26.623 with authenticated per-device QR pairing. These are historical milestones, not current minimum-version guarantees. Current docs use ChatGPT desktop and Codex/Remote labels; capture actual app build and visible labels in future acceptance.

### Revised pilot recommendation (operator clarification takes precedence)
Design a web Work plugin against the shared S643 gateway, then qualify iOS and Android as user interfaces to that same stack. Include permission-filtered discovery and deterministic operations across all four components. For an agentic request, dispatch a durable task to a selected Outpost running Codex authenticated through the intended subscription; use Bashy tools there and return progress, approvals, artifacts and verification evidence through the gateway.
Qualify the UI's cloud-hosted conversation separately from where the requested stack work executes: an OpenAI cloud conversation may orchestrate an Outpost task without moving that task into Codex Cloud. A headless API caller or OpenAI-hosted executor is optional comparative coverage.
Mobile-to-desktop Remote remains an alternative UI path with its own host dependency, not the required gateway architecture. Do not build a second mobile gateway or treat OpenAI's device relay as a general Cloudbox MCP endpoint.
Use text results first; rich widgets, notifications and MCP Events each need their own surface-specific evidence.

### Review gaps and required completion evidence
The previous broad client list hid Cloud versus remote-control mobile behavior. Expand the final matrix into iOS/Android x Cloud/host-connected plus mobile browser, regular Chat, Work web, Codex Cloud and legacy Cloud where applicable. Record OS/app/browser build, plan/seat, workspace controls, setup location, execution host, auth principal, tools/UI/events, limits/billing basis and dated source. Use documented / unsupported / unverified / live-proven verdicts explicitly.
Remaining work: exact per-plan/per-build availability, hosted gateway packaging/auth feasibility, Android Cloud details, mobile browser behavior, legacy/new Cloud differences and actual account qualification. No integration is live-proven and no story is closed by this review.
