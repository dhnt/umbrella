---
id: 28298f04ed15
kind: feature
title: 'G1 SGI opt-in by the fleet partition: typed tool definition, ask and unit, backing guard, verifiable source'
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

Plan: docs/sprint-740-master-execution-plan.md §3.1, §5 G1. bashy offer NAME --sgi [--ask MIN..MAX] [--unit U] [--token-cap N]. Eligibility is one test: NAME is a fleet model, a fleet tool or agent, or a registered command (the 739 K2 set); bash, Bash#, coreutils and bashy internal verbs are refused; mutating/confirm commands stay refused remotely. Three classes: model (per token), tool/command (per call or per output unit), agent (metered tokens under a declared token cap; an agent is sold only as a typed tool call). The offer must carry a typed tool definition (name, model-facing description, typed input schema from the record args, output shape, effects); an untyped argument list is refused naming what is missing. Definition digest (reuse the server_info tool-definition SHA-256) published beside the source digest. Source digest per kind: fleet record = canonical record sha256 (+ vcs.revision for a baseline record, dirty build refused); example = .bsh sha256; registered script = record + script sha256; exec/download must declare source {url, rev} + binary sha256, else refused naming the missing field. The offer app serves a read-only source route; bashy offer source HOST NAME recomputes the digests. Backing local|api-own-key|subscription; subscription refused beyond the owner unless --force --reason (logged). Accept: unit tests per class and kind, internal-verb and untyped refusals, guard and override. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
