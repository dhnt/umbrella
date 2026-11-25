---
id: ceefd8477e5a
kind: task
title: 'Dogfood: convert all bashy examples to shapeware across vendor models (after spec v1.0 draft + form PoC)'
seq: 755
status: todo
priority: p2
labels:
    - software-shaping
created: 2026-11-25T16:08:17.164892Z
---

Operator proposal 2026-11-25 (Sprint 712, record D22; docs/sprint-712-recommendation.md section 10).
When: after the shapeware spec reaches a v1.0 draft and the form proof of concept (Sprint 721) is done.
What: convert every example under bashy/examples/ to a shapeware folder per the spec (type line and run block, dag.md lifecycle with source/build/test/install/run, features.yaml, checks with candidate.bsh, known issues). Assign conversions across models from different vendors (codex, agy/Gemini, muse, GLM, Claude) so the spec is tested by many readers, not one.
Per example, two steps with two DIFFERENT vendors (operator, 2026-11-25):
  a) Convert: one model converts the example per the spec (lint must pass).
  b) Run: a model from another vendor, with no shapeware context and no hints, uses the converted example cold: make sure it works (build, test), use it, hit a known issue, build a tbd feature in a work copy graded by candidate.bsh, report. It lists every point where it had to guess.
  Rotate the pairs so every vendor converts and every vendor runs; the converter never runs its own conversion.
  Every guess in (b) is a spec issue, or a conversion defect if the spec was clear and (a) did not follow it.
Iterate until the run is immediate (operator, 2026-11-25). A conversion is DONE only when, in one round, EVERY vendor's model at the chosen band (default L3; one model per vendor: codex, agy/Gemini, muse, GLM, Claude) runs it cold and succeeds on the first attempt:
  - the lint passes on the converted folder;
  - no FAIL, no forbidden move, no probing outside the run block and the agent card;
  - zero points listed as "had to guess".
If any runner guesses or fails: classify it (spec issue, or conversion defect), fix it where it lives (the spec or the conversion), and rerun the WHOLE matrix, not only the runner that failed.
Bound: at most 3 rounds per example; then stop, record the open guesses as spec issues and escalate to the operator (bounded effort; never retry until green).
Raise the band later: L3 is the campaign's floor. D13's target (USING an app works for low-end local models, L1) is checked by the P2 low-end pack, not by this campaign.
Output: every point where a converting model guessed or got stuck becomes a spec issue. The spec moves from the v1.0 draft to v1.0. Absorbs bashy ae527623 (per-category pilots).
Plan as its own sprint, reviewed with the operator before it starts (it is a mass change: a written plan with scope, owners, budget and rollback first).
