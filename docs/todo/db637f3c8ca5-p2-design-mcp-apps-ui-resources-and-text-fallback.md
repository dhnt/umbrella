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
- Verified 2026-11-15: MCP Apps render from a private custom connector without directory listing — serve a `ui://` resource with mime `text/html;profile=mcp-app`, rendered in a sandboxed iframe; available on web, desktop, mobile and Cowork on all plans. Mobile renders inline only (no side panel or full-site views yet), so the approval card and task board must work as inline cards; directory submission review applies only if we later list publicly.

## Done when
Resource list, payloads and fallback text are specified. No implementation.
