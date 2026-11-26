---
id: c61c6d33f114
kind: bug
title: candidate.bsh run with no arguments checks the clone's server against the clone's own digest
seq: 815
status: todo
priority: p2
labels:
    - shapeware
created: 2026-11-26T23:23:42.465882Z
---

Found in the Sprint 730 review (2026-11-26, bashy 8e051472): checks/candidate.bsh with no arguments compares the clone's server/ against the clone's own recorded digest (candidate.bsh:9-17), so a candidate that edits server/ and the digest together passes. Not in the 730 MVP; record the cause before any fix.
