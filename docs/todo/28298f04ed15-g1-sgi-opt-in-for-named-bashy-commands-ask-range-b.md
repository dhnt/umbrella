---
id: 28298f04ed15
kind: feature
title: G1 SGI opt-in for named bashy commands (ask range, backing, subscription guard)
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

Plan: docs/sprint-740-master-execution-plan.md §1 differentiator, §3 opt-in, §5 G1. Operator 11-27: the unit is one call of a named bashy command: built-in, standard, example (shaped .bsh) or registered (custom or not), i.e. the 739 K2 offerable set; credits only. bashy offer NAME --sgi --ask MIN..MAX is refused unless NAME resolves to such a command (hint: bashy commands add); mutating/confirm commands stay refused remotely (Admit). The offer record gains backing (local|api-own-key|subscription), ask {min,max} credits per call (default fixed 1) and the source digest (see Verifiable source below). subscription backing is refused beyond the owner unless --force --reason (logged). Accept: unit tests for eligibility (built-in, example, registered, ad-hoc refused), record fields, guard and override logging.  Verifiable source (operator 11-27, plan §3): --sgi also requires a publishable source: built-in = bashy vcs.revision + verb (dirty or unknown revision refused); example = .bsh sha256; registered script = canonical record + script sha256; registered exec/download must declare source {url, rev} + the installed binary sha256, otherwise refused, naming the missing field. The offer app serves a read-only source route with the offer's audience; bashy offer source HOST NAME fetches it and recomputes the digest. Unit tests per kind. Code inspected 2026-11-27: yoke pkg/broker audit.go, peerlimit.go, broker.go (Pricer), pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go; depends on Sprint 739 K1-K4 (not yet built).
