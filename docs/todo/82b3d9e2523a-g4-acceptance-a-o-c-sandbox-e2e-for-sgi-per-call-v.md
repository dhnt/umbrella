---
id: 82b3d9e2523a
kind: test
title: 'G4 acceptance: A/O/C sandbox e2e for SGI (per call, verified delivery, ledger, store)'
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

Plan: docs/sprint-740-master-execution-plan.md §7 (the full list). cloudboxfake with the ledger log and listing, fake providers and accounts, no LLM for A/O, gate host, e2e minutes budget: store discovery; verified-delivery pass settles and cannot be rejected, fail released, redelivery settles, waiver logged, same verdict both sides; per-call 402 counter and --any; both-signed checkpoint as mirrored record entries, proofs verify, a rewritten leaf or a forked tree head is caught by bashy credits audit, a new invitee at limit 0 refused past its line, a one-sided checkpoint disputed; refusals (ad-hoc name, opaque exec, subscription to a member, tampered receipt, changed script); A with purchased fake credits orders a cloudbox offer. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
