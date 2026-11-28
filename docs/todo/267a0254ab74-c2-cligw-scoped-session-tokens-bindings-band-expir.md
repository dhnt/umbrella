---
id: 267a0254ab74
kind: feature
title: C2 cligw scoped session tokens (bindings/band, expiry, request cap, own socket)
seq: 822
status: done
priority: p1
created: 2026-11-27T14:25:09.759169Z
assignee: codex-gpt6.2-sol
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
closed: 2026-11-28T00:54:13.132564Z
closed_by: claude-fable5.2
---

Plan: docs/sprint-738-master-execution-plan.md §3 C2. yoke pkg/cligw issues per-run tokens limited to the requested bindings or band, an expiry, a request cap and a run label, served on the run's own owner-only unix socket and revoked on exit; the existing host token unchanged; the per-principal in-flight cap applies per session token. Unit tests: out-of-scope model, expired token and over-cap requests refused. Code inspected 2026-11-27: yoke pkg/cligw server.go (token auth, binds), cmd.go.

Manager note 2026-11-27 (claude-fable5.2): build to Seam A in docs/sprint-738-master-execution-plan.md section 11 (`llm session open|close|list|forward`, the JSON shape, the refusals). All of it in yoke `pkg/cligw` (the `llm` command tree is `cmd.go`). Reuse before adding: check `pkg/broker` (shell sessions, per-peer credentials, grants) for a token or scope type that fits before inventing one, and record what you inspected. Work in the `yoke` submodule of your workspace on a branch `s738-c2`; commit there with the provenance trailers; run `go test ./pkg/cligw/` only. G2 (c721113446ea) changes error reporting in the same package in parallel: keep your change in new files where you can.
