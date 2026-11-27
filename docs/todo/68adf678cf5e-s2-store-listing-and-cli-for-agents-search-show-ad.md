---
id: 68adf678cf5e
kind: feature
title: 'S2 store listing and CLI for agents: search, show, add (mount as a tool call), remove, order'
seq: 848
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T20:13:42.043741Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §5 S2. The buyer is an agent. Public listing wire: an SGI offer publishes {class model|tool|agent, typed tool definition, definition digest, source digest, seller, ask range, unit, deal type, verifier digest, audience}; cloudbox offers listed the same way; a member's agent sees only listings of the member's relationships plus cloudbox. Verbs, all with --json and typed arg schemas (so they are MCP tools too): bashy store search QUERY [--class C] | show ID | add ID [--as NAME] | remove NAME | order ID --spec F --bid R (the V1 flow). add mounts the tool: it writes a local registered command record whose exec is bashy remote HOST -- NAME {args}, with the listed schema and pinned digests; registered records already become typed MCP tools and refresh live (yoke mcp direct.go), so no new mount mechanism. A changed definition or source digest makes the mounted tool refuse until re-added. Each row shows the track record from the ledger (settled, verifier pass share, redeliveries, distinct counterparties); no written reviews. cloudboxfake listing. Accept: unit tests for audience filtering, track record, mount/unmount (the tool appears in bashy mcp tools with a typed schema), digest-change refusal. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
