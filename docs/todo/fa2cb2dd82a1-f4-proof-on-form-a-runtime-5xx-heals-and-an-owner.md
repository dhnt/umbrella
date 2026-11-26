---
id: fa2cb2dd82a1
kind: task
title: 'F4 Proof on form: a runtime 5xx heals and an owner-filed GitHub issue is shaped through the same workflow, once from bashy schedule'
seq: 794
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:54.568985Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: runtime errors and issue feeds drive the existing shaping workflow unattended'
---

F4 build notes (conductor 2026-11-26, at assignment):
- Base: bashy origin/main 9e516af8 or later, yoke 2b10346c or later. F3b (ab9cbdd6f838) runs in parallel and adds `bashy shape wish --source KIND:REF`, the off-switch/log on the wish path and shape-feed calling `shape approve`; write (b) and (c) against that interface, as specified on the F3b card.
- Location: bashy tests/field-loop-e2e/ (run.sh or run.py + README.md + fixtures), plus a dag.md target `test-field-loop-e2e` next to `test-group-shaping-e2e` (dag.md ~:291). Copy that harness's patterns (throwaway HOME, fake shaping agent, evidence path argument, fail-closed) instead of inventing new ones.
- Fakes only: a fake shaping agent that makes a deterministic fix, an issues file for `shape-feed --source file:...`, no network, no real GitHub, no browser (BROWSER=/usr/bin/true and no-op open/xdg-open on PATH). Finishes in a few minutes; waits are configurable.
- (a) injected 5xx on form -> incident repair heals -> activated -> `bashy shape auto log` shows trigger/attempt/verdict/activation -> previous revision restorable; (b) owner issue via shape-feed --apply -> todo (origin feed, reporter) -> wish -> approve -> activated; non-owner issue skipped; (c) the same feed from `bashy schedule` once; after `bashy shape auto off` a second run files nothing and the log shows the refusal.
- Do NOT run the e2e on the dev box. Syntax-check only (bash -n / python -m py_compile). The conductor runs it on the gate lane and sends back failures.

Delivery rules (conductor 2026-11-26, Sprint 730 started):
- Work on current heads: yoke and bashy at origin/main (yoke 257ce147, bashy b5e679bb or later). Commit inside the submodule on a branch named s730-<story-short-id>; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #730, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: smallest change that meets this card; no new options beyond those named. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.

F4 scope (after F1-F3 merge; conductor runs it on a claimed gate lane). Sandbox e2e with fakes, finishing in minutes: (a) form with an injected 5xx heals through console incident repair with a fake shaping agent, activates, and the previous revision is restorable; (b) shape-feed form --source file:issues.json --apply turns one owner issue into a todo and a wish that verifies and activates; a non-owner issue is skipped; (c) the same feed runs once from bashy schedule; after `bashy shape auto off` a second run files nothing; the decision log shows every step.

F4. On a claimed gate lane, sandbox e2e with fakes within the minutes budget: (a) an injected 5xx on form heals through the console incident path; (b) an issue the owner filed on GitHub goes feed -> todo -> shape wish -> verify -> activated or offered per the policy; (c) the feed runs once from bashy schedule and the off switch stops it. A failure leaves a known-issue note on the todo with what was tried. Evidence recorded once on the candidate. Depends on F1, F2, F3.

Plan: docs/sprint-730-master-execution-plan.md (rescoped 2026-11-26, operator ruling: the field loop is the existing shaping workflow with a different source). Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.

--- Earlier card text (kept; code facts still hold, remedies superseded) ---

An issue arrives from the L3 feed, or form's own check fails while it runs. An agent applies L1, builds in a work copy per the Build intent, and the installed folder's candidate.bsh and conform decide. A pass is offered to the owner, never self-approved; a failure leaves a known-issue entry with what was tried. Gate lane only for builds and tests. Reuse yoke todo 55730ebaf952 (failed trajectory to the repair loop) rather than a second trigger. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.

Review (2026-11-26, code re-read at bashy 8e051472 and yoke bbe744c9): two parts of this card do not match the code.
- 'Reuse yoke todo 55730ebaf952' depends on work that is not built: there is no skill repair command and no --episode flag. What exists, skill run --adapt --repair-agent (yoke/pkg/skills/adapt.go:196-238), writes its overlay without owner approval. Do not make this story wait on it and do not use it as the trigger.
- The one trigger that is built, the console incident path, makes a passing repair live with no owner step: verify, replay, then Activate and a patch release (yoke/pkg/webconsole/shaped_repair.go:197-201, :311-314). That contradicts 'offered, never self-approved'.
- Entry to use: shape wish APP --todo ID. The candidate stops at verified and shape approve is a separate owner step (bashy/internal/agentos/shape.go:56-61). shape incident is the wrong entry: it auto-activates and is refused for non-web kinds.
- Runtime failure: form is a web shaped app with a declared server, so console-served 5xx and start failures are captured as incidents with a signature (shaped_incident_capture.go:129-170). Run capture in record-only mode and let the loop turn the incident into a wish. A form command or a dag.md test run from a terminal creates no incident; that hook does not exist and is out of scope here.
- Build intent is a runbook, not a command (spec section 4.3, :128-146). checks/candidate.bsh is the only implementation; the work copy and the offer are done by hand. Sprints 726 and 731 ran spec-to-source drills, not this.
- 'Gate lane only for builds and tests' conflicts with the console route, which builds and tests on the console host. The loop uses the work-copy route graded on a claimed lane (bashy claim NAME --intent, which an unattended process can take).
- shape wish records --reproduction, --expected and --evidence only for the reserved bashy target (yoke/pkg/shape/service.go:88-90). For form the issue text reaches the brief only as the request.
- Judging a bug fix needs L6 b7be89cac2d2. The worked cases are form KI-1 (bug) and group-required (tbd feature).
- Depends on L0, L1, L3, L5 and L6. Citation: section 7 is the effect cap; the checks contract is section 6.
Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.
