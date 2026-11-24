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
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Problem: offer refuses a version that was released (found in the 2026-11-18 review). Root cause before any fix: reproduce on the current yoke head (yoke/pkg/src/offer.go, release.go), bisect, classify and record the cause here; the fix goes in its own commit.
