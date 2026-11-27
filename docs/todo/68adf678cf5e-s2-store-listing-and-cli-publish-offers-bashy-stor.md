---
id: 68adf678cf5e
kind: feature
title: 'S2 store listing and CLI: publish offers, bashy store list/show/order'
seq: 848
status: todo
priority: p2
labels:
    - sgi
created: 2026-11-27T20:13:42.043741Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §5 S2. Public listing wire: an SGI offer publishes {command, kind, seller, ask range, verifier digest, source digest, deal type, audience}; cloudbox offers listed the same way; a member sees only listings of their relationships plus cloudbox. bashy store list [--kind K] | show ID | order ID --spec F --bid R (the V1 flow); each row shows the track record from the ledger (settled, verifier pass share, redeliveries, distinct counterparties); no written reviews. cloudboxfake listing. Accept: unit tests for audience filtering and track record. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
