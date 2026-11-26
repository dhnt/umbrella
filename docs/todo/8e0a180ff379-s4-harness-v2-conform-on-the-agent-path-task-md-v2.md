---
id: 8e0a180ff379
kind: task
title: 'S4 harness v2: conform on the agent PATH, TASK.md v2, protocol v2, smoke'
seq: 772
status: done
priority: p0
labels:
    - conform
created: 2026-11-26T05:01:33.252121Z
assignee: claude-opus5.5
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
closed: 2026-11-26T09:32:52.10393Z
closed_by: claude-opus5.5
---

A standalone conform binary (v0.1.1+, cmd/conform, no bashy) on the agent PATH, guard-allowed; TASK.md v2 adds that you may run conform run CONTRACT.md against your build; re-freeze the adapter cache; write protocol v2 (start/step ladder, minimal-tier rule, conditions) fixed before runs; one unscored smoke with a non-subject agent through the full chain.

Plan: umbrella docs/plan-spec2src-calibration.md (read the gap catalogue G1-G7 and the soundness criteria first). Operator review + decisions D1-D3 before start.
