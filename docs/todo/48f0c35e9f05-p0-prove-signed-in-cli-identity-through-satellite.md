---
id: 48f0c35e9f05
kind: spike
title: P0 Prove signed-in CLI identity through satellite to mint route
seq: 371
status: todo
priority: p0
created: 2026-11-16T03:22:38.090094Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

Depends on baseline contracts. Prove a bashy login session reaches the door through a test satellite with authenticated caller identity and a verifiable fresh signature. Prefer a separate llm-key app entry with require_login and trust_cloud_identity, restricted to POST /v1/peer/self; preserve existing Bearer inference entry. Reject forged, stale and direct untrusted headers. Verify non-browser identity forwarding and distinct anonymous/pending/non-member/wrong-circle refusal feasibility. If unavailable, record the Cloudbox public wire-contract dependency as a scheduling blocker; do not invent local satellite shaping or copy private source into public evidence. Exit: end-to-end transport proof or precise external blocker.
