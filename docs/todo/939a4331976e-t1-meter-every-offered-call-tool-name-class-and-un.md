---
id: 939a4331976e
kind: feature
title: 'T1 meter every offered call: tool name, class and units on the door run record, caller copy, usage rollups (no price)'
seq: 851
status: todo
priority: p1
created: 2026-11-27T23:59:34.387547Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 T1. Every offered call is metered, for every caller (owner, peer:NAME, member:EMAIL) and every class, with no price involved.

Gap (code inspected): the door run record (yoke pkg/broker audit.go:22-62) has principal, class (interactive/batch), path, model, tokens, wall time and cost_usd, but no tool name, no offer class and no unit count; the usage rollup (usage.go:22-44, verb usage) is per principal only; the peer meter counts tokens and cost only (peerlimit.go:213-240), so a command run counts as nothing; the caller keeps no record (toolcmd Result has no usage, toolcmd.go:72-104).

Change: (1) the run record gains tool (the offered name: the K1 parsed slash name, the model for inference, the agent name), offer class (model|tool|agent), unit, units and definition digest. Call = 1; tokens from the usage the door already parses; one declared output unit read from the result (seconds for transcribe first). (2) The door returns the usage to the caller (response header for inference, the result envelope for tool and agent runs) and the caller appends it to its own usage file. (3) Rollups: bashy offer usage [--by member|tool] on the offerer and bashy remote usage [--by host|tool] on the caller, both with --json, reusing RollupUsage. (4) --limit counts in the offer's unit (calls for a tool), through the existing peer meter and the 429 refusal.

This record is what Sprint 740 G2 signs as a receipt and G3 prices; keep it price-free and add no signing here.

Accept: unit tests: record fields per class; a command run counts 1 call; caller and door copies agree; rollups by member and by tool; a per-call limit refuses with 429; older audit lines without the new fields still roll up. Not in MVP: metering folder reads; output units beyond seconds; cost or price fields beyond the existing cost_usd.

Code inspected 2026-11-27: yoke pkg/broker audit.go usage.go usagecmd.go peerlimit.go broker.go:497-530, pkg/cligw server.go:1246-1270 (usage.jsonl), pkg/toolcmd toolcmd.go. Depends on K1, K2, K4. Filed at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Tags (operator 2026-11-27, plan §3.1): the rollups take --tag, resolved from the definition by its digest; tags are not copied onto each run record.

Revised 2026-11-27 night (operator: everything is a tool call as far as agents are concerned; the name is TaaS). Folder offers are metered like any other: files-NAME calls and link streams count the call and bytes served; bytes joins call, token and seconds as a supported unit. 'Not in MVP: metering folder reads' is withdrawn.

Seam (conductor, 2026-11-27; base = yoke main with K4). With K4 there is one call path, POST /offers/NAME (plus the model offer's inference routes and the files-NAME byte route), so the meter lives there:
- pkg/broker audit.go Record gains tool, offer_class, unit, units, digest (Bytes from F1 stays and feeds units for files-NAME). Set them in the /offers/NAME handler and the files byte route for every principal (owner, peer:, member:); inference through a model offer sets tool=llm, class=model, unit=token, units=input+output tokens the door already parses.
- Units: call -> 1; token -> usage from the M1 envelopes (llm call, delegate); seconds -> a numeric `seconds` field in the tool's JSON result when the definition's unit is seconds; bytes -> bytes served.
- The /offers/NAME response carries usage {tool, class, unit, units, digest}; pkg/offer remote appends it to <bashy-home>/remote-usage.jsonl on the caller.
- bashy offer usage [--by member|tool] [--tag T] [--json] on the offerer (reuse RollupUsage over the audit records) and bashy remote usage [--by host|tool] [--tag T] [--json] on the caller. --tag resolves tags from the definition by digest (offer records on the offerer; mounted/remote records on the caller).
- --limit on an offer counts in its unit through the existing peer meter (429).
- No price field. Older audit lines without the new fields still roll up.
- Tests: GOWORK=off go test ./pkg/broker/ ./pkg/offer/.

Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-t1, based on current origin main (`git fetch origin && git checkout -B s739-t1 origin/main` first: the workspace pin is older). Change only what this story needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests only: `cd yoke && GOWORK=off go test ./pkg/broker/ ./pkg/offer/`. No full suites, no e2e, no network, no podman.
- Commit in yoke with trailers: Sprint: #739 / Story: #851 / Story-ID: 939a4331976e / Agent: codex-gpt6.2-astra. Do not push main, do not bump any pin, do not edit bashy (the conductor mounts the verbs).
- Finish by appending a "Delivery" paragraph to docs/todo/939a4331976e-t1-meter-every-offered-call-tool-name-class-and-un.md (files changed, test command and result) and commit it in the umbrella workspace with the same trailers.
- Budget about 45 minutes. If blocked, write the blocker in the story, commit, and stop.

Conductor note: run the FULL test of every package you touch (no -run filter) before committing; K2 regressed four tests a filtered run missed. Base on yoke main after K4 (fetch origin first).
