---
id: 3c985133a736
kind: feature
title: P1 Owner self-service policy and defaults
seq: 372
status: wontfix
priority: p1
created: 2026-11-16T03:22:38.257306Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
closed: 2026-11-16T04:48:51.064621Z
---

Depends on both P0 contracts and transport proof. Add llm self-service on|off|status, allowed circles, tokens/day, USD/month, rpm and --soft. Default off; owner-only policy mutation. Define deterministic eligibility across allowed circles and preserve owner per-peer controls. Disabling self-service prevents all mint/rotation requests while existing authorized credentials continue working. Validate persistence/restart and invalid configuration. Exit: focused owner-policy tests pass.
