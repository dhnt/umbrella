---
id: e171fa2b0e20
kind: feature
title: 'V1 verified delivery: hold, deliver, buyer verify, final or release'
seq: 844
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T20:13:39.20294Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.2, §5 V1. The offer pins verifier V@DIGEST (a bashy-provided command with published source, never seller-written), thresholds, spec format and redeliver N. Order = hold receipt at the cleared price; the seller delivers the artifact URI + its own report; the buyer's bashy runs the same pinned verifier automatically; pass = final (no rejection), fail = release (no charge, redeliver up to N), waiver logged, buyer silent = the seller's pass settles after a timeout. A verdict mismatch between sides is a verifier defect, filed. Accept: unit tests per transition. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
