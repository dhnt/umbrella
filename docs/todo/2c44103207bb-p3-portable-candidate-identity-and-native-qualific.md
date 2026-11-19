---
id: 2c44103207bb
kind: feature
title: P3 Portable candidate identity and native qualification evidence
seq: 133
status: wontfix
priority: p1
labels:
    - shaping
    - dogfood
    - shelved
created: 2026-11-11T20:10:50.573797Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
closed: 2026-11-19T14:21:27.647195Z
---

Depends on P1; integrates with P2. Extend existing evidence/submission records rather than creating a second lifecycle or backlog. Versioned qualification manifest binds candidate/source commits across repositories, dependency pins, verifier policy identity, toolchain, per-platform artifact hashes, test receipts and opaque installation IDs. Public evidence uses host roles. Evidence must travel with submissions, not depend on an inaccessible local evidence_path.

Minimum upstream qualification: same frozen source candidate on native macOS, Windows and Linux, plus a second installation proving exchange and rollback. Per-platform binary hashes differ. Cross-build and WSL do not replace native Windows evidence. Reuse receipts only for unchanged relevant inputs; mutation of candidate, dependencies or verifier invalidates affected qualification.

Expose structured qualification/blocker output through existing shape surfaces; preserve 0/3/1 promotion conventions. Validate evidence in trusted service before promotion, not only wrapper code.

Acceptance: missing, tampered, stale or mismatched receipts block promotion; duplicate receipts cannot satisfy distinct installations/platforms; inaccessible evidence reports blocked; evidence reuse names exact inputs and raw logs. Tests exercise service-level bypass attempts.

## Review disposition: shelved (2026-11-19)

Operator requested review only and authorized closure or shelving of this roadmap. P3 portable three-native-OS/second-installation qualification is not proven. Current yoke promotion records still carry evidence_path; the proposed pkg/shape/qualify package was not found in the inspected tree. Shelve the portable bundle/verifier extension; preserve exact-candidate and no-false-pass requirements in existing qualification work. No cross-build or WSL result counted as native qualification.

Review source: Bashy e53cc3a395511e1a1e87874ecf74117368976434; Yoke f4a89e592ced1b7e715184f7833eef174e7215de. Inspection and existing committed evidence only; no fresh product tests. Closed as wontfix to shelve the remaining roadmap, not accepted as delivered. Original requirements preserved above. No coding, workers, installation, promotion, migration or release. Sprint 618 and carried qualification stories unchanged; official release/POSIX gates remain binding.
