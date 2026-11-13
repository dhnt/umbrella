---
id: eb02f4409ad1
kind: bug
title: transcribe service not reachable over bashy mcp serve (tool verb denied for destroy)
seq: 195
status: todo
priority: p2
labels:
    - vendor-services
created: 2026-11-13T02:18:41.562375Z
---

S626 S7 F3 (docs/sprint-626-acceptance.md). No transcribe door verb is registered (bashy transcribe is the S503 pipeline), and MCP tool 'tool' with args cmd run muse:transcribe is denied: 'effect destroy requires --allow destroy', because the tool verb's atlas effects aggregate cancel/rm. Fix: per-subcommand effects for tool cmd run, or a transcribe service-door verb.
