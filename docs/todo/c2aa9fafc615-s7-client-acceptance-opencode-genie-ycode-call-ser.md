---
id: c2aa9fafc615
kind: test
title: 'S7 Client acceptance: opencode, genie, ycode call services via shell, MCP and llm API'
seq: 180
status: assigned
priority: p1
labels:
    - vendor-services
created: 2026-11-12T23:18:14.943104Z
assignee: claude-opus5.5
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
---

Spec: docs/sprint-626-master-execution-plan.md. Depends S1-S6. Each client calls one seeded service per category through bashy <verb> --json, bashy mcp serve and the llm API slash= filter. Record a client x door x service matrix; failures get root cause before fix.
