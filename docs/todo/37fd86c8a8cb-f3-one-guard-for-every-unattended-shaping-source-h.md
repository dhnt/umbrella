---
id: 37fd86c8a8cb
kind: feature
title: 'F3 One guard for every unattended shaping source: host bound wins, per-item bound, off switch, decision log, logged override'
seq: 795
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:45:54.901267Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: runtime errors and issue feeds drive the existing shaping workflow unattended'
---

Delivery rules (conductor 2026-11-26, Sprint 730 started):
- Work on current heads: yoke and bashy at origin/main (yoke 257ce147, bashy b5e679bb or later). Commit inside the submodule on a branch named s730-<story-short-id>; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #730, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: smallest change that meets this card; no new options beyond those named. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.

F3 scope (yoke, small bashy CLI wiring). Activation policy (operator): verified + replay pass -> auto-activate with the existing active/previous rollback; owner notified, can undo. Do not change that behaviour; bound and log it.
1. Host bound wins: shaped.json repair.max_attempts may only lower the host bound (--repair-max-attempts / default), never raise it or set unlimited (webconsole/shaped_repair_limit.go:32-40).
2. Per-item wall-time bound for an incident's whole repair (host option, default 60m), on top of the 20m per attempt.
3. One host off switch for unattended shaping: a marker file under the bashy state dir, toggled by `bashy shape auto off|on|status`. When off, incident capture still records but starts no repair, and shape-feed --apply (F2) files nothing; a running repair stops before its next attempt.
4. One append-only decision log (JSONL in the bashy state dir): one line per trigger, attempt, verdict, activation, refusal, with app, source, ref, result, time. `bashy shape auto log` prints it.
5. Override: `--override --reason TEXT` on `bashy shape auto on` lets one run exceed the host bound; the reason is logged (pattern weave/sprint_lease_token.go:110-125).
Tests: host bound wins over a larger shaped.json value and over "unlimited"; off switch blocks a new repair and stops a running one before the next attempt; each decision writes one log line; an override without --reason is refused.

F3. Applies to every unattended source, incident repair included. The host bound wins over shaped.json repair.max_attempts (shaped_repair_limit.go:32-40); a bound on attempts and wall time per item; one off switch that stops new triggers and a running loop; one append-only decision log line per trigger, attempt, verdict and activation; --override --reason, logged (pattern weave/sprint_lease_token.go:110-125). Activation policy (operator 2026-11-26): verified + replay pass -> auto-activate with the existing active/previous rollback, notify the owner, owner can undo; the same rule for every unattended source. Not in MVP: spend cap, critical enforcement in code, candidate.bsh no-arg digest gap (own todo). Depends on F1. Checks: unit tests that the host bound wins, the off switch stops a running loop, and an override is logged.

Plan: docs/sprint-730-master-execution-plan.md (rescoped 2026-11-26, operator ruling: the field loop is the existing shaping workflow with a different source). Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.

--- Earlier card text (kept; code facts still hold, remedies superseded) ---

Before L4 runs unattended: a bound on effort per issue (time and attempts); work only under the installed effect cap; no change to critical features, the trusted core or contract.bsh; every action and decision logged; one switch that turns the loop off; the owner's approval before a change is kept; an explicit, logged override path. Inspect the existing @guard, effect cap and shape verifier code first and state what already enforces each point. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.

Review (2026-11-26, code re-read at bashy 8e051472 and yoke bbe744c9): what enforces each point today.
- Owner approval before a change is kept: NOT enforced on two existing routes. A passing incident repair is activated and released automatically (yoke/pkg/webconsole/shaped_repair.go:197-201, :311-314), and the skill adapt loop writes its overlay by itself. Only shape wish then approve, and the work-copy route, leave the decision to the owner. shape approve checks only that the caller is the activation principal (shape/service.go:779-795), so an agent running as the owner can approve. The loop needs an identity that cannot approve.
- Effort bound: partly. Attempts default to 2, but the app's shaped.json repair.max_attempts overrides the host flag and may be 'unlimited' (shaped_repair_limit.go:32-40). Time is 20 minutes per attempt and unbounded per incident (shaped_repair.go:84-87). There is no spend cap (chat/delegate_guard.go:63-66). The host's bound must win, and a bound per issue is new.
- Effect cap: enforced on the verify route. A candidate claiming a wider cap fails, an empty cap is refused, and checks are frozen from the base and run contained under it (shape/verify/verify.go:266-283). It does not constrain the agent's own session.
- Protected files: partly. candidate.bsh diff-protects checks, contract.bsh, dag.md, shaped.json, go.mod, go.sum and server, and requires features.yaml to only add lines (:41-53). Gap: run with no arguments it checks the clone's server against the clone's own digest (candidate.bsh:9-17), so editing server/ and the digest together passes. Registered apps have no protected paths on the console route (webconsole/shaped.go:145-148).
- Critical features: not enforced anywhere. critical is data in features.yaml only; no code and no lint reads it (see L2).
- Logging: records exist in pieces (candidate records, incident attempts, sealed evidence, the version line, execlog). There is no single decision log for a loop.
- Off switch: none global. An empty --shape-agent disables new requests, --repair-max-attempts 0 records only but shaped.json overrides it, and bashy schedule disable stops one job.
- Override path: none for shaping. The pattern to copy is the sprint verbs' --override with a required --reason, logged (weave/sprint_lease_token.go:110-125).
- @guard is a Bash# function decorator that caps the effects of what a call dispatches (bashy/internal/agentos/decorators.go:238-251). It is not a loop guard.
- Added scope: issue text is untrusted. The wish brief fences the request between markers but nothing escapes a closing marker inside the text (shape/helpers.go:98-115), and the repair brief inserts the incident message unfenced (shaped_repair.go:139-154).
- Stays p0 and before L4. Larger than first filed: mostly yoke, some bashy.
Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.
