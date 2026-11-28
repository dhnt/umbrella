---
id: 6599dbdddc76
kind: test
title: 'K5 acceptance: A/O/C sandbox e2e for commands and folders as a service (cloudboxfake, fake providers)'
seq: 833
status: todo
priority: p1
created: 2026-11-27T15:34:19.86828Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K5. Extend bashy dag test-group-shaping-e2e with cloudboxfake fake accounts and a fake transcribe provider; no LLM for A or O. C offers llm + transcribe; O shapes and A's wish runs on C's LLM; O puts in.wav in <bashy-home>/shared/in/ (shared with C's circle) and runs bashy remote C -- transcribe bashy://O/files-in/in.wav and gets an artifact URI it streams with Range; A's agent reads a folder C shared in place; O also shares an outside path (--path) that A reads; sharing HOME without --force refused; non-member, path escape (.., symlink out) and non-offered command refused; unshare 403, limit 429; O offers to C (symmetry); the same audience rule admits a member's UI app use and their agent's runs. Gate host only, minutes budget, no paid provider. Code inspected 2026-11-27 (revised after review): bashy tests/group-shaping-e2e README.md sandbox.py; yoke pkg/fleet/cloudboxfake cloudboxfake.go:1336-1396.

Review 2026-11-27 additions (plan §3.1): C offers one of each class (llm, transcribe, one fleet agent with a token cap), each as a typed tool call. O's agent runs bashy remote add C transcribe and the tool shows in bashy mcp tools with a typed schema; a call through the mounted tool works. The agent call stops at its token cap. After the runs, bashy offer usage --json on C and bashy remote usage --json on O show the same units per tool (tokens for llm and the agent, calls and seconds for transcribe) for owner, peer and member calls; no record carries a price. Refused: offering an internal verb; an untyped offer; a mounted tool whose definition digest changed. Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Revised 2026-11-27 night (operator: everything is a tool call as far as agents are concerned; the name is TaaS). Add: O's agent mounts a folder C shared (bashy remote add C files-NAME), it shows in bashy mcp tools with the typed schema, and lists through it; folder reads appear in bashy offer usage on C and bashy remote usage on O in bytes, and the two agree.
