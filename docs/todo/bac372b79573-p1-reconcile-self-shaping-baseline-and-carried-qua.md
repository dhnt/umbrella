---
id: bac372b79573
kind: requirement
title: P1 Reconcile self-shaping baseline and carried qualification
seq: 131
status: todo
priority: p0
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:50.260346Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
---

Depends on P0. Inventory source-backed registration, reserved report-only fallback, installed release metadata, managed source, side-slot routing, skill/script identity, receipts and promotion paths. Compare source against shipped/installable behavior; report differences rather than assuming help text is proof. Link Sprint 579 H5/H7 and carried dogfood 0a10de8d63f2 without duplicating or closing their criteria.

Acceptance: a baseline matrix names implemented, missing, unqualified and intentionally unsupported capabilities; exact commits/dependency pins and existing evidence are recorded. Frozen interpreter/POSIX/Bash# baseline is preserved. New failures require named tests, venue comparison and recorded root cause before a fix. No expensive suites on the development host.
