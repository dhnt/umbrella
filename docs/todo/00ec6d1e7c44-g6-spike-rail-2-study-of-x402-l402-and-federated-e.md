---
id: 00ec6d1e7c44
kind: spike
title: 'G6 spike: Rail 2 study of x402, L402 and federated ecash with a legal checklist (doc only)'
seq: 843
status: todo
priority: p3
labels:
    - sgi
created: 2026-11-27T19:27:46.980948Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: §3 Rail 2, §5 G6. Evaluate x402, L402, federated Cashu/Fedimint behind the same 402 body for a future public pool; legal checklist (money transmission, KYC, sales tax, vendor terms); recorded decision. No code. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built).
