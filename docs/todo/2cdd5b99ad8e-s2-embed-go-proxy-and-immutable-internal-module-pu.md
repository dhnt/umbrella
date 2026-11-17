---
id: 2cdd5b99ad8e
kind: feature
title: S2 Embed Go proxy and immutable internal module publication
seq: 405
status: todo
priority: p0
created: 2026-11-17T18:00:04.520408Z
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Depends on S1. Reuse goproxy handler/fetcher, golang.org/x/mod packaging and Athens mechanisms where needed. Persist exact Loom source before publication; immutable module/version/hash mapping. Archive eviction retains reconstructible inputs; regenerate once and verify original hashes. Acceptance: separate consumer builds from proxy with empty Go caches, removed ZIP regenerated identically, overwrite refused, concurrent regeneration and missing-input failures tested.
