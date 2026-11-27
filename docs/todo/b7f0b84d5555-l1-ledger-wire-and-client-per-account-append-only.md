---
id: b7f0b84d5555
kind: feature
title: 'L1 ledger wire and client: per-account append-only credit records in a transparency log'
seq: 846
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T20:13:40.760965Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.3, §5 L1. Public wire only (the hosted implementation is tracked privately): both-signed netting checkpoint submit (per counterparty per period, default daily) written as mirrored double entries in each account's append-only, hash-chained record {account, seq, delta, counterparty, type, period, counts, receipt-chain head, prev}; all records as leaves of one Merkle log; signed tree head; inclusion and consistency proofs; position query; track record. bashy credits checkpoint|record|audit (proof checks, tree-head gossip with counterparties); door checks the buyer position (limit 0 for new accounts) and the seller line; one-sided checkpoint = disputed. Purchased credit is a separate balance type. cloudboxfake gets a Merkle log. Accept: unit tests for proofs, double entry, disputed, rewrite/fork detection. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
