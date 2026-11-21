---
id: d3989b118dd7
kind: feature
title: 'P3 (ex-S7): catalog-driven dispatch + generated mains + on-demand slot builds; one-command pilot'
seq: 557
status: todo
priority: p1
labels:
    - bashy
    - yoke
    - shape
    - architecture
created: 2026-11-20T10:01:54.093407Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repos: bashy, yoke. Re-scoped to v3 P3 (mechanism story; S1 build-speed lands inside this phase). bashy becomes thin entry: bsh engine + agentic hooks + generic catalog-driven dispatcher (internal/agentos switch becomes catalog entries). Builder generates a tiny main per command from its catalog entry (package + module version), builds on demand into shape slots reusing yoke/pkg/shape/slot (Stage/Select/Activate/Undo/Restore) + tree-hash build cache. Sources stay in their packages; NO optional/ folder. Pilot: ONE command end to end; measure edit->verified-active-slot cycle in minutes vs P1 whole-bashy number. UX unchanged: bashy <verb>.
