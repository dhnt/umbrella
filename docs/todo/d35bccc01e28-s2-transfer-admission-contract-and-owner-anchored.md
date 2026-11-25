---
id: d35bccc01e28
kind: feature
title: S2 Transfer admission contract and owner-anchored group model
seq: 442
status: wontfix
priority: p1
created: 2026-11-17T21:25:18.783892Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
closed: 2026-11-25T09:54:40.289936Z
---

Spec: docs/plan-cooperative-chunk-transfer.md

Depends on S1 interface shapes. Define and fixture-test a public transfer authorization contract: authority-qualified initiating owner/session; owned paired outposts plus participating outposts of active mutual members; no circle filter. Teacher/student and organization fixtures must admit participants without pairwise member relationships, while rejecting pending, one-sided, unrelated and transitive relationships. Bind authenticated host ownership to actual mesh identity; do not infer from roster visibility, advertised email or mDNS. Session-scoped public chunk exchange, explicit grants for private content, 30-second membership-cache validity and revocation. Current roster lacks sufficient owner/mutual binding. Private authorization-service implementation must stay outside this public repo; deployed contract evidence is a delivery dependency, not something fixtures establish.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.

Closed as won’t do with Sprint 657. For LAN distribution, use the satellite or the owner’s outpost as the artifact server.
