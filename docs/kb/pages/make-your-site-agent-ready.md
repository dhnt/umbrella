---
id: 01a20a14-3ee2-70c3-ba16-c6d28ff2e576
seq: 21
form: page
type: runbook
title: Make your site agent-ready
description: 'Make a shaping-enabled site agent-ready: template channels to publish, MCP endpoint setup, signing, and how agents behave — WHEN a site owner wants any agent handed a page URL to explore, cite and shape the site'
status: candidate
evidence: Sprint 697 A1/A3/A3b/A4 shipped on bashy main; docs/agent-ready-sites.md
source:
    tool: muse-wonder-g
    episode: ep-36f3e96fc1309011
    parent_episode: ep-6299da9220c705e0
created: "2026-11-23T20:23:48Z"
---

## For the site owner

Publish from the site template (bashy examples/shaping/site); never hand-edit generated twins.

1. Publish the agent block: visible ## For agents {#agents} first in the Markdown twin and DOM-first <p id="agent-note" role="note"> in HTML; keep <script type="text/bashsharp">, <div hidden> and <noscript> copies exactly equal to the visible block (site check enforces it; recipes are shown, never run by default).
2. Publish the pointer layer: /agents.txt (key: value header + prose), /AGENTS.md, /skill.md, /llms.txt, /.well-known/agent-skills/index.json (0.2.0), /.well-known/mcp/server-card.json, /.well-known/oauth-protected-resource, Bashy-Shaped header and Link relations (alternate, describedby, edit, via, service-doc, service-desc, canonical, author, help) on every response. Serve Markdown-first: Accept ties break by listing order; listed agent_user_agents get Markdown without an Accept header. Same content, no cloaking.
3. Set the MCP endpoint at same-origin <origin>/mcp (Streamable HTTP POST + SSE GET, no redirect): bashy mcp serve --transport http --tools site --site-app <app> (or --site-dir <dir>); add --outpost when fronted by outpost's <app>/mcp reverse proxy. Tools: list_pages, read_page, cite; owner-gated shape_wish, shape_verify, shape_preview, shape_approve, shape_undo.
4. Optional identity: run bashy site key [--json] and paste the JWK into site.json trusted_bot_keys (or allowlist trusted_key_directories / trusted_origins). Verified callers get Bashy-Verified-Agent; content is never gated or altered.

## How agents will behave

An agent handed any page URL reads the agent block first, then follows /agents.txt and /llms.txt, cites sections as {url, section_id, revision, section_sha256, quote}, equips itself with bashy site attach <origin> / bashy skills add <url>, prefers the <origin>/mcp endpoint over scraping, and shapes only through wish, verify, preview, approve, undo. Signed agents use bashy fetch / bashy site --sign (BASHY_SIGN_REQUESTS=1) with --signature-agent (BASHY_SIGNATURE_AGENT) under bashy-fetch/<version> / bashy-site/<version>.

Verify: bashy site explore <url>, bashy site cite <url>#<id>, bashy kb doctor.
