---
id: 1cd249d81ed1
kind: test
title: S0c Layer ratchet for cmd/coreutils (child of S0 72c55602dd2e)
seq: 34
status: done
priority: p0
labels:
    - layer-separation
    - release
created: 2026-11-06T22:10:46.110973Z
assignee: agy-gemini3.8-flash
sprint: 580
sprint_id: 0cae3983-9725-5e31-b45d-3585e97e00de
sprint_title: Bashy checkpoint and release candidate v1.0.0-rc.25
closed: 2026-11-07T01:43:16.271275Z
closed_by: claude-opus5.5-s580
---

Split from S0 72c55602dd2e so each repo has one claimant. New cmd/coreutils test: ban yoke, bashsharp, sh/{polyglot,gosource,lower,grammar}; allowlist today's offenders (polyglot) until S4 6e4bb2e13140; shrink-only check; mutation proof. GOWORK=off. Plan: docs/plan-s575-master-execution.md
