---
id: 82b3d9e2523a
kind: test
title: 'G4 acceptance: A/O/C sandbox e2e for SGI credits'
seq: 841
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:45.682322Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: §5 G4. test-group-shaping-e2e lane, cloudboxfake, fake transcribe provider, gate host, e2e minutes budget: C offers transcribe --sgi; O uses it; receipts verify on both sides and balances agree; past the line would-refuse (observe) then 402 (enforced); subscription-backed offer to a member refused; tampered receipt fails verify. Code inspected 2026-11-27: yoke pkg/broker audit.go (Record, auditLog), peerlimit.go (peerMeter admit/observe, seedPeerMeter, admitPeer), broker.go (Pricer, llmprice), pkg/feed sign.go key.go (ed25519 canonical signing); depends on Sprint 739 K1-K4 (not yet built). Bidding checks: a bid below the ask gets a 402 counter and a re-bid in range runs at the clearing price; with two offerers --any picks the lower ask.
