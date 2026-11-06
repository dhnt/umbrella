---
id: f88db041f744
kind: test
title: S0b Layer ratchet for sh/interp (child of S0 72c55602dd2e)
seq: 33
status: assigned
priority: p0
labels:
    - layer-separation
    - release
created: 2026-11-06T22:10:45.973141Z
assignee: opencode-glm-5.3
sprint: 580
sprint_id: 0cae3983-9725-5e31-b45d-3585e97e00de
sprint_title: Bashy checkpoint and release candidate v1.0.0-rc.25
---

Split from S0 72c55602dd2e so each repo has one claimant. Extend sh/interp/gosource_dependency_test.go: ban gosource/lower/grammar; allowlist polyglot until S5 68dba07e6977; shrink-only check; mutation proof. GOWORK=off. Plan: docs/plan-s575-master-execution.md
