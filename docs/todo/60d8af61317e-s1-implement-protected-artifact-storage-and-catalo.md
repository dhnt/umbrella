---
id: 60d8af61317e
kind: feature
title: S1 Implement protected artifact storage and catalog service
seq: 404
status: todo
priority: p0
created: 2026-11-17T18:00:04.358233Z
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Depends on S0. Use ORAS filesystem CAS and existing bbolt for references, protected roots, dependency edges, leases and regeneration metadata. Single service writer; durable publication; recover interrupted operations before GC. Extend existing prune contract, enforcing protected dependency closure and active leases. Acceptance: concurrent put/read/prune, crash recovery, corruption, disk-full and Windows open-file tests; never delete protected data; add permissive license credits.
