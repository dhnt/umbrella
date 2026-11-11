---
id: 930bdb1072d2
kind: feature
title: 'MCP tools: per-call timeout_ms + serve default'
seq: 142
status: todo
priority: p1
labels:
    - mcp
created: 2026-11-11T22:01:36.093864Z
---

Gap 1 of docs/strands-shell-gap-analysis.md. bashy/internal/agentos/mcp_session.go uses context.WithCancel only; hung shell_exec/run_tool/bashy calls block the agent. Acceptance: optional timeout_ms on each MCP exec tool and a serve-level default; expiry kills the process tree (Job Object on Windows), returns exit 124 with partial stdout/stderr, and writes an audit record; unit tests on Unix and Windows.
