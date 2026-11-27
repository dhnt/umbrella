---
id: b7be89cac2d2
kind: feature
title: 'L6 conform cert: an assertion that must fail on the old reference and pass on the fixed one'
seq: 813
status: wontfix
priority: p1
labels:
    - shapeware
created: 2026-11-26T21:51:06.213284Z
sprint: 734
sprint_id: c0fe136f-1cdc-5b2b-bc4f-cec6d3f9680d
sprint_title: 'Shapeware spec method: collect improvements from the builds (notepad is the test case), then one more round'
closed: 2026-11-27T22:53:01.317903Z
---

Problem: the operator ruling for bug fixes (2026-11-26) reverses today's reference rule: the new assertion must FAIL on the old reference and PASS on the fixed one. conform cannot express that. cert.Baseline marks any assertion that is not PASS in every reference run as noisy (conform/cert/baseline.go:65-73); Grade turns a candidate FAIL on a noisy assertion into INCONCLUSIVE (:105-111); any INCONCLUSIVE makes the whole verdict INCONCLUSIVE (verdict.go:27-46) and cert exits 1 (cli/cert.go:195). The reference also cannot certify, since zero noisy assertions are required, and conform mutate refuses a baseline that is not all PASS (cert/mutate.go:61-71).
Behavior: a cert mode that takes an old reference and a fixed reference and requires the marked assertions to fail on the old one and pass on the fixed one, without marking them noisy for the rest of the run. Fixtures and tests in conform. No change to the default mode.
Verification: unit tests in conform/cert for the mode, including an assertion that passes on both (refused) and one that fails on both (refused); form KI-1 as the worked case.

Triage (2026-11-26, review): p1, depends on L0 point 1 (where the failing example lives). Needed before L4 can judge a bug fix. Sprint 734 names the same rule (def02641e735:59); this story owns the change. conform HEAD 5148116 equals the bashy pin. No coding until the operator says so (2026-11-26).

Moved from Sprint 730 to Sprint 734 on 2026-11-26: operator KISS/MVP rescope of 730 (the field loop reuses the existing shaping workflow; spec-method items belong to 734). See docs/sprint-730-master-execution-plan.md.
