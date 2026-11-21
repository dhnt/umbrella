---
id: 3d1b394227fa
kind: feature
title: Outpost reports native macOS suspend and resume observations
seq: 596
status: todo
priority: p2
created: 2026-11-21T10:43:33.925463Z
---

Follow-up to Sprint 652 story daa99f1f5a8e. Use IOKit power notifications for the daemon, acknowledge suspend promptly, and tear down the registration on shutdown. Report authenticated power events only when observed. Test delivery and lifecycle with fixtures and a claimed native macOS venue. [Apple sleep and wake notification guidance](https://developer.apple.com/library/archive/qa/qa1340/_index.html)
