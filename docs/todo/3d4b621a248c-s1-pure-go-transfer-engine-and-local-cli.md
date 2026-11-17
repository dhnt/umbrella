---
id: 3d4b621a248c
kind: feature
title: S1 Pure-Go transfer engine and local CLI
seq: 441
status: todo
priority: p1
created: 2026-11-17T21:25:18.645475Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
---

Spec: docs/plan-cooperative-chunk-transfer.md

Implement the shared yoke/pkg/transfer library around a reviewed pinned desync version; no external transfer executable. Provide verified manifest/index binding, content-addressed compressed chunks, file/directory publish and fetch, resume, staged reconstruction, inspection and active-transfer-safe pruning. CLI: transfer publish/fetch/inspect/prune. Prove CGO_ENABLED=0, standalone builds, exact reconstruction, safe symlinks and paths, unsupported metadata reporting, bounded decompression and cancellation. Defaults: 2/8/32 MiB minimum/average/maximum chunks; four origin requests per outpost. Depends on no new cloud service contract. Current delivery: planning spec only; no implementation or tests.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.
