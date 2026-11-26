---
id: d379a8098c56
kind: feature
title: 'S7 conform lint: flag undemonstrated requirements, formats without examples, outputs without open/closed markers'
seq: 775
status: todo
priority: p0
labels:
    - conform
created: 2026-11-26T05:01:34.089803Z
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
---

A small conform subcommand over CONTRACT.md + features.yaml + the examples dir. It must flag G1-G3 on form spec v1 and be clean on v2. Unit tests with fixtures.

Plan: umbrella docs/plan-spec2src-calibration.md (read the gap catalogue G1-G7 and the soundness criteria first). Operator review + decisions D1-D3 before start.

Scope widened 2026-11-25 (operator goal c): S7 is the shapeware spec checker/validator. Static: criteria 1-3 (prose features without acceptance lines, declared formats without a worked example, outputs without an open/closed marker, --json outputs missing an always-present key). Dynamic: reuse conform cert/mutate on the reference plus a hidden-case independence check (each case alone in a fresh HOME; the hidden dir is passed in by the grader). Acceptance: flags G1-G3 on form spec v1, clean on v2; unit tests with fixtures.
