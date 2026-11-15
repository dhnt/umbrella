---
id: a7a67d50b13a
kind: requirement
title: 'P4b Promotion ladder slice: local approve -> staging -> upstream PR, fails closed without evidence'
seq: 309
status: todo
priority: p2
labels:
    - software-shaping
created: 2026-11-15T02:03:41.700698Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
---

The MVP slice of Sprint 617 P4 (c1c795fc06a8), which keeps bashy's own repo ownership move and the fleet qualification work. Scoped here to the website repo only.

Scope: the three steps stay distinct and recorded — a member's local approval, the owner's staging intake, the upstream pull request — and promotion to upstream REFUSES without the recorded verification evidence for that exact candidate, even when invoked directly. Patch equivalence deduplicates, it is never evidence. A conflicting change becomes its own candidate; nothing auto-merges.

Acceptance: a scratch-remote round trip proves the ladder, the refusal without evidence, an idempotent retry, and refusal to mutate someone else's branch. Out of scope: moving repo ownership to dhnt, bashy self-shaping installations, fleet qualification.
