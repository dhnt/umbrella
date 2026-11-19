---
id: c1c795fc06a8
kind: feature
title: P4 qiangli staging to dhnt upstream source promotion
seq: 134
status: wontfix
priority: p1
labels:
    - shaping
    - dogfood
    - shelved
created: 2026-11-11T20:10:50.728864Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
closed: 2026-11-19T14:21:27.982875Z
---

Depends on P1/P3; setup uses P2. Inventory bashy and only the dependencies needed for its builds and pilots before creating corresponding dhnt upstream repositories. Keep history and qiangli staging repositories; do not transfer or change bashsharp/* repositories. Preserve Go module paths and qualified commits at current module URLs. Existing org tier means staging; upstream means dhnt. Distinguish review repository from writable fork/branch destination.

Local approved candidates may enter staging intake before full fleet qualification. Freeze integrated staging source; require P3 qualification before upstream proposal/merge eligibility. Keep local activation, staging intake, staging qualification and upstream integration distinct. Patch equivalence deduplicates changes but is not test evidence. Conflicting local changes become separate candidates; never auto-merge them. Publish dependencies before consumers; umbrella pins last.

Acceptance: scratch remote round trip proves outgoing/push/incoming/pull, exact proposal identity, portable evidence, idempotent retry, branch mutation refusal and conflict handling. Upstream promotion fails closed without staging qualification even when invoked directly. Rebasing/integration that changes inputs requires requalification. No automatic installation or release.

## Review disposition: shelved (2026-11-19)

Operator requested review only and authorized closure or shelving of this roadmap. P4 outgoing/push/incoming/pull and proposal-branch mutation refusal already exist (accepted Sprint 580 promotion story a130d972faf3; yoke/pkg/shape/promotion.go). Inspected Push checks complete submission/evidence and exact proposal branch, but does not establish the proposed staging-presence plus portable three-OS qualification gate. Shelve dhnt repository topology/branch-protection rollout and stronger promotion enforcement; no repository migration, branch-protection verification or full ladder acceptance claimed.

Review source: Bashy e53cc3a395511e1a1e87874ecf74117368976434; Yoke f4a89e592ced1b7e715184f7833eef174e7215de. Inspection and existing committed evidence only; no fresh product tests. Closed as wontfix to shelve the remaining roadmap, not accepted as delivered. Original requirements preserved above. No coding, workers, installation, promotion, migration or release. Sprint 618 and carried qualification stories unchanged; official release/POSIX gates remain binding.
