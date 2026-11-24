---
id: 9a05b486f0b3
kind: feature
title: 'M1 bashy mcp connect: a member''s local MCP client reaches the owner''s site MCP with a satellite-exchanged token'
seq: 729
status: assigned
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T22:59:39.881619Z
weave: 252
assignee: agy-gemini4-carbon
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

## Run 252 outcome and finishing instructions (conductor, 2026-11-24)

Run 252 (agy-gemini4-carbon) timed out at the 40-minute print limit while copying its tree to the gate host. Its work is preserved, already rebased onto the M2 heads (yoke 4ee516f5, bashy 1b3d428e):
- yoke branch `s709-m1-wip` (2f6b2e58): fleet satellite_exchange.go (ParseSatelliteAppURL, ResolveAccountSelection, SatelliteTokenSource refreshing host:proxy before expiry), SatelliteClient.Exchange returning TokenExchangeResponse, cloudboxfake POST /api/v1/tokens/exchange and MountApp share-gated routing. Committed, not gate-tested.
- bashy branch `s709-m1-wip` (d9acf230): internal/agentos/mcp_connect.go (+ tests) and the `bashy mcp connect` dispatch in mcp.go. Untested WIP.

Finish from these branches (use them as the base; they are on current heads):
1. Match the real satellite exchange behavior in cloudboxfake (verified against the hosted service's code by the conductor; public wire behavior only):
   - A non-owner is exchanged only if admitted on the satellite AND they have signed in to that satellite at least once (a login grant exists). Add a fake helper to record that sign-in; refuse with 403 "delegation refused" otherwise.
   - The account token must hold `satellites:delegate` and every requested scope (e.g. host:proxy); a requested scope it does not hold is refused with 403 "scope escalation refused". The TTL is clamped to the account token's remaining lifetime.
2. `bashy mcp connect` errors name the cause without leaking tokens: no account token; exchange refused (not admitted, never signed in to the satellite in the browser, or the account token lacks host:proxy / satellites:delegate); app not shared with you (the app route's 403).
3. KISS: keep the bridge to what the acceptance needs; drop anything else from the WIP.
4. Unit tests on the gate host only (yoke pkg/fleet/... and bashy internal/agentos focused on mcp connect + existing mcp tests), GOWORK=off, with the committed yoke pin. Record the verify command and result (`weave verify`) so submission is not refused. Push nothing to main; the conductor merges.
