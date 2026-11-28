---
id: 0341c7477c14
kind: refactor
title: 'M0: dependency-clean bashy/core package (six verbs + class table; stdlib + Bash# graph only)'
seq: 868
status: todo
priority: p1
labels:
    - core
created: 2026-11-28T21:18:35.215532Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M0). New package bashy/core holding CoreVerbs/ClassOf and the six verbs (model tool agent CRUD, commands CRUD, help, version) over JSON records (D1=a). Rich implementations become builtin optional extensions registered through an interface; existing verbs delegate (one store). Ratchet: go list -deps ./core modules within stdlib + bashsharp module graph, naming the offending import. Cache check on the lane: bump a non-essential pin, go test ./core stays (cached), go build -x shows no core compile. No formerly green test regresses (compare by name).
