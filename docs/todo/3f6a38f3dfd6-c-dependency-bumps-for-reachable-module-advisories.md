---
id: 3f6a38f3dfd6
kind: chore
title: 'C: Dependency bumps for reachable module advisories + fresh govulncheck, retire/shrink vuln override'
seq: 586
status: todo
priority: p0
created: 2026-11-21T08:29:57.498182Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Phase 0C, AFTER A merges. Operator: do a clean job whatever it takes now. Repos: bashy, outpost, yoke. Bump the reachable module advisories from rc.39 ledger (x/net, x/crypto, grpc, excelize, klauspost/compress, otel exporters, quic-go, pion, moby/buildkit, runc, fulcio, frp) to fixed versions - minimal, no unrelated upgrades. Fresh govulncheck per scope WITH yoke external/ollama+podman sources fetched. Retire the d91599c2 override (bashy 7ddc31c9) if clean, else shrink to exact remaining reachable ids each justified here. Acceptance: govulncheck output per scope + override diff recorded; targeted builds/tests green; root cause before fixing any red the bumps expose.
