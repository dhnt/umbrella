---
id: 159ec80840e8
kind: feature
title: 'S2 form spec v2: fix G1-G7 in bashy examples/desk/form'
seq: 770
status: done
priority: p0
labels:
    - conform
created: 2026-11-26T05:01:32.70144Z
assignee: claude-opus5.5
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: a sound shapeware spec and the minimal model per vendor'
closed: 2026-11-26T05:56:19.386184Z
closed_by: claude-opus5.5
---

Add examples/contact.yaml (block + flow lists) with an acceptance line; state the --fields rule (projection, every verb, schema_version always kept); mark create outputs open with '...' per D2 and keep F-02 closed with its reason; describe both definition shapes (--def FILE {title,fields}, --definition JSON [fields]); state the UI rules (programmatic labels, one control per field, required, distinct option labels); add a page-interaction acceptance line (fill, submit, then CLI reads answered); split SKILL.md into a behaviour spec and reference operation. The reference must re-certify on the gate lane: conform cert x3 PASS, 0 noisy, mutate all killed.

Plan: umbrella docs/plan-spec2src-calibration.md (read the gap catalogue G1-G7 and the soundness criteria first). Operator review + decisions D1-D3 before start.
