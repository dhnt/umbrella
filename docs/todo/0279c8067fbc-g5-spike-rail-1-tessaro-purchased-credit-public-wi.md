---
id: 0279c8067fbc
kind: spike
title: 'G5 spike: Rail 1 Tessaro purchased-credit public wire contract (doc only)'
seq: 842
status: todo
priority: p2
labels:
    - sgi
created: 2026-11-27T19:27:46.327127Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: §3 Rail 1, §5 G5. Public wire only: 402 accepts entry + redemption header for closed-loop, non-transferable Tessaro credits spent on Tessaro capacity only. Private design kept outside this public repo. No code. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built).
