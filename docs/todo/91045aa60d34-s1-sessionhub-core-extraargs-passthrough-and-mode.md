---
id: 91045aa60d34
kind: feature
title: 'S1: SessionHub core, ExtraArgs passthrough, and Mode (a) direct --agent delegation'
seq: 559
status: wontfix
priority: p1
labels:
    - yoke
    - agenthub
    - chat
created: 2026-11-20T13:08:35.94045Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
closed: 2026-11-24T18:16:45.254282Z
---

Repo: yoke. Add literal ExtraArgs []string passthrough to agentlaunch.Options (never shell-split; ReadOnly safety stripping stays authoritative). Create yoke/pkg/agenthub with SessionHub, canonical turn/chunk/thought/approval event fan-out, loopback-only HTTP mux + per-run bearer auth, and Mode (a) direct delegation across official fleet tools via pkg/chat + pkg/room + pkg/ask + pkg/gate. Spec: docs/plan-one-agent-genie-hub.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. Routing between people, agents and hosts is already supported by the group model as implemented (Sprints 684/685, gateway sync/pull/hosted routes); the extra protocol surfaces are not needed now. Retired, not delivered.
