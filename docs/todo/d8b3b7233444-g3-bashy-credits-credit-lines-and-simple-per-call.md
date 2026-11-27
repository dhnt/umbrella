---
id: d8b3b7233444
kind: feature
title: G3 bashy credits, credit lines and simple per-call bidding (402 counter, observe-only default)
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

Plan: §3 Rail 0 + Simple bidding, §5 G3. bashy credits balance|history|verify|export from held receipts; owner credit line (credits owed) per circle or member. Bidding per call: the ask moves inside the offer range with load; taker --bid MIN..MAX (X-Bashy-Bid); admit on overlap at clearing price max(ask, take MIN) capped at min(offer MAX, take MAX), recorded in the receipt; the price is known before the run (no token/second metering); no match = 402 bashy-credit-402-v1 counter {ask, range}; past the line = 402 {owed, line}; bashy remote --any NAME picks the lowest in-range ask across offerers of the same registered command (HEAD), tie on latency; no order book. Default observe mode records would-refuse only; per-offer enforce switch; 429 stays for rate limits. Accept: unit tests for overlap, no overlap, cap, line, --any tie-break, both modes. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer), pkg/feed sign.go key.go (ed25519 canonical signing), pkg/fleet commands.go command_schema.go (registered command records); depends on Sprint 739 K1-K4 (not yet built).
