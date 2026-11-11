---
id: 631dee43ad59
kind: test
title: verify effect guard covers eval/source/trap/xargs/find -exec
seq: 145
status: todo
priority: p2
labels:
    - security
created: 2026-11-11T22:01:36.296711Z
---

Gap 4 of docs/strands-shell-gap-analysis.md. Acceptance: tests prove or disprove that @guard/MCP --allow see commands reached through eval, source, traps, xargs and find -exec children; any gap is routed through the existing atlas/policy check (no new name-list engine) with the root cause recorded.
