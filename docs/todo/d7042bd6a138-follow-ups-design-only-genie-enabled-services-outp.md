---
id: d7042bd6a138
kind: spike
title: 'follow-ups (design only): genie-enabled services (outpost ask, satellite), MCP elicitation approval gate in bashy mcp serve, skill learn promotion, fine-tuning export of request->script pairs, readline rung 2'
seq: 253
status: todo
priority: p3
labels:
    - agentic
created: 2026-11-13T19:18:00.018427Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Not in this sprint's gate. One design doc listing: (1) outpost daemon and the satellite hosting the same run/refine loop behind their door, memory per daemon / per owner; (2) bashy mcp serve using MCP elicitation (supported by Claude Code 2.1.76+, Codex CLI, OpenCode, Cursor, Copilot CLI) to put the human approval of a new or changed CMD.bsh in the caller's UI, since MCP sampling is deprecated in the 2026-07-28 spec and Claude Code never declared it; (3) bashy skill learn admitting a stable overlay script as a fixed skill and graph-learn-style promotion of refine failures to kb gotchas; (4) agentic-forge export --pairs for fine-tuning a small per-command model (Memp strong-to-weak transfer); (5) pkg/ladder rung 2 routing free-text prompt lines to agentic (bind is a stub). Research pointers: Memp (ACL Findings 2026), ReasoningBank (Google 2025), Subagents vs Agent Skills (2026), NL2SH-ALFA (NAACL 2025).
