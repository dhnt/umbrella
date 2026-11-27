---
id: 28298f04ed15
kind: feature
title: G1 SGI opt-in for named bashy commands (ask range, backing guard, verifiable source)
seq: 838
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:43.704376Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.1, §5 G1. bashy offer NAME --sgi [--ask MIN..MAX]: NAME must be a named bashy command (built-in, standard, example or registered; the 739 K2 set) whose source can be published; mutating/confirm commands stay refused remotely. Source digest per kind: built-in = vcs.revision + verb (dirty build refused); example = .bsh sha256; registered script = record + script sha256; exec/download must declare source {url, rev} + binary sha256, else refused naming the missing field. The offer app serves a read-only source route; bashy offer source HOST NAME recomputes the digest. Backing local|api-own-key|subscription; subscription refused beyond the owner unless --force --reason (logged). Accept: unit tests per kind, guard and override. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
