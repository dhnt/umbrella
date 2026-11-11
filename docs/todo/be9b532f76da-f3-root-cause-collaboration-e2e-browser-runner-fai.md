---
id: be9b532f76da
kind: bug
title: F3 Root-cause collaboration-e2e browser runner failures (brainstorm, whiteboard)
seq: 124
status: todo
priority: p2
labels:
    - collaboration-followup
created: 2026-11-11T09:56:31.263532Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Pre-existing (bashy todo b29cbe96b2d3): on the Linux test host with node 22, Playwright 1.65, Chromium 1254 both runners fail identically at bashy 10d55bf3 and b7d70e4c (brainstorm: #createSession never actionable; whiteboard: flaky between browser-test.mjs:53 and :66). Root cause before fix: find the last green venue/versions (docs/plan-collaboration-e2e.md), reproduce, bisect venue vs code, record cause, fix where it lives. Add node >= 20 to the gate preflight.
