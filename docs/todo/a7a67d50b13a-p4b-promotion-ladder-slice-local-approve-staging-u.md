---
id: a7a67d50b13a
kind: requirement
title: 'P4b Promotion ladder slice: local approve -> staging -> upstream PR, fails closed without evidence'
seq: 309
status: wontfix
priority: p2
labels:
    - software-shaping
    - shelved
created: 2026-11-15T02:03:41.700698Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
closed: 2026-11-19T14:21:28.947622Z
---

The MVP slice of Sprint 617 P4 (c1c795fc06a8), which keeps bashy's own repo ownership move and the fleet qualification work. Scoped here to the website repo only.

Scope: the three steps stay distinct and recorded — a member's local approval, the owner's staging intake, the upstream pull request — and promotion to upstream REFUSES without the recorded verification evidence for that exact candidate, even when invoked directly. Patch equivalence deduplicates, it is never evidence. A conflicting change becomes its own candidate; nothing auto-merges.

Acceptance: a scratch-remote round trip proves the ladder, the refusal without evidence, an idempotent retry, and refusal to mutate someone else's branch. Out of scope: moving repo ownership to dhnt, bashy self-shaping installations, fleet qualification.

## Review disposition: shelved (2026-11-19)

Operator requested review only and authorized closure or shelving of this roadmap. P4b is website-only, distinct from moving bashy repository ownership. It overlaps implemented promotion commands and exact proposal-branch refusal in yoke/pkg/shape/promotion.go, but this review found no complete scratch-remote ladder/refusal/idempotence evidence for its full criteria. Shelve that separate qualification slice without claiming its complete gate passed or adding a new dependency to 669.

Review source: Bashy e53cc3a395511e1a1e87874ecf74117368976434; Yoke f4a89e592ced1b7e715184f7833eef174e7215de. Inspection and existing committed evidence only; no fresh product tests. Closed as wontfix to shelve the remaining roadmap, not accepted as delivered. Original requirements preserved above. No coding, workers, installation, promotion, migration or release. Sprint 618 and carried qualification stories unchanged; official release/POSIX gates remain binding.
