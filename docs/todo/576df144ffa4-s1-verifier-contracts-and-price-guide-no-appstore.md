---
id: 576df144ffa4
kind: feature
title: S1 verifier contracts and price guide (no appstore catalog)
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

Plan: docs/sprint-740-master-execution-plan.md §3.4, §3.5, §5 S1. No caas/<kind>/ catalog in appstore: the fleet record is the tool definition and the live listing (S2) is the catalog; the app catalog stays the free shelf. Each verifier (V2) ships with its contract, pinned thresholds, one passing sample delivery with its verifier report, and a price guide per unit in credits, published with the verifier source. In this sprint: video. Later kinds (dub, spec2src, extract, translate, then the rest of the backlog) are one story each, filed after the previous one settles real deals. No hosted change. Accept: the contract validates (conform spec check) and the sample delivery passes its verifier. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
