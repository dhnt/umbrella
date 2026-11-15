---
id: 7eb38edf97a8
kind: spike
title: P1 Research Google web, mobile, Antigravity (agy) and Gemini CLI compatibility and recommend a full-stack pilot
seq: 341
status: todo
priority: p1
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:36:48.150909Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
---

## Request and boundary
Sibling of Sprint 642 (OpenAI/Codex, 7b4a9392-be5f-5398-a236-fba1d0868fae) and Sprint 643 (Claude, b3afcef3-bce0-5e7f-bbe0-400e1c629958): any supported Google web/mobile/developer/agentic client must reach the full Cloudbox / Satellite / Outpost / Bashy stack through the same shared, vendor-neutral Cloudbox remote MCP gateway.

Planning only: no coding, deployment, provisioning, live account checks or agent launches. Keep in backlog without appointing a manager.

## Research findings (source/document inspection 2026-11-15, not live verification)
- **gemini.google.com (Consumer Web)**: Supports Custom Connected Apps via a public HTTPS StreamableHTTP MCP server URL (`Menu > Settings > Connected Apps`), invoked via `@YourCustomApp` or contextually. OAuth redirect URI: `https://vertexaisearch.cloud.google.com/oauth-redirect` (or `https://vertexaisearch.cloud.google.com/`) with `.well-known` discovery and RFC 7591 DCR (manual Client ID/Secret fallback). Known friction: legacy SSE breaks stateful handshakes; GAL `auth_complete` sandbox loops if DCR rejects the redirect URI. Gates: personal Google Account only (Workspace restricted), 18+, US, English, **Keep Activity ON**. Also supports **Gemini Scheduled Actions** (daily/weekly/monthly background runs).
- **Gemini Mobile App (Android & iOS)**: Custom MCP Connected Apps cannot be configured in the mobile app directly, but once linked in `gemini.google.com`, they **auto-sync to Android and iOS** and are invoked via `@YourCustomApp`. Keep Activity OFF breaks custom apps on iOS.
- **Gemini Enterprise (Google Cloud / Vertex AI)**: Supports Custom MCP Data Stores over StreamableHTTP (SSE unsupported in strict enterprise) with OAuth 2.0 (`https://vertexaisearch.cloud.google.com/oauth-redirect`) or GCP Service Account / IAM, private ingress via Google Agent Gateway, and **MCP Apps (SEP-1865)** rendered in sandboxed iframes.
- **Antigravity (`agy` CLI, Antigravity IDE, Antigravity 2.0, Python SDK)**: Streamable HTTP (`url` in `~/.gemini/config/mcp_config.json`, legacy SSE unsupported) and `agy mcp add --type http --header "Authorization: Bearer ..."` (CLI). Docs list `https://antigravity.google/oauth-callback` and `authProviderType: "oauth2"`. Also exposes `agy acp` (Agent Client Protocol stdio server), `agy --remote-agent`, `agy remote-control`, and `agy plugin` (skills/rules/plugins/hooks/MCP).
- **Gemini CLI (`gemini`)**: Supports Streamable HTTP (`gemini mcp add --transport http`) and SSE with OAuth 2.0 auto-discovery (`/mcp auth <name>`) or Bearer header in `~/.gemini/settings.json`.
- **Google ADK & `google-genai` SDK**: `McpToolset(server_url=..., headers=...)` (ADK) and `client.credentials.create` (GenAI SDK) for headless/programmatic callers.
- **Google AI Studio (`aistudio.google.com`)**: Developer playground only (no custom remote MCP connector in web UI; exposes Gemini Docs MCP Server for external agents).
- **Jules (`jules.google.com`)**: Isolated Cloud VM coding agent that consumes external MCP servers from settings; verify whether in scope or deferred.
- **Local stack state**: `yoke/mcp/transport.go` refuses non-loopback HTTP binds; `outpost/docs/mcp.md` is loopback-only admin MCP; `bashy/internal/agentos/installagent.go` has PATH shims for `gemini` and `agy`, but `mcpWriters()` only supports `claude`, `codex`, `opencode` (no `agy` or `gemini` `--mcp` or `--hooks` writer).

## Shared architecture and dependencies
Reuse the vendor-neutral Cloudbox remote MCP gateway designed in Sprint 643 (`31424ce68e52` auth, `598058346ae0` routing, `db637f3c8ca5` UI/text, `71e63b97abfb` no-push recovery) and Sprint 642. Do not build a Google-specific backend.

## Deliverables
Source-backed compatibility matrix covering `gemini.google.com`, Gemini Android/iOS, Gemini Enterprise, Antigravity (`agy`/IDE/2.0/SDK), Gemini CLI, Gemini Code Assist, ADK/`google-genai`, AI Studio, and Jules; pilot recommendation (recommended: `gemini.google.com` -> Android/iOS sync + `agy` CLI / Gemini CLI) with open decisions and live-verification items explicit.

## Sources inspected 2026-11-15
- Local: `bashy/internal/agentos/installagent.go`, `yoke/mcp/transport.go`, `yoke/mcp/direct.go`, `outpost/docs/mcp.md`, `agy --help`, `agy mcp add --help`, `antigravity-guide` & `agy-customizations` builtin skills, Sprint 642 (`f0cabeb9c6e3`), Sprint 643 (`50291ed35646`).
- Web: Google Gemini Connected Apps & Mobile docs, Gemini Enterprise / Vertex AI MCP & MCP Apps docs, Gemini CLI MCP docs, Antigravity MCP docs, Google ADK / GenAI SDK docs, Jules MCP docs.
