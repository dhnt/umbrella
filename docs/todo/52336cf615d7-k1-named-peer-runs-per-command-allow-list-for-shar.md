---
id: 52336cf615d7
kind: feature
title: K1 named peer runs + per-command allow-list for shared peers
seq: 829
status: todo
priority: p1
created: 2026-11-27T15:34:18.868292Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K1. The door already runs a named command for a shared peer via X-Bashy-Filter slash=NAME[,tool=TOOL] (cligw server.go:631-714, slash.go:339-480); only the caller refuses names (toolcmd cmd.go:280-291). Caller: runPeer accepts TOOL:NAME|NAME; DispatchPeerCommand in peer.go beside DispatchPeerCapability, no measured-selection checks (peer.go:203-215), verifies res.Tool/res.Command. Door: PeerShare.Commands allow-list checked from the parsed slash name (broker.go:497 slashOf), 403 when not listed; empty list = no named commands (pre-existing gap: any shared peer can run any declared command today). Code inspected 2026-11-27 (revised after review): yoke pkg/toolcmd cmd.go peer.go, pkg/cligw server.go slash.go, pkg/broker peershare.go broker.go.

Review 2026-11-27: unchanged in scope. The parsed slash name the allow-list checks is the same name T1 writes to the run record; expose it once (plan §3.1). Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).
