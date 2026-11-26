---
id: 6e6632d80537
kind: spike
title: 'S9 judge-band study: L4 vs L5 evaluators on the Sprint 722 evidence pack'
seq: 777
status: todo
priority: p1
labels:
    - conform
created: 2026-11-26T05:03:49.385918Z
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
---

Operator goal d (2026-11-25). Build a conclusion-free evidence pack from Sprint 722: the spec v1 files, the 15 snapshots' raw per-assertion grades, the rendered failing pages, the session logs and the conform source. Fixed prompt: classify every non-pass as spec gap, agent defect or judge defect; name any judge defects with a repro; list the spec gaps. Evaluators: the latest L4 and L5 of two vendors (e.g. claude-sonnet5.5 vs opus5.5; codex gpt6.2-sol vs gpt6.2-astra), n=2 each. Reference set: this sprint's catalogue, frozen first, plus an independent second-L5 classification, with disagreements adjudicated. Score: label agreement, both known judge defects found (lone checkbox; yes/no select), the YAML cause split (no parser / partial parser / not YAML), no invented causes. Threshold D4 fixed before runs. Output: the lowest adequate evaluator band.

Plan: umbrella docs/plan-spec2src-calibration.md. Operator review + decisions D1-D4 before start.
