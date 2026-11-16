---
id: ec658a497b75
kind: test
title: P1 Frozen-candidate integration and security acceptance gate
seq: 375
status: wontfix
priority: p1
created: 2026-11-16T03:22:38.757733Z
sprint: 648
sprint_id: dfac5d58-6489-54f5-b85a-d1cb89dc1a7c
sprint_title: Teacher tools · Self-service LLM keys for circle members (bashy llm key)
closed: 2026-11-16T04:48:51.144493Z
---

Depends on policy, endpoint and CLI. Claim an established self-hosted test venue; heavy suites never run on the dev box. Freeze candidate SHAs and record shared raw evidence. Prove eligible member mint -> protected storage -> satellite chat -> peer:self-<email> usage; distinct anonymous/non-member/pending/wrong-circle refusals with zero mutation; removal from circle blocks next inference; rotation invalidates old key with 401; caps and owner overrides survive rotation; off blocks minting while existing keys work; no credentials in argv/stdout/stderr/logs; existing owner/peer workflows retain relevant passing coverage. Independently inspect verdicts. Root-cause any previously green failure before fixes or rebaselining. New regressions block closure.
