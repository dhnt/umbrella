---
id: 82b3d9e2523a
kind: test
title: 'G4 acceptance: A/O/C sandbox e2e for SGI (per call, verified delivery, ledger, store)'
seq: 841
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T19:27:45.682322Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: opt-in shared agentic tools for credits (group mutual credit on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §7 (the full list). cloudboxfake with the ledger log and listing, fake providers and accounts, no LLM for A/O, gate host, e2e minutes budget. C offers one of each class (model llm per token, registered transcribe per call, one fleet agent under a token cap) and the example video (verified delivery). O's agent finds them with bashy store search --json (typed definition, digests, ask, track record); bashy store add mounts transcribe and it shows in bashy mcp tools with a typed schema; a call through the mounted tool is metered and settles; the agent call stops at its token cap and is charged for what was used. Verified delivery: pass settles and cannot be rejected, fail released, redelivery settles, waiver logged, same verdict both sides. Per-unit 402 counter and --any. Ledger: both-signed checkpoint as mirrored record entries, proofs verify, a rewritten leaf or a forked tree head is caught by bashy credits audit, a new invitee at limit 0 refused past its line, a one-sided checkpoint disputed. Refusals: ad-hoc name, internal verb, offer without a typed definition, opaque exec, subscription to a member, tampered receipt, changed script, changed definition digest on a mounted tool, a call past the agent budget (would-refuse observing, refused enforcing, allowed with the logged owner override). A with purchased fake credits orders a cloudbox offer. The owner page (S3) is not part of this run. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cli_commands.go baseline/tools/ cloudboxfake/, pkg/llmprice, pkg/binmgr sigstore.go, yoke mcp direct.go policy.go, bashy internal/agentos mcp.go mcp_registered.go, bashy examples (service-door, oss-rods, fleet/tools), conform/ README + contract runner, appstore/; depends on Sprint 739 K1-K4 (not yet built). Revised at the sprint review 2026-11-27 (operator: agents are the buyers and sellers; the fleet partition; pay per use; an agent is a smart tool).
