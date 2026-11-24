---
id: b85a2ef8b5bc
kind: feature
title: 'S4: Inbound MCP, headless ACP stdio co-serving, REST/SSE API, and embedded Human Web UI'
seq: 562
status: wontfix
priority: p1
labels:
    - yoke
    - mcp
    - acp
    - web
    - agenthub
created: 2026-11-20T13:08:36.377259Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
closed: 2026-11-24T18:16:52.265836Z
---

Repo: yoke. Implement proto_mcp.go (/mcp Streamable HTTP with agent_prompt, agent_steer, agent_interrupt, agent_sessions, agent_status + yoke/mcp.Policy), proto_acp.go (headless ACP v1 stdio over SessionHub with raw stdout fd reservation and os.Stdout->os.Stderr redirect), proto_rest.go (/api/v1/* JSON + SSE/NDJSON), and proto_http.go + ui/index.html (zero-CDN embedded Human Web UI with fragment token auth, cross-protocol session list, live steer/interrupt, inline HITL approvals, and client snippets). Depends on S1. Spec: docs/plan-one-agent-genie-hub.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. Routing between people, agents and hosts is already supported by the group model as implemented (Sprints 684/685, gateway sync/pull/hosted routes); the extra protocol surfaces are not needed now. Retired, not delivered.
