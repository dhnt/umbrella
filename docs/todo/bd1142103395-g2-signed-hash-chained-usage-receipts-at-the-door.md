---
id: bd1142103395
kind: feature
title: G2 signed hash-chained usage receipts at the door
seq: 839
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:44.361064Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: §3 Rail 0, §5 G2. Per served SGI run: receipt {offer, principal, units, cost_usd|unpriced, time, prev sha256} signed with the door host ed25519 key under tag dhnt-receipt-v1 (feed sign.go encoding); appended to a per-door chain; returned in a response header; caller bashy stores it. Accept: unit tests sign/verify, chain break and tamper detected. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built).
