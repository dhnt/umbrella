---
id: e16cbb29891a
kind: bug
title: 'mcp connect: never send the member''s account token to the satellite; use a per-session attenuated child token'
seq: 733
status: done
priority: p1
labels:
    - shaping
    - access-tiers
    - security
created: 2026-11-25T04:03:44.409966Z
assignee: codex-gpt6-astra
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
closed: 2026-11-25T04:33:24.91291Z
closed_by: claude-opus5.5
---

Follow-up to Sprint 709 M1 (9a05b486f0b3), operator request 2026-11-24 ("fix it").

Defect: `bashy mcp connect URL` posts the member's saved cloudbox ACCOUNT token to POST <satellite>/api/v1/tokens/exchange, and the satellite is whatever host the URL names. A rogue satellite (or a mistyped/phished URL) captures the account token with all its scopes and full lifetime. Browser sign-in never exposes that token to a satellite.

Code inspected 2026-11-24 (yoke ac3d3841, bashy 30fe0121):
- bashy internal/agentos/mcp_connect.go connectSiteMCP: fleet.ResolveAccountSelection -> (base, token); SatelliteTokenSource{Client: SatelliteClient{BaseURL: endpoint.Satellite, Token: token}} sends that token to the satellite.
- yoke pkg/fleet/tokens.go TokenClient.Create(name, scopes, ttl) mints via POST /api/v1/tokens on cloudbox; the hosted service enforces attenuation (child scopes must be held by the caller; *:admin refused; ttl <n>h|<n>d, min 1h). TokenClient.Revoke(id) = DELETE /api/v1/tokens/:id (204; deleting the caller's own token is 409).
- Cloudbox cannot tell a member which satellites they may use (satellite reads for a non-owner account token return not found), so a "known satellite" check is not possible without a hosted change (out of scope).
- A saved SATELLITE account (selection Category == fleet.AccountSatellite, base origin == the URL's satellite) already holds a satellite-scoped token; no account token is exposed there.

Fix (KISS/MVP, operator 2026-11-24: minimal change only, no extra features):
1. When the token comes from cloudbox (not a saved satellite account for this same satellite), mint a child token at the cloudbox base with exactly ["satellites:delegate","host:proxy"], ttl "1h" (existing fleet TokenClient.Create). Only the child is sent to the satellite; the account token goes only to the cloudbox base.
2. Re-mint the child when it has expired or is about to (so sessions past 1h keep working). No revocation: an unused child expires within 1h.
3. cloudboxfake: add only POST /api/v1/tokens (attenuation: refuse a scope the caller does not hold with 403) if missing. No other fake routes.
4. A mint refusal maps to the existing named causes; tokens never printed. One usage-line wording change at most; no new flags, docs pages or options.

Acceptance (unit tests, fakes; gate host only, GOWORK=off, committed yoke pin):
- The satellite's exchange never receives the account token value (assert in the fake); it receives a child holding exactly satellites:delegate + host:proxy.
- Saved satellite-account path unchanged (no mint). Existing M1 tests stay green.
- Record the verify command + result. Commits carry `Agent: codex-gpt6-astra`. Push nothing to main; the conductor merges.
