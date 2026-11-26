---
id: 74240b60a085
kind: doc
title: 'L1 kb runbook shapeware-issue-to-spec: a bug, a new feature or a missing feature becomes a spec change'
seq: 791
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:45:53.061634Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

Classify an incoming issue and write it into the spec. Bug: a known-issue entry (KI-n, status, feature, symptom -> action, retry, expiry, todo) plus an acceptance example that fails today. New feature: a tbd feature with id, intent, effort and acceptance lines. Missing or tbd feature someone needs: a Build request for the existing entry, not a new one. Anything the issue does not decide goes to the owner as an open question. Try it on form's real KI-1 and on its tbd feature group-required. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.
