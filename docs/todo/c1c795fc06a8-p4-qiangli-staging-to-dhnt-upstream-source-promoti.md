---
id: c1c795fc06a8
kind: feature
title: P4 qiangli staging to dhnt upstream source promotion
seq: 134
status: todo
priority: p1
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:50.728864Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
---

Depends on P1/P3; setup uses P2. Inventory bashy and only the dependencies needed for its builds and pilots before creating corresponding dhnt upstream repositories. Keep history and qiangli staging repositories; do not transfer or change bashsharp/* repositories. Preserve Go module paths and qualified commits at current module URLs. Existing org tier means staging; upstream means dhnt. Distinguish review repository from writable fork/branch destination.

Local approved candidates may enter staging intake before full fleet qualification. Freeze integrated staging source; require P3 qualification before upstream proposal/merge eligibility. Keep local activation, staging intake, staging qualification and upstream integration distinct. Patch equivalence deduplicates changes but is not test evidence. Conflicting local changes become separate candidates; never auto-merge them. Publish dependencies before consumers; umbrella pins last.

Acceptance: scratch remote round trip proves outgoing/push/incoming/pull, exact proposal identity, portable evidence, idempotent retry, branch mutation refusal and conflict handling. Upstream promotion fails closed without staging qualification even when invoked directly. Rebasing/integration that changes inputs requires requalification. No automatic installation or release.
