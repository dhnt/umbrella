---
id: 81bb8a39ce41
kind: feature
title: Let bashy shape target bashy itself
seq: 55
status: done
priority: p1
created: 2026-11-08T10:09:32.461829Z
assignee: claude-opus5.5
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:35.578533Z
closed_by: s595-manager
---

Split from caac5708 (part c). bashy shape operates on registered apps (bashy shape status APP) and bashy is not in bashy app list, so shaping advice for bashy CLI defects has no target today. Provide a shape target for bashy's own commands (reproduction, expected behavior, evidence) through the existing yoke/pkg/shape lifecycle; account for host-kind incident-repair limitations and released shell/script entry points. Acceptance: a bashy CLI defect can be filed and tracked via bashy shape with approval/activation boundaries unchanged. Prerequisite for shaping advice in the point-of-need story.
