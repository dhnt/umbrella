---
id: bac372b79573
kind: requirement
title: P1 Reconcile self-shaping baseline and carried qualification
seq: 131
status: wontfix
priority: p0
labels:
    - shaping
    - dogfood
    - shelved
created: 2026-11-11T20:10:50.260346Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
closed: 2026-11-19T14:21:27.007269Z
---

Depends on P0. Inventory source-backed registration, reserved report-only fallback, installed release metadata, managed source, side-slot routing, skill/script identity, receipts and promotion paths. Compare source against shipped/installable behavior; report differences rather than assuming help text is proof. Link Sprint 579 H5/H7 and carried dogfood 0a10de8d63f2 without duplicating or closing their criteria.

Acceptance: a baseline matrix names implemented, missing, unqualified and intentionally unsupported capabilities; exact commits/dependency pins and existing evidence are recorded. Frozen interpreter/POSIX/Bash# baseline is preserved. New failures require named tests, venue comparison and recorded root cause before a fix. No expensive suites on the development host.

## Review disposition: shelved (2026-11-19)

Operator requested review only and authorized closure or shelving of this roadmap. P1 already has a source baseline in the committed master plan (5b6f750f). Current review confirms lifecycle, promotion and retained recovery primitives exist. Shelve further reconciliation under this old roadmap. H5 5f0412e066bd, H7 515557c02505 and installed dogfood 0a10de8d63f2 remain open with original evidence/failures and criteria; no qualification credit is inferred.

Review source: Bashy e53cc3a395511e1a1e87874ecf74117368976434; Yoke f4a89e592ced1b7e715184f7833eef174e7215de. Inspection and existing committed evidence only; no fresh product tests. Closed as wontfix to shelve the remaining roadmap, not accepted as delivered. Original requirements preserved above. No coding, workers, installation, promotion, migration or release. Sprint 618 and carried qualification stories unchanged; official release/POSIX gates remain binding.
