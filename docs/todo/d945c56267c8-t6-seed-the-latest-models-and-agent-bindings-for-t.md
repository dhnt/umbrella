---
id: d945c56267c8
kind: feature
title: T6 Seed the latest models and agent bindings for the official set
seq: 540
status: done
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:46.153479Z
assignee: claude-opus5.5-s671
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
closed: 2026-11-19T18:31:08.468596Z
closed_by: claude-opus5.5-s671
---

From the T5 table, add yoke/pkg/fleet/baseline/models + agents seeds for the official tools and re-peg defaults. Older seeds stay. Accept: seed-lint, registry consistency and golden tests green (GOWORK=off).
