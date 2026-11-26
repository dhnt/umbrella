---
id: 7a13a0e20dc8
kind: test
title: S8 Run platform recovery, contention and sealed-network acceptance
seq: 411
status: assigned
priority: p1
created: 2026-11-17T18:00:05.48765Z
assignee: agy-gemini4-carbon-s654
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Depends on S3-S7. Exercise every supported release platform on registered local runners, not heavy suites on dev host. Verify clean-host bundle restore, tamper/incomplete import refusal, crashes and concurrent operations, module ZIP regeneration, OCI reconstruction, inference, tier failures and resource pressure. Capture public DNS/HTTP/registry/model/workflow/telemetry attempts. Measure binary growth, dependency closure, storage and rebuild costs. Acceptance: all required gates pass with raw evidence; pre-existing failures tracked separately; no claimed acceptance without fresh or unchanged-input evidence.
