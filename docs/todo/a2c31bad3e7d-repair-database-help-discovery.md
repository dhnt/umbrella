---
id: a2c31bad3e7d
kind: bug
title: Repair database help discovery
seq: 47
status: done
priority: p1
created: 2026-11-08T09:52:36.168474Z
assignee: opencode-glm-5.3
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:33.582564Z
closed_by: s595-manager
---

Reproduction: bashy db --help exits 2 demanding TARGET; bashy help db --format=classic rejects db. Acceptance: both standard entry points display accurate usage without requiring a database target or performing database operations.
