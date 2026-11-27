---
id: 753b6ddd91be
kind: feature
title: S3 store web page over the store CLI operations
seq: 849
status: todo
priority: p3
labels:
    - sgi
created: 2026-11-27T20:13:42.684752Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.4, §5 S3. A thin web UI with the same operations as bashy store (list, show, order); every action calls a CLI op (UI to CLI parity). Accept: page actions map 1:1 to CLI ops; the e2e lane drives one order through the page. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
