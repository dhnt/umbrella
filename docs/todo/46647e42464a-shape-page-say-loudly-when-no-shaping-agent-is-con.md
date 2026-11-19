---
id: 46647e42464a
kind: enhancement
title: 'Shape page: say loudly when no shaping agent is configured'
seq: 501
status: todo
priority: p1
labels:
    - shaping
    - yoke
    - ux
created: 2026-11-19T04:08:24.496232Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Operator 2026-11-18 (Sprint 615 live run): a console started without --shape-agent accepts the wish UI, and the wish then fails quietly. The CLI says 'no shaping agent is configured on this console'; the Shape page does not. Show it up front: disable the wish box with a visible banner naming the fix (start the console with --shape-agent tool:model, or set it on the apps service unit), plus the same state in bashy shape status --json. Guards need an escape hatch: name the exact command.
