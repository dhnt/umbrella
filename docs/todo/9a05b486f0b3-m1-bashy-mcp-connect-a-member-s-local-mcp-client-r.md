---
id: 9a05b486f0b3
kind: feature
title: 'M1 bashy mcp connect: a member''s local MCP client reaches the owner''s site MCP with a satellite-exchanged token'
seq: 729
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T22:59:39.881619Z
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
---

A member (C) connects their own MCP client to the owner's (O's) site MCP from C's machine, as C, with no OS password. Permission is unchanged and stays per app: the satellite admits C only where O's share covers C (HostShares.CanReach per host and app), O's outpost stamps C's circle/groups from O's member list, and the Sprint 706 scopes decide what C may do. The token only proves identity, exactly like C's browser login.

Code inspected 2026-11-24 (facts; cloudbox is private, referenced by behavior only):
- The satellite app route (/matrix/h/HOST/app/NAME/...) accepts a Bearer token before the cookie and forwards the same X-Periscope-User identity to the outpost; a Bearer with host:proxy passes the login gate; members never need the OS password (owner-only PAM on elevation_required apps).
- A satellite token comes from POST /api/v1/tokens/exchange with the account (master) token: default TTL 30m, max 1h; host:proxy is exchangeable. The same exchange already exists in yoke/external/dks/userland_session.go (~1271, body {"scopes":["host:proxy"],"ttl":"10m"}).
- The member's cloudbox account token: yoke/pkg/fleet/account.go ResolveCloudAccount (--account REF uses a saved account token); ResolveMaster (cloudbox.go) for explicit --url/--token.
- bashy has no MCP client/proxy command today: `bashy mcp` has serve and tools only (internal/agentos/mcp_site.go uses mcpsdk.NewClient only for help).

Build: `bashy mcp connect URL [--account REF] [--json]` where URL is the app's https://SATELLITE/matrix/h/HOST/app/NAME/mcp. It serves stdio to the local client (Claude Code, codex, any MCP client) and forwards to URL over streamable HTTP with a satellite token exchanged from the account token (reuse the dks exchange as a small shared helper in yoke/pkg/fleet), refreshed before expiry; tokens never logged or printed. Errors name the cause (no account token, exchange refused, not shared with you).
Acceptance: unit tests against yoke/pkg/fleet/cloudboxfake (add a tokens/exchange route if missing) and an httptest MCP server: tools/list and tools/call pass through; the bearer is the exchanged token, refreshed past TTL; no token in output; --json envelope. Gate host only.
