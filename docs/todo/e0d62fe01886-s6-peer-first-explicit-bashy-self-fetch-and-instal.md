---
id: e0d62fe01886
kind: feature
title: S6 Peer-first explicit bashy self fetch and install
seq: 446
status: todo
priority: p1
created: 2026-11-17T21:25:19.435402Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
---

Spec: docs/plan-cooperative-chunk-transfer.md

Depends on S3, S4 and S5. Resolve latest once to a concrete release; authenticate signed manifest before peer lookup, seed from installed uncompressed members, fetch coordinated missing chunks from peers/origin, reconstruct and verify complete members before existing installation flow. Integrate self fetch and versioned self install. Preserve Windows replacement and all platform install behavior. Fall back to archives only for old releases lacking chunk manifests; invalid signatures/manifests are errors. Add no background upgrade trigger. Verify same-owner and multi-owner retrieval, installed seed reuse, wrong platform/version, missing member and failure before install preserves current installation.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.
