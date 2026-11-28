---
id: 5c260398c214
kind: feature
title: 'M2: help reads data (no new commands or options; --version unchanged); tool-add touches no core file'
seq: 870
status: todo
priority: p2
labels:
    - core
created: 2026-11-28T21:18:35.74745Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M2). No new commands or options (D4). --version is unchanged: the shell layer answers it (bashsharp cli/version.go), and its build ID is the release tag, which under M4 also names the core contract. bashy help reads its topics from records and names commands --json as the discovery entry. Ratchet: register a tool in a temp ring; commands --json and help commands show it; no file under yoke/core changes.
