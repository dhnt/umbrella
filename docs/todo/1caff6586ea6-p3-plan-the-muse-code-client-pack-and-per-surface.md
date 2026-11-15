---
id: 1caff6586ea6
kind: doc
title: P3 Plan the Muse Code client pack and per-surface setup guides (settings, skills, MCP profiles for workstations and outposts)
seq: 354
status: wontfix
priority: p3
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:29.567618Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.03663Z
---

Package design only: settings.json fragments (schema_version 1) for stdio-local and streamable_http-remote MCP profiles, muse mcp login flow, AGENTS.md/CLAUDE.md guidance (this repo already loads both), skill pack reuse (project skills under .agents/skills are discovered by Muse Code; muse skills import covers other agents), hooks posture, per-surface setup guides for muse.ai, Muse mobile, Meta AI app, WhatsApp and clean-machine CLI. Include the not-sandboxed MCP warning and read-only defaults prominently. Sources: dev.meta.ai/docs/muse-code/configuration.md and extending.md. Planning only.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
