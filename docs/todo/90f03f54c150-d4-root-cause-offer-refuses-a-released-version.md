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
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
---

Problem: offer refuses a version that was released (found in the 2026-11-18 review). Root cause before any fix: reproduce on the current yoke head (yoke/pkg/src/offer.go, release.go), bisect, classify and record the cause here; the fix goes in its own commit.
