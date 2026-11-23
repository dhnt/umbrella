---
id: cbddad1931f9
kind: feature
title: 'A3 Site MCP endpoint: bashy mcp serve profile ''site'' (list_pages, read_page, cite, owner-gated shape tools) at a fixed owner-set URL; published through outpost or the hosted relay; server card'
seq: 673
status: todo
priority: p1
created: 2026-11-23T13:51:45.761555Z
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 2 (MCP). bashy already serves MCP over stateless Streamable HTTP (bashy mcp serve --transport http, --outpost identity auth). Add a tool profile 'site' backed by the site module: list_pages, read_page(path|url, format), cite(url#id) returning the citation record, and the shape tools wish/verify/preview/approve/undo gated to the owner principal (existing shape service). The endpoint is fixed by the owner (site.json mcp: URL), reachable through outpost / the hosted relay like other apps, authenticated (bearer or OAuth 2.1 with /.well-known/oauth-protected-resource per the MCP spec; anonymous allowed only for read tools if the owner says so), and advertised in the agent block and /.well-known/mcp/server-card.json. Acceptance: Claude Code (claude mcp add --transport http), Codex, Gemini CLI and OpenCode connect to the endpoint from the URL in the agent block and call read_page and cite successfully; an owner session shapes through the MCP tools and a non-owner is refused by name; the hosted dhnt.io endpoint is served by the owner's engine (not the hosted plane) unless the operator decides otherwise.
