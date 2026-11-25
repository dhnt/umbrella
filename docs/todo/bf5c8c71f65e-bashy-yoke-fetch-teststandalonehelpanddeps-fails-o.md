---
id: bf5c8c71f65e
kind: bug
title: bashy/yoke/fetch TestStandaloneHelpAndDeps fails on the gate host (pre-existing at bashy 033fbe8f)
seq: 695
status: todo
priority: p2
labels:
    - bashy
created: 2026-11-24T12:40:38.525783Z
sprint: 713
sprint_id: 867b4689-21ed-53db-93f9-b2a926b28de6
sprint_title: 'Known reds triage after train 1: decide fix or won''t do for each pre-existing test red'
---

Seen by the Sprint 685 manager during the yoke c2d6591f pin sync (2026-11-24) on a gate-host lane through the venue wrapper: bashy/yoke/fetch TestStandaloneHelpAndDeps fails at bashy 3bd53882 and identically at the pre-sync commit 033fbe8f, so the pin change did not cause it. Recorded as pre-existing, not as passing. Not yet investigated: first step is root cause (failing assertion, venue vs last green, bisect), then fix where the cause lives. Evidence: Sprint 685 thread, close-out note of 2026-11-24 12:37Z.

## Unlinked to the backlog (2026-11-24, operator: close Sprint 703)

A known failing test is tracked, never closed as won't do (root-cause rule). It is not on the MVP path; fix it when it blocks a release gate, with the root cause recorded here.
