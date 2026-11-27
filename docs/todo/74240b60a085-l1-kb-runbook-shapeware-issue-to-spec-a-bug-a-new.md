---
id: 74240b60a085
kind: doc
title: 'L1 kb runbook shapeware-issue-to-spec: a bug, a new feature or a missing feature becomes a spec change'
seq: 791
status: wontfix
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:45:53.061634Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Shapeware spec method: collect improvements from the builds (notepad is the test case), then one more round'
closed: 2026-11-27T22:52:58.495356Z
---

Classify an incoming issue and write it into the spec. Bug: a known-issue entry (KI-n, status, feature, symptom -> action, retry, expiry, todo) plus an acceptance example that fails today. New feature: a tbd feature with id, intent, effort and acceptance lines. Missing or tbd feature someone needs: a Build request for the existing entry, not a new one. Anything the issue does not decide goes to the owner as an open question. Try it on form's real KI-1 and on its tbd feature group-required. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.

Review (2026-11-26, files re-read at bashy 8e051472 and conform 5148116):
- Depends on L0 fce48cc11515. The runbook cannot say where a bug's failing example goes until the format does: under a verified feature it prints FAIL and blocks the release class (spec section 12 rule 1), and section 4.2 has no field linking a known issue to its example.
- form KI-1 has no failing example today. submit-answers (features.yaml:12-17) has one acceptance line with no multi value, and CONTRACT.md has no multi answer assertion. Writing that example is the first worked case.
- The field list here omits cause: and forbidden:, both defined in section 4.2 (:105-110) and both used by form KI-1 (SKILL.md:142-147).
- Citation: section 7 is the effect cap. The checks contract (candidate.bsh, acceptance lines) is section 6 (:186-207); cite that as well.
- A third class exists: a tbd feature that resolves a known issue. notepad's self-contained-conversion (features.yaml:70-77) cites KI-2. The runbook needs that case.
- The Build request for group-required (form/features.yaml:40-49, effort 2, band L2, four acceptance lines) may change form.bsh only; server/, go.mod and go.sum are the digest-pinned core. Whether reordering is possible without the server is an open question for the owner, which is the runbook's own rule.
- Partial prior text to reuse, not repeat: shapeware-spec-from-app.md:46 (step 8), :56 (record the app's real behaviour and file the difference as a known issue), :66.
- Gates that govern a spec change: the owner reviews every spec change before it is built (workflow-standard.md:310-311); a shaping pass may not change existing assertions or checks (:56-57); only the owner promotes tbd to verified (:273).
- Semver: a known-issue change is a patch, a new feature is a minor (spec :247-250).
- More worked cases: notepad KI-1 and KI-2 (Sprint 734 items N8, N9).
- Shipping: write in the umbrella kb with bashy kb, then carry to bashy/kb/defaults as a generalized page and re-index (bashy/kb/defaults/README.md).
- Sprint 734 edits the neighbouring runbooks (def02641e735 items 1-6, 9, 10). This story owns the new page; do not run both sprints on the kb pages at once.
No coding until the operator says so (2026-11-26).

Moved from Sprint 730 to Sprint 734 on 2026-11-26: operator KISS/MVP rescope of 730 (the field loop reuses the existing shaping workflow; spec-method items belong to 734). See docs/sprint-730-master-execution-plan.md.
