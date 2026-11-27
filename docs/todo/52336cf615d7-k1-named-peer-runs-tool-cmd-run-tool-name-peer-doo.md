---
id: 52336cf615d7
kind: feature
title: 'K1 named peer runs: tool cmd run TOOL:NAME --peer + door GET /v1/commands listing'
seq: 829
status: todo
priority: p1
created: 2026-11-27T15:34:18.868292Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K1. Today a peer run selects by --capability only (toolcmd/peer.go runPeer refuses a name). Add selection by declared command name, admitted for shared peers only, and a listing endpoint of what this door offers. Code inspected 2026-11-27: yoke pkg/toolcmd peer.go cmd.go:278, pkg/cligw capability.go, pkg/broker peershare.go.
