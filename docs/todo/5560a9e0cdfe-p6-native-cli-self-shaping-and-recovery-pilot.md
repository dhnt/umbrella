---
id: 5560a9e0cdfe
kind: test
title: P6 Native CLI self-shaping and recovery pilot
seq: 136
status: todo
priority: p1
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:51.048656Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
---

Depends on P5. Deliver one real small bashy CLI improvement through source-backed self-shaping, side-slot preview/activation, real usage, submission and staging/upstream promotion. Coordinate existing H5/H7 and installed dogfood stories; preserve their original acceptance and unresolved failures.

Acceptance: full relevant lifecycle runs on native macOS, native Windows and Linux from one frozen source candidate; a second isolated installation receives the source change, verifies/builds locally, activates explicitly and rolls back exactly. Failed builds/tests and interrupted candidate runs never activate. A broken shaped CLI cannot disable retained status/undo/restore. Other installations remain unchanged. Existing web shaping regression remains green. Close carried stories only against their full original criteria. Then make shaping mandatory for covered CLI changes.
