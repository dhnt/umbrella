---
id: 8de958ff15b8
kind: requirement
title: P0 Establish baseline and settle self-service contracts
seq: 370
status: todo
priority: p0
created: 2026-11-16T03:22:37.943934Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

Before implementation: reconcile yoke source divergence without discarding local work; record candidate source and dependency SHAs. Spec exists at yoke commit 1016574d, docs/plan-llm-key-self-service.md. Resolve signed CLI identity transport, peer naming versus current 63-character validator (which excludes @), error taxonomy, owner deny/revoke/limit precedence, local/vault storage failure behavior, and the spec --print exception versus the card's no-output rule. Preserve no credential output. Use collision-safe identity mapping with required peer:self-<email> usage attribution. Existing owner-minted peers coexist; no automatic migration. Exit: explicit public contracts and candidate baseline recorded.
