---
id: 6e09c8e7b034
kind: feature
title: 'A1 Template: in-page agent block (MD first, HTML visible, JSON field), agent: front matter + HTML meta twin, /AGENTS.md, /skill.md, /.well-known/agent-skills/index.json, /llms.txt preamble, server card, rel=describedby/edit/via, Markdown-first for listed agent UAs, Accept tie-break by order; regenerate dhnt/site'
seq: 671
status: todo
priority: p1
created: 2026-11-23T13:51:45.467246Z
sprint: 697
---

Design: docs/agent-ready-sites.md Layers 0 and 1. In bashy examples/shaping/site (template + site.bsh): the agent block '## For agents {#agents}' generated from site.json (origin, source repo, edit URL pattern, MCP endpoint, skill path) in all three representations; Markdown front matter agent: {instructions, index, skills, source, edit, mcp, cite} and <meta name=agent:instructions> in HTML (Cloudflare's shape); fixed paths /AGENTS.md (full block + site map), /skill.md (= the site skill), /.well-known/agent-skills/index.json (schema 0.2.0, so npx skills add <origin> works), /.well-known/mcp/server-card.json (points at the owner's MCP endpoint when configured), /llms.txt with an operating preamble; Link and <link>: rel=describedby -> /llms.txt, rel=alternate twins, per page rel=edit -> source file edit URL, rel=via -> repository, rel=canonical; serving rule: Accept ties broken by listing order and Markdown served to a configurable list of agent user agents (default = the known agent UAs; same content, different representation). Tests for every rule; site check verifies the block is first in Markdown and present in HTML/JSON. Regenerate github.com/dhnt/site (content unchanged, tag v0.2.0). Acceptance: template tests green; a sample site and dhnt/site pass site check; the three representations of every page agree on links, ids, revision and the agent block.
