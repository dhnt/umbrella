---
id: 4a7a9dbde6db
kind: feature
title: S3 Outpost transfer service and authorized peer exchange
seq: 443
status: wontfix
priority: p1
created: 2026-11-17T21:25:18.948018Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
closed: 2026-11-25T09:54:42.088223Z
---

Spec: docs/plan-cooperative-chunk-transfer.md

Depends on S1 and S2. Reuse existing mesh forwarding and service registry; preserve bashy build independence from outpost. Add authenticated session service, batched chunk availability, verified peer retrieval and transfer send to a designated inbox. Service exposure alone is not authorization, and generic forwarding does not preserve caller identity to the loopback app. Use explicit service/session authentication. One outpost manager coalesces concurrent chunk requests across sessions and applies shared local origin/peer concurrency, bandwidth and fair scheduling. Same-session student peers may exchange public chunks without general host access. Test private grants, corrupt peers/cache, concurrent callers, interruption and unauthenticated discovery.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.

Closed as won’t do with Sprint 657. For LAN distribution, use the satellite or the owner’s outpost as the artifact server.
