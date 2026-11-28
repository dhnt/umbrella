---
id: bd1142103395
kind: feature
title: G2 signed hash-chained receipts (hold, final, release) and --verify
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

Plan: docs/sprint-740-master-execution-plan.md §3.3, §5 G2. Receipt kinds hold/final/release: {command, source digest, verifier digest, price, parties, time, prev}, signed with the door host ed25519 key under dhnt-receipt-v1 (feed sign.go encoding), chained per door, returned in a header, stored on the caller side. Receipts never go to cloudbox. bashy remote --verify checks the source before the first call and on digest change. Accept: unit tests sign/verify, chain break, tamper, digest change. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).

Sprint 739 review 2026-11-27 (operator: 739 is the whole base, 740 adds only the payment layer): the receipt body is the Sprint 739 T1 usage record (tool, class, unit, units, definition digest, both sides already hold it) plus price, source digest and verifier digest; G2 adds signing, chaining and hold/final/release, not a second meter.
