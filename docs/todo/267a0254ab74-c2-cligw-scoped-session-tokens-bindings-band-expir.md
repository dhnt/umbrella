---
id: 267a0254ab74
kind: feature
title: C2 cligw scoped session tokens (bindings/band, expiry, request cap, own socket)
seq: 822
status: todo
priority: p1
created: 2026-11-27T14:25:09.759169Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C2. yoke pkg/cligw issues per-run tokens limited to the requested bindings or band, an expiry, a request cap and a run label, served on the run's own owner-only unix socket and revoked on exit; the existing host token unchanged; the per-principal in-flight cap applies per session token. Unit tests: out-of-scope model, expired token and over-cap requests refused. Code inspected 2026-11-27: yoke pkg/cligw server.go (token auth, binds), cmd.go.
