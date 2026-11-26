---
id: 65e122506d13
kind: enhancement
title: 'M1: go-sdk v1.9.x + MCP 2026-07-28 interop for yoke, bashy, outpost'
seq: 752
status: todo
priority: p3
labels:
    - mcp
created: 2026-11-25T14:41:47.085764Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
---

Problem: the operator asked to upgrade bashy MCP support to "v2" — the MCP spec revision 2026-07-28 (https://blog.modelcontextprotocol.io/posts/2026-07-28/): stateless core (no initialize handshake / Mcp-Session-Id; version+capabilities in _meta), server/discover, Mcp-Method/Mcp-Name headers, MRTR replacing server-initiated elicitation/sampling/roots, subscriptions/listen, ttlMs/cacheScope list caching, Tasks as extension, auth (RFC 9207 iss, CIMD). Roots/Sampling/Logging and legacy HTTP+SSE deprecated with 12-month offramp. There is NO go-sdk /v2 module (proxy: none); go-sdk is the Tier 1 Go SDK and speaks 2026-07-28 from v1.8.0.

Code inspected (2026-11-25, umbrella 2148f6941):
- go.mod: go-sdk v1.8.0 in bashy, yoke, outpost; ycode indirect. Upstream: v1.8.0 stable, v1.9.0-pre.1 (2026-11-17; hardening, per-session Notify*List Changed, StreamKeepAlive, 8 new MCPGODEBUG flags, 7 v1.7 flags removed).
- Servers already Stateless: yoke/mcp/transport.go:64, bashy/internal/agentos/mcp_hosted.go:340; outpost/internal/agent/mcpapi/server.go:127 (check options). yoke/mcp/server.go:106 already handles 2026-07-28 deprecations; yoke/mcp/policy.go:334 reports SupportedProtocolVersions()[0].
- Clients: bashy/internal/agentos/mcp_connect.go:155 (StreamableClientTransport + stdio), outpost/cmd/outpost/mcpclient.go:64.
- No use of SSE transport, roots, sampling, logging, elicitation, Mcp-Session-Id found outside tests.
Gap is therefore narrow: SDK bump + verify behaviour on 2026-07-28 vs 2025-11-25 peers; no feature work expected.

Scope (MVP):
1. Bump go-sdk to the stable v1.9.x (wait for it; pre-release only for a trial branch) in yoke first, then bashy and outpost (producer pushed first; bashy mod sync; ycode pin follows).
2. Review MCPGODEBUG changes/removals against our code; no flags set unless a test proves need (record why).
3. Tests: one per surface that a 2026-07-28 client and a 2025-11-25 client both complete tools/list + tools/call against yoke mcp serve, bashy hosted /mcp and outpost mcpapi; bashy mcp connect against a 2026-07-28 server.
Non-goals (not in MVP): MRTR/elicitation, subscriptions/listen, Tasks extension, MCP Apps, CIMD auth, server/discover use in clients.

Acceptance: unit tests green per touched module (GOWORK=off) on the gate host (never the dev box); bashy mod drift clean; umbrella pins bumped; root cause recorded for any red before fixing.

## Triage 2026-11-25 (consolidated into Sprint 724)

Blocked on upstream: the module proxy still lists v1.9.0-pre.1 as the newest go-sdk; no stable v1.9.x. Priority p3 until it is published.
