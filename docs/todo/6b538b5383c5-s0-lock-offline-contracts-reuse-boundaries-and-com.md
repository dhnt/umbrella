---
id: 6b538b5383c5
kind: requirement
title: S0 Lock offline contracts, reuse boundaries and compatibility evidence
seq: 403
status: done
priority: p0
created: 2026-11-17T18:00:04.220647Z
assignee: agy-gemini4-carbon-s654
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
closed: 2026-11-26T10:04:57.463512Z
closed_by: agy-gemini4-carbon-s654
---

Define profile-v1, manifest-v1, publication identity, lease/GC authority and offline-floor semantics before implementation. Reuse ORAS Go, existing bbolt, goproxy and selected Athens MIT code/tests. Record upstream revisions, attribution and dependency licenses. Agree coexistence with Sprint 653 official build-image/native runner gates. Acceptance: documented interfaces and failure semantics; no bespoke blob store/downloader; baseline lane inputs and current failures recorded.
