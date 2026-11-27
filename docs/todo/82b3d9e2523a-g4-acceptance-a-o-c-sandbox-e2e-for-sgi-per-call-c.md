---
id: 82b3d9e2523a
kind: test
title: 'G4 acceptance: A/O/C sandbox e2e for SGI per-call credits'
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

Plan: §5 G4. test-group-shaping-e2e lane, cloudboxfake, fake transcribe provider, gate host, e2e minutes budget. C registers transcribe (bashy commands add) and offers it --sgi --ask; C also offers the built-in llm --sgi. O calls both. Receipts verify on both sides and balances agree. Past the line: would-refuse (observe), then 402 (enforced). A bid below the ask gets a 402 counter, and a re-bid in range runs at the clearing price. With two offerers, --any picks the lower ask. --sgi on an ad-hoc name is refused. A subscription-backed offer to a member is refused. A tampered receipt fails verify.  Source checks: an opaque exec record is refused for --sgi; bashy offer source matches the digest; after C changes the transcribe script, --verify refuses the next call until re-verified. Code inspected 2026-11-27: yoke pkg/broker audit.go, peerlimit.go, broker.go (Pricer), pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go; depends on Sprint 739 K1-K4 (not yet built).
