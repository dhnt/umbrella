---
id: d8b3b7233444
kind: feature
title: G3 bashy credits, owner credit lines and the 402 refusal (observe-only default)
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

Plan: §3 Rail 0, §5 G3. bashy credits balance|history|verify|export from held receipts; owner credit line per circle or member; past the line the door returns 402 bashy-credit-402-v1 {offer, owed, line, accepts:[group-credit]}; default observe mode records would-refuse only; per-offer enforce switch. 429 stays for rate limits. Accept: unit tests both modes. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built). Bidding (operator 11-27, plan §3 Simple bidding): ask moves inside the offer range with load; taker --bid MIN..MAX (X-Bashy-Bid); admit on overlap, clearing price max(ask, take MIN) capped at min(offer MAX, take MAX), recorded in the receipt (price, units, charged); no match = 402 counter {ask, range}; bashy remote --any picks the lowest in-range ask via HEAD; no order book. Unit tests: overlap, no overlap, cap, --any tie-break.
