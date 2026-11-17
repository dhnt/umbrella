---
id: 4451c946a2bd
kind: feature
title: S3 Implement bootstrap, seal, verify and portable recovery
seq: 406
status: todo
priority: p0
created: 2026-11-17T18:00:04.678973Z
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Depends on S1 and S2. Add self bootstrap|seal|verify --offline|status|export|import. Retain Go toolchain, bashy runtime overlay, exact source/nested siblings, module graph, managed runtimes and selected capability inputs. Apply sealed invocation config to bashy go, fences, bridges and runners with no direct fallback/toolchain fetch. Check capacity plus rebuild reserve. Acceptance: incomplete profile cannot seal; verified import restores baseline; protected generations survive upgrades; fresh-cache offline rebuild succeeds.
