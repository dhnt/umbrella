---
id: d8b3b7233444
kind: feature
title: G3 bashy credits, per-relationship lines and per-unit bidding (402 counter)
seq: 840
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:45.029314Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.2, §5 G3. Pay per use only; no lease or subscription deal. bashy credits balance|history|verify|export from held receipts. Per-relationship credit line set by the seller. The price is per unit named in the offer: call, token, or output unit. Bidding: the ask moves inside the offer range with load; taker --bid MIN..MAX (X-Bashy-Bid); overlap clears at max(ask, take MIN) capped at min(offer MAX, take MAX); no overlap = 402 counter {ask, range}; --any picks the lowest in-range ask (HEAD), tie on latency; no order book. Metered units (tokens, seconds) are read from the door run record (broker audit.go); the receipt carries units x cleared price; the taker's --max and an agent offer's token cap bound the total, and a run that reaches the cap stops and is charged for what was used. Per-call deals are final at once. Observe-only default; per-offer enforce. Accept: unit tests overlap/no overlap/cap/line/--any/metered total/token cap/both modes. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
