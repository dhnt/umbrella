---
id: 6129131feddc
kind: feature
title: 'S600.5 PowerShell fence: route native-command invocation through bashy'
seq: 66
status: todo
priority: p2
labels:
    - polyglot
created: 2026-11-09T01:26:09.216689Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Depends on S600.1. Design and implement the seam for native-command invocation and Start-Process in the PowerShell worker (cmdlets stay in-process). Acceptance: fixture as S600.2 on the Windows host; existing PowerShell fence tests green.
