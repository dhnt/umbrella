---
id: 48f0c35e9f05
kind: spike
title: 'P0 Spike: signed CLI identity through satellite to door'
seq: 371
status: todo
priority: p0
created: 2026-11-16T03:22:38.090094Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
---

MVP rescope 2026-11-15. Time-box ~1/2 day. Question: does a request made with a bashy login session reach the door through a test satellite carrying a signed Remote-User identity (existing pkg/coopauth HMAC check)? Prefer a separate llm-key app entry (require_login, trust_cloud_identity) pointing at the same door; the existing Bearer inference entry is unchanged. Yes: record the working setup. No: file one Cloudbox public-contract ticket and mark the sprint blocked; do not shape the satellite locally. Exit: working setup recorded, or the ticket filed.
