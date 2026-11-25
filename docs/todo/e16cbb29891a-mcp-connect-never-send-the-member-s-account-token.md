---
id: e16cbb29891a
kind: bug
title: 'mcp connect: never send the member''s account token to the satellite; use a per-session attenuated child token'
seq: 733
status: assigned
priority: p1
labels:
    - shaping
    - access-tiers
    - security
created: 2026-11-25T04:03:44.409966Z
weave: 256
assignee: codex-gpt6-astra
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
---

Follow-up to Sprint 709 M1 (9a05b486f0b3), operator request 2026-11-24 ("fix it").

Defect: `bashy mcp connect URL` posts the member's saved cloudbox ACCOUNT token to POST <satellite>/api/v1/tokens/exchange, and the satellite is whatever host the URL names. A rogue satellite (or a mistyped/phished URL) captures the account token with all its scopes and full lifetime. Browser sign-in never exposes that token to a satellite.

Code inspected 2026-11-24 (yoke ac3d3841, bashy 30fe0121):
- bashy internal/agentos/mcp_connect.go connectSiteMCP: fleet.ResolveAccountSelection -> (base, token); SatelliteTokenSource{Client: SatelliteClient{BaseURL: endpoint.Satellite, Token: token}} sends that token to the satellite.
- yoke pkg/fleet/tokens.go TokenClient.Create(name, scopes, ttl) mints via POST /api/v1/tokens on cloudbox; the hosted service enforces attenuation (child scopes must be held by the caller; *:admin refused; ttl <n>h|<n>d, min 1h). TokenClient.Revoke(id) = DELETE /api/v1/tokens/:id (204; deleting the caller's own token is 409).
- Cloudbox cannot tell a member which satellites they may use (satellite reads for a non-owner account token return not found), so a "known satellite" check is not possible without a hosted change (out of scope).
- A saved SATELLITE account (selection Category == fleet.AccountSatellite, base origin == the URL's satellite) already holds a satellite-scoped token; no account token is exposed there.

Fix (KISS, no hosted change):
1. When the token comes from cloudbox (not a saved satellite account for this same satellite), mint a child token at the cloudbox base with exactly ["satellites:delegate","host:proxy"], ttl "1h", name "mcp-connect-<short random>". Only the child is ever sent to the satellite. The account token goes only to the cloudbox base.
2. Before the child's expiry (e.g. 5 minutes left), mint a new child and revoke the old one; the SatelliteTokenSource keeps refreshing the exchanged host:proxy token as today (the hosted exchange clamps its TTL to the child's remaining life).
3. Revoke the current child on exit (signal, EOF, error) on a best-effort basis with a short timeout; an un-revoked child expires within 1h.
4. Mint refusal maps to the existing cause names: an account token without satellites:delegate or host:proxy is refused at mint (403) -> "the account token lacks <scope>". Tokens never printed or logged.
5. cloudboxfake: add POST /api/v1/tokens (attenuation: refuse scopes the caller does not hold, 403 naming the scope; ttl parse) and DELETE /api/v1/tokens/:id, if missing; record mint/revoke for assertions.
6. Docs: `bashy mcp` usage + README line: the account token stays with cloudbox; the satellite only sees a 1h child limited to satellites:delegate + host:proxy.

Acceptance (unit tests, fakes; gate host only, GOWORK=off, committed yoke pin):
- The satellite's exchange handler never receives the account token value (assert in the fake); it receives a child holding exactly satellites:delegate + host:proxy.
- Child renewed before expiry with the old child revoked; child revoked on clean exit.
- Saved satellite-account path unchanged (no mint).
- Missing-scope account token -> named cause, no token in output; existing M1 tests stay green.
- Record the verify command + result (weave verify). Commits carry `Adhoc: mcp-connect child token` + `Agent: <you>` trailers. Push nothing to main; the conductor merges.
