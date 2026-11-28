---
id: 2acc0cc42eeb
kind: refactor
title: 'M3: custom/ holds only the adapter mechanism; tool adapters move to optional/'
seq: 871
status: todo
priority: p2
labels:
    - core
created: 2026-11-28T21:18:36.009535Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M3). git mv custom/<tool> to optional/<tool>; keep custom/internal/adapter, custom/internal/toolshortcut, README. Registration names and dispatch unchanged; go list -deps proves no outside importer. Test pins no tool under custom/.
