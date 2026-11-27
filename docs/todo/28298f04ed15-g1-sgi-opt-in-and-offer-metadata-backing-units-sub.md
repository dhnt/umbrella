---
id: 28298f04ed15
kind: feature
title: G1 SGI opt-in and offer metadata (backing, units, subscription guard)
seq: 838
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:43.704376Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3 opt-in, §5 G1. bashy offer NAME --sgi adds SGI metering to a 739 offer; offer record gains backing (local|api-own-key|subscription) and units (call|wall-second|token). subscription backing refused for any audience beyond the owner unless --force --reason (logged in the record). Accept: unit tests for record fields and guard incl. override logging. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built). Bidding (operator 11-27): --ask MIN..MAX credits per unit stored as ask {min,max} on the offer record (default fixed 1).
