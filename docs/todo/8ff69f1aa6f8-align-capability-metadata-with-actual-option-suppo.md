---
id: 8ff69f1aa6f8
kind: bug
title: Align capability metadata with actual option support
seq: 50
status: done
priority: p1
created: 2026-11-08T09:52:36.505029Z
assignee: muse-spark1.3
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:34.268097Z
closed_by: s595-manager
---

Generated adapt help advertises --since=supported, but bashy adapt --since=x -- git status exits 125 because shared cursor binding is unavailable. Acceptance: generated help and capability metadata accurately report availability; no claim of implemented cursor support until verified.
