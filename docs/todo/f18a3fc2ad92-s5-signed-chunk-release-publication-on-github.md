---
id: f18a3fc2ad92
kind: feature
title: S5 Signed chunk release publication on GitHub
seq: 445
status: wontfix
priority: p1
created: 2026-11-17T21:25:19.268914Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
closed: 2026-11-25T09:54:45.72832Z
---

Spec: docs/plan-cooperative-chunk-transfer.md

Depends on S1. Generate chunks from final uncompressed product members with pinned recorded chunk profile; include complete installer member set and deduplicate within a release. Emit individual compressed GitHub assets, desync indexes, exact-byte Ed25519-signed manifest and signature; adapt hash IDs to flat assets. Keep signing secrets in release infrastructure; client public trust keys only. Preflight all existing and new release assets against the 1000-asset limit and fail before publication on overflow. Upload chunks/indexes before exposing the completed manifest. Fixture-test deterministic content, signatures, count bounds, missing content and incomplete publication. Preserve approval gates; this backlog story authorizes no release or key provisioning.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.

Closed as won’t do with Sprint 657. For LAN distribution, use the satellite or the owner’s outpost as the artifact server.
