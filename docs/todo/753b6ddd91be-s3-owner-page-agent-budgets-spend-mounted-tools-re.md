---
id: 753b6ddd91be
kind: feature
title: 'S3 owner page: agent budgets, spend, mounted tools, revoke'
seq: 849
status: todo
priority: p3
labels:
    - sgi
created: 2026-11-27T20:13:42.684752Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §5 S3. Not a storefront: agents buy through the CLI and tool calls. A thin owner page over CLI operations (bashy credits budget/balance/history, bashy store remove): budgets given to agents, spend, mounted tools, revoke. Every action calls a CLI op. Last in the sprint order and not part of G4. Accept: page actions map 1:1 to CLI ops. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
