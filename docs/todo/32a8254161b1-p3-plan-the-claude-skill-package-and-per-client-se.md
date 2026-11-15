---
id: 32a8254161b1
kind: doc
title: P3 Plan the Claude skill package and per-client setup guide
seq: 333
status: wontfix
priority: p3
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:33.157016Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
closed: 2026-11-15T15:08:19.897655Z
---

## Scope
Plan a Claude skill package and a per-client setup guide; documentation design only.

## Requirements
- Skill package: how to use the gateway tools for software shaping (delegate, status, approve, cancel, result), reusing shaping skill-scripts; usable in claude.ai, Claude Code and the API.
- Setup guide, one short page per client: claude.ai custom connector, desktop/mobile, Cowork, Claude Code (`claude mcp add --transport http`), Claude Code on the web and scheduled tasks, Agent SDK, Messages API mcp_servers, Managed Agents vault.
- Generic names only; no hostnames, addresses or personal accounts (public repository).

## Done when
Outline and page list are agreed. Writing the pages follows implementation.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
