---
id: da93e20e0f6a
kind: chore
title: 'ycode''s indirect bashsharp pin trails (via its bashy pin): bump ycode''s bashy pin by hand'
seq: 874
status: todo
priority: p2
labels:
    - deps
created: 2026-11-28T21:20:15.598682Z
---

After Sprint 746, bashy main 9830fa6c (now later) requires bashsharp b379d8d (yoke-free). ycode requires bashsharp only indirectly through its bashy pin, and the bashy<->ycode cycle is bumped by hand. Bump ycode's bashy pin to current bashy main, re-tidy, build and run ycode go test -short on the lane, check bashy mod drift.
