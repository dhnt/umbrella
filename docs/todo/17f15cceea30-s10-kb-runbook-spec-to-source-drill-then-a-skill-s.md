---
id: 17f15cceea30
kind: doc
title: S10 kb runbook spec-to-source-drill, then a skill-script
seq: 778
status: done
priority: p1
labels:
    - conform
created: 2026-11-26T05:03:49.673883Z
assignee: claude-opus5.5
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
closed: 2026-11-26T11:19:19.331287Z
closed_by: claude-opus5.5
---

Operator goal (2026-11-25): capture the drill as a bashy kb runbook, then a skill-script. Cover: the protocol fixed before runs, the harness (agent-bench spec2src), the arm traps (BENCH_*_KEYCHAIN, the frozen BASHY_ADAPTER_CACHE, OPENCODE_DISABLE_AUTOUPDATE), the sandbox guard, grading only on the lane (netns, xdg-open stub, one grade at a time), batches and gates (venue vs agent classification), the judge audit (render failing pages before trusting a UI fail), the ladder and the report. The skill-script automates probe -> batch -> gate -> regrade -> table. Runbook first; the skill-script is registered via bashy-defaults.

Plan: umbrella docs/plan-spec2src-calibration.md. Operator review + decisions D1-D4 before start.
