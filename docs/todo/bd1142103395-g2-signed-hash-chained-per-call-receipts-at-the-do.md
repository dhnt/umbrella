---
id: bd1142103395
kind: feature
title: G2 signed hash-chained per-call receipts at the door
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

Plan: §3 Rail 0, §5 G2. Per served SGI call: receipt {command, command record digest, caller principal, price, time, cost_usd|unpriced (informational), prev sha256} signed with the door host ed25519 key under tag dhnt-receipt-v1 (feed sign.go encoding); appended to a per-door chain; returned in a response header; caller bashy stores it. Accept: unit tests sign/verify; chain break and tamper detected.  Verifiable source: the receipt carries the source digest; bashy remote --verify checks the source before the first call and on digest change; bashy credits verify checks receipt digests against fetched source; a mismatch is refused before the call and flagged after. Code inspected 2026-11-27: yoke pkg/broker audit.go, peerlimit.go, broker.go (Pricer), pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go; depends on Sprint 739 K1-K4 (not yet built).
