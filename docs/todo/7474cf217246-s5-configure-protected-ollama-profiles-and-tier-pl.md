---
id: 7474cf217246
kind: feature
title: S5 Configure protected Ollama profiles and tier placement
seq: 408
status: done
priority: p1
created: 2026-11-17T18:00:05.005077Z
assignee: agy-gemini4-carbon-s654
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
closed: 2026-11-26T13:54:58.274233Z
closed_by: agy-gemini4-carbon-s654
---

Depends on S1 and S3. Required local coding/general inference plus embeddings; pin complete runtime/model payloads and run local capability evaluations. Compact Qwen3.5 4B + Qwen3-Embedding 0.6B default candidates; larger models configurable. Policy order cloud/cluster/sphere/sandbox/workplace/userland, offline floor default userland. Sealed mode excludes external cloud; preserve workload confinement. Acceptance: inference/embedding after restart and cleanup, pressure unloads memory not required weights, unavailable floor fails explicitly.
