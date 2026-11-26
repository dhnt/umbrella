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
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
---

Seen by the Sprint 685 manager during the yoke c2d6591f pin sync (2026-11-24) on a gate-host lane through the venue wrapper: bashy/yoke/fetch TestStandaloneHelpAndDeps fails at bashy 3bd53882 and identically at the pre-sync commit 033fbe8f, so the pin change did not cause it. Recorded as pre-existing, not as passing. Not yet investigated: first step is root cause (failing assertion, venue vs last green, bisect), then fix where the cause lives. Evidence: Sprint 685 thread, close-out note of 2026-11-24 12:37Z.

## Unlinked to the backlog (2026-11-24, operator: close Sprint 703)

A known failing test is tracked, never closed as won't do (root-cause rule). It is not on the MVP path; fix it when it blocks a release gate, with the root cause recorded here.
