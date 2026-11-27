---
id: fce48cc11515
kind: doc
title: L0 Decide the spec format points the field loop depends on
seq: 812
status: wontfix
priority: p0
labels:
    - shapeware
created: 2026-11-26T21:51:05.94751Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Shapeware spec method: collect improvements from the builds (notepad is the test case), then one more round'
closed: 2026-11-27T22:53:04.174163Z
---

Problem: L1, L2 and L4 each assume answers the format does not give. Without them the runbook and the lint would be written against guesses, and Sprint 734 would settle the same points separately.
Behavior: the owner decides, and docs/shapeware-spec-v0.md is amended, on six points.
1. Where a bug's failing example lives. Under a verified feature in features.yaml it prints FAIL and the release class becomes blocked (spec section 12 rule 1); in CONTRACT.md it makes the reference non-certifiable (see L6). Options: a tbd entry tied to the known issue, or a new marker.
2. A field linking a known issue to its example. Section 4.2 has none.
3. Who wins when contract and reference disagree, and how the difference is recorded. Open from Sprint 726 (four points in notepad) and listed again in Sprint 734 item 2.
4. Which hidden cases stay or are rewritten when the spec version changes. The standard has no rule; nearest text is workflow-standard.md:453-454.
5. What marks a spec as published, so that 'a published known issue needs an expiry date' can be checked. No key exists today.
6. Whether a tbd feature must have an acceptance line. Section 11 (:269) and the current lint (conform/spec/check.go:79) both allow none.
Also: the one canonical place for known issues. Section 4.2 says the SKILL.md body; notepad duplicates them in CONTRACT.md.
Verification: the amended sections are reviewed by the owner; form and notepad specs still pass conform spec check.

Triage (2026-11-26, review): p0, no dependencies, first. L1, L2 and L6 start after it. Decided once here and cited by Sprint 734. No coding until the operator says so (2026-11-26).

Moved from Sprint 730 to Sprint 734 on 2026-11-26: operator KISS/MVP rescope of 730 (the field loop reuses the existing shaping workflow; spec-method items belong to 734). See docs/sprint-730-master-execution-plan.md.
