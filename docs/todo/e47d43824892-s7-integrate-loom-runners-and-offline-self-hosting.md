---
id: e47d43824892
kind: feature
title: S7 Integrate Loom runners and offline self-hosting release gates
seq: 410
status: todo
priority: p1
created: 2026-11-17T18:00:05.327286Z
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Depends on S2, S3 and S4; coordinate Sprint 653. Preserve source commits referenced by published artifacts and local workflow helpers. Use exact commits and official build-image/native-platform locks. Gate previous version builds candidate, candidate rebuilds itself, successive candidate-built binaries byte-identical with empty disposable caches and Internet disabled. Acceptance: native target-OS lanes and canonical relevant regressions pass; evidence names candidate, inputs and fixture/test identities.
