---
id: d8b3b7233444
kind: feature
title: G3 bashy credits, per-relationship lines and per-call bidding (402 counter, observe-only)
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

Plan: docs/sprint-740-master-execution-plan.md §3.2, §5 G3. bashy credits balance|history|verify|export from held receipts. Per-relationship credit line set by the seller. Bidding: the ask moves inside the offer range with load; taker --bid MIN..MAX (X-Bashy-Bid); overlap clears at max(ask, take MIN) capped at min(offer MAX, take MAX); no overlap = 402 counter {ask, range}; --any picks the lowest in-range ask (HEAD), tie on latency; no order book. Per-call deals are final at once. Observe-only default; per-offer enforce. Accept: unit tests overlap/no overlap/cap/line/--any/both modes. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
