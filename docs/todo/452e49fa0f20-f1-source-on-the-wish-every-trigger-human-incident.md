---
id: 452e49fa0f20
kind: feature
title: 'F1 Source on the wish: every trigger (human, incident, feed, schedule) enters the one shaping workflow with provenance and fenced text'
seq: 814
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T23:22:56.224058Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

Sprint 730 rescope (operator 2026-11-26): the field loop is the existing shaping workflow with a different source. Add Source{Kind: human|incident|feed|schedule, Ref} to shape.Wish (yoke/pkg/shape/service.go:81-93) and the candidate record. Tracking accepts feed origins (shape/tracking.go:89-90 refuses any origin other than empty or 'shape'). One fence helper that escapes the closing marker, used by the wish brief (shape/helpers.go:98-115) and the repair brief (webconsole/shaped_repair.go:141-154, unfenced today). Unit tests: fence survives a closing marker in the text; a feed-origin todo can be wished. Plan: docs/sprint-730-master-execution-plan.md. Code inspected at yoke 257ce147. No coding until the operator says so.
