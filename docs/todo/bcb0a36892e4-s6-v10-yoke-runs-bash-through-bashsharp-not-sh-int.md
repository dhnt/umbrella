---
id: bcb0a36892e4
kind: refactor
title: 'S6 V10: yoke runs Bash# through bashsharp, not sh internals'
seq: 29
status: todo
priority: p2
labels:
    - layer-separation
created: 2026-11-06T21:04:32.191013Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Problem: yoke/pkg/dag/interp_bashpp.go drives syntax.LangBashPP and polyglot directly through sh. Change: route through bashsharp or an injected runner (pattern: yoke/pkg/skills WithBashSharpRunner). Exit: yoke imports no sh/lower, sh/gosource or sh/polyglot directly; yoke tests green. Plan: docs/plan-s575-master-execution.md
