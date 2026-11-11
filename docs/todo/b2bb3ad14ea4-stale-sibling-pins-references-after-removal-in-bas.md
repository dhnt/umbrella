---
id: b2bb3ad14ea4
kind: task
title: Stale .sibling-pins references after removal in bashy a8539117
seq: 141
status: todo
created: 2026-11-11T21:43:42.113328Z
---

Found in Sprint 617 review (2026-11-11). .sibling-pins and scripts/bootstrap-siblings.sh were removed in bashy a8539117 (2026-10-08), but umbrella CLAUDE.md (script/sync.sh description), script/sync.sh behaviour text and bashy docs (function-attestation.md, meet-spa-release.md) still describe them. Verify what sync.sh actually does today, then correct the docs to match; no behaviour change unless a defect is found.
