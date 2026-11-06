---
id: 0ad75a1179c2
kind: refactor
title: 'Phase 2: Bash# engine bashpp_* files out of sh/interp and sh/syntax'
seq: 31
status: todo
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:59.390981Z
sprint: 581
sprint_id: cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7
sprint_title: 'Layer separation phase 2: Bash# engine out of sh/interp and sh/syntax'
---

Seed story for Sprint 581 (deferred from Sprint 575; depends on 575 S5 68dba07e6977). Scope: 208 sh/interp + 26 sh/syntax bashpp_* files behind an extension seam (~204 unexported Runner members per bashsharp/docs/seam.md), implementation in bashsharp; agentic constructs out of the engine (bashpp_agentic, polyglot Export.Agentic); set -o bashsharp/bashpp and shopt bashpp gated at runner construction; sh/moreinterp/coreutils u-root duplicate; grep/find --agentic and time --budget/--todo to yoke wrappers or documented opt-in; sh/execbudget neutral naming; github.com/dhnt/dhnt skills dependency vs bashy/dhnt. Design spike first; split into stories at orientation. Plan: docs/plan-s575-master-execution.md (Follow-up sprints).
