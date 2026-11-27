---
id: fa2bd0d6c264
kind: feature
title: 'B1 agent budget guard: owner-set credit budget per agent principal, refusal past it, logged override'
seq: 850
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T22:39:52.897991Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service for credits, with verified delivery and a store'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §5 B1. Agents buy on their own, so the owner bounds them. bashy credits budget AGENT N [--per day] sets a credit budget per agent principal; bashy credits budget list shows budgets and spend. Inside the budget an agent adds and calls tools without asking. Past it the call is refused before the run with a machine-readable reason; the owner can override with --override --reason (logged). Observe-only first (would-refuse), per-agent enforce. Reuses the peer meter and limits (yoke pkg/broker peerlimit.go) and the receipts of G2 for spend. Accept: unit tests for under budget, at budget, refusal, override logged, observe vs enforce. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
