---
id: 576df144ffa4
kind: feature
title: 'S1 CaaS catalog in appstore: caas/<kind>/ format with the first four roadmap entries'
seq: 847
status: todo
priority: p2
labels:
    - sgi
created: 2026-11-27T20:13:41.401756Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §3.5 catalog roadmap, §5 S1. dhnt/appstore gains caas/<kind>/: spec format + example spec, pinned verifier + thresholds, source refs, sample deliveries with verifier reports, price guide in credits, deal type. Entries in this sprint: video (V2's first verifier), transcribe, dub, spec2src (reuses conform). Later roadmap entries (extract, translate, then Tier 2/3) are filed one story each after the previous entry settles real deals. No hosted change. Accept: each entry validates and its sample delivery passes its verifier. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
