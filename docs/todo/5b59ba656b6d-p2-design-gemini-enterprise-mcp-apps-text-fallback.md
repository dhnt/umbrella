---
id: 5b59ba656b6d
kind: feature
title: P2 Design Gemini Enterprise MCP Apps, text fallback and the Antigravity plugin/skill package
seq: 345
status: wontfix
priority: p2
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:37:07.131584Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
closed: 2026-11-15T15:08:20.471793Z
---

## Scope
Design UI presentation (MCP Apps + text fallback, aligned with Sprint 643 `db637f3c8ca5`) and the Antigravity/Gemini CLI plugin/skill package; design only.

## Requirements to design
- **MCP Apps (SEP-1865)** for Gemini Enterprise sandboxed iframes: approval card (action, target host, candidate digest), candidate diff/preview, task board; Cloudbox-side approval remains authoritative.
- **Structured text/JSON fallback** for `gemini.google.com` consumer web, Gemini Android/iOS, `agy` CLI/IDE/2.0, Gemini CLI and ADK callers.
- **Antigravity Plugin Package (`plugins/cloudbox-stack/`)**: `SKILL.md` (shaping lifecycle, `bashy sprint`, `outpost` safety), `mcp_config.json` (remote Cloudbox gateway `url`), and `hooks.json` lifecycle hooks; plus Gemini CLI `settings.json` / `gemini mcp add` setup guide.

## Done when
MCP Apps vs text fallback payloads and the Antigravity plugin/Gemini CLI setup contract are specified. No implementation.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
