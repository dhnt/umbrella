---
id: 31424ce68e52
kind: feature
title: 'P1 Design gateway auth: OAuth for interactive Claude clients and scoped bearer for headless, one Cloudbox identity'
seq: 329
status: todo
priority: p1
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:32.536793Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Scope
Design the gateway's authentication and identity; design only, public wire contract.

## Requirements to design
- OAuth 2.1 mode for interactive Claude clients: authorization code + PKCE S256; /.well-known/oauth-protected-resource; authorization server metadata; DCR or Client ID Metadata Documents; the `resource` parameter bound to the token audience; allow-listed callback https://claude.ai/api/mcp/auth_callback (plus Claude Code's local callback); 401 with WWW-Authenticate on invalid tokens.
- Scoped bearer mode for headless clients (Claude Code CI, Agent SDK, Messages API authorization_token, Managed Agents vault): extend the existing scoped Cloudbox token API and yoke/docs/cloudbox-members-attach-wire.md rather than inventing a parallel token.
- One identity: the Cloudbox account; stable opaque profile id across reconnects. Both modes map onto the same scopes, revocation and audit trail.
- Decide with evidence: reuse the existing WorkOS AuthKit integration as the MCP authorization server if it qualifies, otherwise a minimal authorization server in Cloudbox.
- Preserve local MCP boundaries: host-side loopback endpoints and the yoke/mcp/transport.go public-bind refusal stay unchanged.

## Done when
A public wire-contract draft covers both modes, scopes, token lifetime, revocation, error semantics and the AuthKit-or-minimal decision. No implementation.
