---
id: db637f3c8ca5
kind: feature
title: P2 Design MCP Apps UI resources and text fallback for the gateway
seq: 331
status: todo
priority: p2
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:32.855812Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Scope
Design MCP Apps UI resources for the gateway and the text fallback; design only.

## Requirements to design
- In-chat UI for clients that render MCP Apps (claude.ai web, desktop, mobile, Cowork): approval card showing action, target host and candidate digest; candidate diff/preview; task board with status.
- Text fallback with the same information for every other client (Claude Code, SDK, API).
- An MCP App interaction is a request; Cloudbox-side approval remains authoritative and binds to the reviewed candidate.
- Follow the suite web UI rules (consistent chrome, distinct palette) where applicable.

## Done when
Resource list, payloads and fallback text are specified. No implementation.
