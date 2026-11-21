---
id: c0f8d08479ff
kind: bug
title: F4 Root-cause TestToolFenceRejectsCatalogDriftAfterAnalysis (bashy internal/agentos)
seq: 125
status: todo
priority: p2
labels:
    - collaboration-followup
created: 2026-11-11T09:56:31.654236Z
---

Pre-existing red on bashy main (todo 8e20e5f9 item 2; red before the S604 yoke bump, not bisected). Item 1 (TestSrcPinsMatchLinkedModules) was fixed at its cause in Sprint 614 (src_mount.go yoke literal). Identify by name vs last green, check venue, bisect, record cause, then fix.
