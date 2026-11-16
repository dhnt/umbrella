---
id: 6149c764499d
kind: feature
title: P1 Secure member minting and rotation endpoint
seq: 373
status: todo
priority: p1
created: 2026-11-16T03:22:38.421423Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

Depends on owner policy and signed identity proof. Add POST /v1/peer/self using verified caller claims, active mutual membership and allowed-circle authorization. Reuse MemberAuthorizer and member-bound credentials; recheck membership per inference. Atomically mint/rotate with limits applied in the same transaction. Serialize peer-store mutations against concurrent mints and owner edits; current read-modify-write and fixed temporary filename need protection. Preserve owner deny/revoke/limit policy and usage budgets across rotation; define explicit recovery semantics for owner revocation. Nothing mutates on refusal. Test name collisions, concurrent rotation, stale/forged identity, membership outage/cache freshness, old-key 401, and owner restrictions. Never log or output raw credentials.
