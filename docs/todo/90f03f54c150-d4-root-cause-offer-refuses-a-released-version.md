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
---

Problem: offer refuses a version that was released (found in the 2026-11-18 review). Root cause before any fix: reproduce on the current yoke head (yoke/pkg/src/offer.go, release.go), bisect, classify and record the cause here; the fix goes in its own commit.

## Moved to Sprint 683 (2026-11-24, operator: close Sprint 703)

Owner publishing (offer, adopt) is Sprint 683's workflow, held on 705 S3; this story travels with it instead of being dropped.

## Lead to reproduce first (2026-11-24, from docs/design-shape-offer-audience.md)

Hypothesis, unconfirmed: `bashy shape release` never sets Shared, so the release tag is principal-private, and Offer resolves it as the empty principal. Reproduce with a unit test against yoke origin head before accepting or fixing. Sprint 683 MVP (operator KISS review): D4 is the only blocker of O1.

## Backlog (2026-11-24, Sprint 683 parked)

Real bug in existing verbs; no sprint needs offer today (A/O/C does not use it). Fix when anyone uses shape offer; reproduce the lead above first.
