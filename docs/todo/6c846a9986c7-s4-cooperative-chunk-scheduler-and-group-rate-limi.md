---
id: 6c846a9986c7
kind: feature
title: S4 Cooperative chunk scheduler and group rate limits
seq: 444
status: todo
priority: p1
created: 2026-11-17T21:25:19.10891Z
sprint: 657
sprint_id: 0060bff8-31f3-58f8-815c-ce48e79d1e06
sprint_title: Cooperative chunk transfer for bashy and sphere
---

Spec: docs/plan-cooperative-chunk-transfer.md

Depends on S3. Coordinator runs on initiating-owner outpost: configured eligible peer first, otherwise lowest eligible initiating-owner mesh ID. Advertise group/session identity and coordinator epoch; settle competing views and recover stale leases. Query cached availability before origin access, lease distinct content hashes to participants, announce verified completion immediately and distribute through peers. Prefer local/cache copies and avoid unnecessary WAN forwarding; locality is not authorization or proof of a shared uplink. Default eight group origin requests, 30-second leases renewed every 10 seconds, independent local-limited operation after 10 seconds unreachable coordinator. Never bypass admission. Test cold starts, overlapping groups/jobs, fair limits, stalled owners, partitions, coordinator recovery and documented duplicate-fetch/aggregate-overshoot exceptions.

Planning-only filing. Leave unassigned and unstarted until an execution manager is appointed.
