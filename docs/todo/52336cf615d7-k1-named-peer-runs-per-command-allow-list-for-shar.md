---
id: 52336cf615d7
kind: feature
title: K1 named peer runs + per-command allow-list for shared peers
seq: 829
status: done
priority: p1
created: 2026-11-27T15:34:18.868292Z
assignee: codex-gpt6-sol
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
closed: 2026-11-28T06:48:09.078336Z
closed_by: claude-opus5.5
---

Plan: docs/sprint-739-master-execution-plan.md §4 K1. The door already runs a named command for a shared peer via X-Bashy-Filter slash=NAME[,tool=TOOL] (cligw server.go:631-714, slash.go:339-480); only the caller refuses names (toolcmd cmd.go:280-291). Caller: runPeer accepts TOOL:NAME|NAME; DispatchPeerCommand in peer.go beside DispatchPeerCapability, no measured-selection checks (peer.go:203-215), verifies res.Tool/res.Command. Door: PeerShare.Commands allow-list checked from the parsed slash name (broker.go:497 slashOf), 403 when not listed; empty list = no named commands (pre-existing gap: any shared peer can run any declared command today). Code inspected 2026-11-27 (revised after review): yoke pkg/toolcmd cmd.go peer.go, pkg/cligw server.go slash.go, pkg/broker peershare.go broker.go.

Review 2026-11-27: unchanged in scope. The parsed slash name the allow-list checks is the same name T1 writes to the run record; expose it once (plan §3.1). Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).


Seam (conductor): the owner sets the allow-list with the existing peer verb: `bashy llm peer add|set NAME --command NAME` (repeatable; whichever of add/set already exists). Expose the parsed slash name once as a broker helper that T1 can reuse. Files: pkg/broker peershare.go (+ peercmd.go), broker.go; pkg/toolcmd cmd.go, peer.go.
Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-k1, based on current origin main. Change only what this story's Accept needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests for the packages you touch only, e.g. `cd yoke && GOWORK=off go test ./pkg/broker/ ./pkg/toolcmd/`. No full suites, no e2e, no network, no podman, no paid provider. Use fakes (httptest) for doors and agents.
- Commit in yoke with trailers: Sprint: #739 / Story: #829 / Story-ID: 52336cf615d7 / Agent: <your agent name>. Do not push main, do not bump any pin, do not edit other repos except as the story says.
- Finish by appending a "Delivery" paragraph to this story file (files changed, test command and its result) and commit it in the umbrella workspace with the same trailers.
- Budget about 30 minutes. If blocked, write the blocker in the story, commit, and stop. Do not work around a failing pre-existing test: record it.

Delivered (conductor record): yoke main 6efea8dc (worker commit 6872b321 by codex-gpt6-sol, cherry-picked). Gate: GOWORK=off go test ./pkg/broker/ ./pkg/toolcmd/ ok; go vet ok.
