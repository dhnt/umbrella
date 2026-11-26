---
id: fa2cb2dd82a1
kind: task
title: 'L4 the loop on form: one bug and one tbd feature from feed or runtime failure to an offered, judged change'
seq: 794
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:54.568985Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

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
No coding until the operator says so (2026-11-26).
