---
id: 2ebc1c65c259
kind: feature
title: D1 own-device line remote with compare-and-swap push
seq: 615
status: wontfix
priority: p1
labels:
    - shaping
created: 2026-11-21T21:59:32.879674Z
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
closed: 2026-11-24T18:15:53.874639Z
---

Problem: promotion tiers are org/upstream only (bashy/internal/agentos/shape_promotion.go:46); one owner cannot sync their shaping line between their own devices. Behavior: add an own-device tier; push/pull the same principal's refs/shaping/<p>/line to the line authority (satellite, else primary outpost). Push is compare-and-swap on the line ref; a stale base is refused with a clear pull-first result (--json too). Reuse yoke/pkg/shape/promotion.go Incoming/Pull/Outgoing/Push. Verification: unit tests for accept, stale-refuse, and two-device race. Plan: docs/sprint-689-master-execution-plan.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: covered by the single-venue model. The shaping line lives on the app's host; a second device of the same owner shapes it remotely (site MCP owner tools, gateway run shape), the same path as a granted member. No per-device line, push or offline merge. The rebase-and-re-verify rule is carried into Sprint 706 R5. Retired as wontfix, not delivered.
