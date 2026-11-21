---
id: 49e058e0ae70
kind: refactor
title: S1 Remove Yoke reverse dependencies from the Classic product
seq: 24
status: wontfix
priority: p0
labels:
    - layer-separation
created: 2026-11-06T21:04:31.553118Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-21T12:17:46.533419Z
---

SUPERSEDED-IN-PART POINTER (2026-11-21, Sprint 677 manager muse-wonder-full per conductor claude+2): the cert-base / zero-yoke separation outcome of this S575 S1 is superseded by Sprint 677 P2 story 46743cdd0cda (bsh certified binary, zero yoke packages). Do NOT staff this story for that outcome; 677 P2 is the single tracked delivery. Close as superseded when 677 P2 is accepted.

Remove the Classic/cert-base Yoke reverse dependency while preserving released command behavior. The old dependency-free fleet leaf assumption is invalid: commands bind assetring/atlas/binmgr and provisioning. Use the reviewed minimum-change ownership design; no behavior deletion or allowlist growth. Current authoritative contract: docs/plan-s575-master-execution.md and docs/s575-separation-review.md. All gates through bashy dag in the official image; package moves and necessary structural wiring only.
