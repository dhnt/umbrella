---
id: 701f73b6685e
kind: feature
title: P1 Reconcile Google OAuth (web/mobile, Antigravity, Gemini CLI) and scoped bearer auth with the shared gateway
seq: 342
status: todo
priority: p1
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:37:02.031785Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
---

## Scope
Reconcile Google client authentication requirements with the shared Cloudbox remote MCP gateway auth baseline (Sprint 643 `31424ce68e52`); design only.

## Requirements to design
- Interactive OAuth 2.1 + PKCE S256 on one Cloudbox identity:
  - Expose RFC 9728 `/.well-known/oauth-protected-resource` and RFC 8414 authorization-server metadata.
  - Support RFC 7591 Dynamic Client Registration (DCR) for `gemini.google.com` Custom Connected Apps (plus manual Client ID/Secret fallback).
  - Allow-list Google redirect URIs: `https://vertexaisearch.cloud.google.com/oauth-redirect` (and `https://vertexaisearch.cloud.google.com/`), `https://antigravity.google/oauth-callback`, and Gemini CLI's local loopback callback.
  - Ensure strict StreamableHTTP and clean GAL (`auth_complete`) responses to avoid consumer web sandbox redirect loops.
- Scoped bearer mode for headless Google clients:
  - `agy mcp add --type http --header "Authorization: Bearer <token>"`, `gemini` `settings.json` headers, Google ADK `McpToolset`, and `google-genai` `client.credentials.create`.
- Preserve local loopback boundaries (`yoke/mcp/transport.go` and `outpost/docs/mcp.md`).

## Done when
Google OAuth + DCR + callback + scoped-bearer requirements are reconciled against `31424ce68e52` with live-check items marked. No implementation.
