---
id: 37fd86c8a8cb
kind: feature
title: 'L5 guard for unattended shaping: bounds, cap, log, off switch, owner approval'
seq: 795
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:45:54.901267Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

Before L4 runs unattended: a bound on effort per issue (time and attempts); work only under the installed effect cap; no change to critical features, the trusted core or contract.bsh; every action and decision logged; one switch that turns the loop off; the owner's approval before a change is kept; an explicit, logged override path. Inspect the existing @guard, effect cap and shape verifier code first and state what already enforces each point. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.
