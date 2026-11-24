---
id: 37acc22170b3
kind: feature
title: 'S3: Inbound A2A v1.0 server adapter and outbound herald Credential Bearer header fix'
seq: 561
status: wontfix
priority: p1
labels:
    - yoke
    - a2a
    - herald
    - agenthub
created: 2026-11-20T13:08:36.22809Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
closed: 2026-11-24T18:16:27.096068Z
---

Repo: yoke. Implement proto_a2a.go in yoke/pkg/agenthub on a2a-go/v2/a2asrv: serve /.well-known/agent-card.json (A2A-Version 1.0, streaming, https://dhnt.io/ext/gate/v1), /a2a JSON-RPC, and /a2a/rest/* over SessionHub. Wire existing herald.Credential(p) Bearer header onto outbound herald Discover and Send calls in yoke/pkg/herald/client.go and align stale exit-code comments. Depends on S1. Spec: docs/plan-one-agent-genie-hub.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. Routing between people, agents and hosts is already supported by the group model as implemented (Sprints 684/685, gateway sync/pull/hosted routes); the extra protocol surfaces are not needed now. Retired, not delivered.
