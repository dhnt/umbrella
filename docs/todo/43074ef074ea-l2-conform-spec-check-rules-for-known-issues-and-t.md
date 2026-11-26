---
id: 43074ef074ea
kind: feature
title: L2 conform spec check rules for known issues and tbd features
seq: 792
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:53.898548Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Shapeware spec method: collect improvements from the builds (notepad is the test case), then one more round'
---

Compile-step rules, with fixtures and tests: a known issue names an existing feature id (or none), has a valid status and, when published, an expiry date; a bug's failing example exists in features.yaml or the contract; a tbd feature has at least one acceptance line; a critical feature has no open or workaround issue. Decide per rule whether it is an error or a warning. Code inspection of conform spec/check.go before writing the rules. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.

Review (2026-11-26, code re-read at conform 5148116, which equals the bashy pin):
- conform spec check never reads SKILL.md. Check(dir) reads CONTRACT.md, features.yaml, examples/ and dag.md (spec/check.go:47-210), so known issues are not parsed at all. The first work item is a SKILL.md input and a known-issue parser; no fixture under spec/testdata (form-spec-v1 to v4) contains a SKILL.md.
- parseFeatures keeps only id, status and an acceptance count (check.go:225-229, :288-303). The critical rule needs it to read critical.
- Rule by rule: known issue names an existing feature id, valid status: absent, new. Expiry when published: absent, and nothing marks a spec as published (L0 point 5). A bug's failing example exists: absent, and no field links a known issue to an example (L0 point 2). Critical feature with an open or workaround issue: absent in conform; it is release-class rule 4 (spec section 12, :288) and exists only as draft text in Appendix B.
- The tbd rule reverses today's lint. tbd features are explicitly exempt from needing acceptance (check.go:79; check_test.go:108-110; TestRuleByExample uses one at :328), and spec section 11 (:269) allows none. As an error it breaks those tests; make it a warning unless L0 point 6 changes the format.
- Canonical copy: notepad keeps known issues in both SKILL.md (:120-132) and CONTRACT.md (:357-370). The lint reads the copy L0 names and warns on the other.
- Proposed severities, for the owner to confirm: unknown feature id, invalid status, critical feature with an open or workaround issue: error. Missing expiry: warning until a published marker exists. tbd without acceptance: warning.
- Pattern to follow: the lifecycle lint story (conform/docs/todo/cbbb535b5818): rule ids, severity, a new fixture form-spec-vN, one TestRule per rule on writeSpecDir (check_test.go:68-94), README.md:54-71, gofmt and deps_test clean, run on a gate lane.
- Depends on L0 fce48cc11515. Sprint 734 adds other rules to the same check.go and README (items 1, 2, 8); run the two in sequence, not in parallel.
No coding until the operator says so (2026-11-26).

Moved from Sprint 730 to Sprint 734 on 2026-11-26: operator KISS/MVP rescope of 730 (the field loop reuses the existing shaping workflow; spec-method items belong to 734). See docs/sprint-730-master-execution-plan.md.
