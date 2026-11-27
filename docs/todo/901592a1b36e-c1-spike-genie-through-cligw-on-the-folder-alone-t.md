---
id: 901592a1b36e
kind: spike
title: 'C1 spike: genie through cligw on the folder-alone task (go/no-go)'
seq: 821
status: assigned
priority: p1
created: 2026-11-27T14:25:09.514287Z
assignee: claude-opus5.5
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C1. No product code. Run bashy genie -m <cligw binding> uncontained on the Sprint 737 greet folder-alone fixture with claude-opus5.5 and muse-wonder through cligw; record answer quality, tool-call fidelity per vendor, turns, latency and quota per turn in the plan. Go/no-go for C2 to C5; a vendor that falls short is left out. Code inspected 2026-11-27: yoke pkg/cligw cmd.go, worker.go, server.go, translate.go, xml_tool_recover.go; ycode examples/genie/agent.yaml.
