---
id: 43074ef074ea
kind: feature
title: L2 conform spec check rules for known issues and tbd features
seq: 792
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:53.898548Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

Compile-step rules, with fixtures and tests: a known issue names an existing feature id (or none), has a valid status and, when published, an expiry date; a bug's failing example exists in features.yaml or the contract; a tbd feature has at least one acceptance line; a critical feature has no open or workaround issue. Decide per rule whether it is an error or a warning. Code inspection of conform spec/check.go before writing the rules. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.
