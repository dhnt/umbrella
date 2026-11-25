---
id: 90f03f54c150
kind: bug
title: 'D4 root-cause: offer refuses a released version'
seq: 618
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-21T21:59:33.401247Z
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Owner publishing for a shapeable page and its shapeable components (any website)
---

Problem: offer refuses a version that was released (found in the 2026-11-18 review). Root cause before any fix: reproduce on the current yoke head (yoke/pkg/src/offer.go, release.go), bisect, classify and record the cause here; the fix goes in its own commit.

## Moved to Sprint 683 (2026-11-24, operator: close Sprint 703)

Owner publishing (offer, adopt) is Sprint 683's workflow, held on 705 S3; this story travels with it instead of being dropped.
