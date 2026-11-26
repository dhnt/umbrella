---
id: b258af984107
kind: test
title: 'S3 hidden cases v2 (private): independent cases, interaction on its own form'
seq: 771
status: done
priority: p0
labels:
    - conform
created: 2026-11-26T05:01:32.977189Z
assignee: claude-opus5.5
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
closed: 2026-11-26T09:19:38.561376Z
closed_by: claude-opus5.5
---

In dhnt/docs docs/conform/form-hidden-v2: each hidden case creates its own form (no cross-case state); the browser interaction uses a JSON form; one independent YAML case (block + flow lists). Controls: reference 3/3 through the full grader, null FAIL. Record digests in the protocol v2 before any run.

Plan: umbrella docs/plan-spec2src-calibration.md (read the gap catalogue G1-G7 and the soundness criteria first). Operator review + decisions D1-D3 before start.
