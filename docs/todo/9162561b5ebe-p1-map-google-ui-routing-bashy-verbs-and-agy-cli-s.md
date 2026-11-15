---
id: 9162561b5ebe
kind: feature
title: P1 Map Google UI routing, bashy verbs and agy CLI/subscription execution on outposts
seq: 343
status: wontfix
priority: p1
labels:
    - software-shaping
    - google-integration
    - antigravity-integration
created: 2026-11-15T13:37:04.012686Z
sprint: 644
sprint_id: 7d2c534d-c52e-5ee5-83dd-fa7ce89c3e4e
sprint_title: 'Google clients to the full Cloudbox stack: web, mobile, Antigravity (agy) and Gemini CLI through one shared remote gateway'
closed: 2026-11-15T15:08:20.846006Z
---

## Scope
Map Google web/mobile and `agy` UI surfaces onto the shared hub routing and tool set (Sprint 643 `598058346ae0`), and design how `agy` CLI and its subscription service run as the agentic execution tool on outposts; design only.

## Requirements to design
1. **UI -> Hub Routing & Tool Set (`598058346ae0`)**:
   - `list_hosts`, `delegate`, `status`, `clarify`, `approve`, `cancel`, `result`, and bounded read-only `bashy` queries under `yoke/mcp/direct.go` effect policy.
   - `@YourCustomApp` mention and contextual tool invocation ergonomics on `gemini.google.com` and Gemini Android/iOS.
   - Compare `agy acp` and `agy --remote-agent` / `remote-control` (single-workstation session) against Cloudbox multi-host hub-outpost routing.
2. **Outpost-Side Execution (`agy` CLI + Subscription Service)**:
   - Headless/automated invocation on outposts: `agy -p` / `--print` with `--output-format stream-json` (`--input-format stream-json` for multi-turn), `--mode` (`accept-edits|auto|plan`), `--sandbox`, `--settings`, `--print-timeout`, `--conversation <id>` resume, or `agy acp` stdio server.
   - Subscription/auth lifecycle on headless outposts: how `agy` subscription credentials are provisioned, persisted, and refreshed across outposts without interactive browser login on every node (and quota/model selection via `--model` / `--effort`).
   - `bashy` integration gaps:
     - `bashy/internal/agentos/agents.go` currently has no `agy` agent driver/adapter.
     - `bashy/internal/agentos/installagent.go` has PATH shim (`AGENT=agy`) for `agy`, but `mcpWriters()` lacks `agy` and `gemini`, and `hookWriters` lacks `agy` `hooks.json` inbox hooks.
   - Ownership boundary: outpost steward remains the single execution owner per task; `agy` runs as the delegated coding agent inside the workspace/sandbox, never bypassing steward/Cloudbox approval gates.

## Done when
Hub routing, outpost `agy` CLI/subscription execution contract, and `bashy` (`agents.go` + `installagent.go`) gaps are documented against `598058346ae0`. No implementation.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
