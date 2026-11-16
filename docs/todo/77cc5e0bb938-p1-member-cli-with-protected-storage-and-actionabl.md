---
id: 77cc5e0bb938
kind: feature
title: P1 Member CLI with protected storage and actionable refusals
seq: 374
status: todo
priority: p1
created: 2026-11-16T03:22:38.585617Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

Depends on agreed transport/endpoint contract; integrate after mint endpoint. Add llm key --satellite NAME [--door HOST] using the signed-in Cloudbox session without credential argv. Protect destination identity so authentication is not forwarded to an untrusted --door or redirect. Store owner-only locally and handle signed-in vault storage; define recovery if remote rotation succeeds but local/vault write fails. --env emits only client settings referencing a protected file. No --print exception. Distinct one-line errors identify fixes for login, membership, pending invitation, wrong circle, self-service off and unreachable door. Test file permissions, secret-free stdout/stderr, storage failure, and actual client file-reference compatibility.
