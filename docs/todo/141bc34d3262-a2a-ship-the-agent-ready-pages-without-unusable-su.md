---
id: 141bc34d3262
kind: feature
title: 'A2a Ship the agent-ready pages without unusable surfaces: no /mcp and no ''bashy site attach'' advertising until both work'
seq: 739
status: todo
priority: p0
labels:
    - release
    - hosted-plane
created: 2026-11-25T06:08:18.905704Z
sprint: 699
sprint_id: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a
sprint_title: 'Release train 1: one hosted-plane deploy for Sprints 682/697 + live verification'
---

Operator rule 2026-11-24: every released feature is complete and usable; ship the complete part, put the rest in a follow-up sprint. Found while reconciling train 1 (2026-11-24): with PUBLIC_SITE_MCP_UPSTREAM unset, the hosted public pages (dhnt/site v0.2.1) still advertise an MCP endpoint at <origin>/mcp in agents.txt (mcp:, mcp_card:), skill.md ('connect to MCP at'), AGENTS.md, humans.txt, the in-page agent note, the Link service-desc header and /.well-known/mcp/server-card.json (tools list_pages/read_page/cite/shape_*). Every anonymous or cookie caller of /mcp is denied, so the advertised surface is unusable. The agent block also says 'Run: bashy site attach <origin>', a verb first in bashy 775bcc30 (2026-11-23) and in no released bashy (latest v1.0.0-rc.40-dev predates it). SMALLEST FIX: dhnt/site renders no MCP lines, no service-desc link and no server card when MCP is off, and no site-attach line until enabled; the hosted plane turns both off while the upstream is unset. Keep the pages, Markdown/JSON twins, agents.txt, skill.md and citations. ACCEPT: unit tests in dhnt/site and the hosted plane assert absence when off and presence when on; the T1 live curl matrix checks no /mcp or site-attach advertising on dhnt.io; the remainder is Sprint 711. Must merge to the hosted dev branch before the 699 freeze.
