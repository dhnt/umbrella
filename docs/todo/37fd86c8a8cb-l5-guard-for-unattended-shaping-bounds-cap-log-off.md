---
id: 37fd86c8a8cb
kind: feature
title: 'L5 guard for unattended shaping: bounds, cap, log, off switch, owner approval'
seq: 795
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:45:54.901267Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

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
No coding until the operator says so (2026-11-26).
