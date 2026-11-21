---
id: 52a3c08d2802
kind: refactor
title: 'P4b: Convert batch - standalone verbs (browser, viewer/form/chart/notepad apps, tokens, ast/graph, dks, cloud/cluster CLIs)'
seq: 589
status: todo
priority: p2
created: 2026-11-21T09:22:07.71697Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

IN SCOPE for 677 (operator: convert all in 677); p2 = dependency order only (after P4a), not optional. Repos: yoke, bashy. Standalone verbs to generated-main slot binaries: browser, viewer/form/chart/notepad apps, tokens, ast/graph, dks, cloud/cluster CLIs. Libraries stay shared; no command binary imports another command binary; state stays in existing on-disk stores. 3-OS dispatch gate venues: Linux = official image in a claimed gate-host lane (bashy oci); Windows = native on the gate host Windows side; macOS = the macOS QA host (claim first, fresh per-run work dir, dispatch gate + parity only, release after). Gate: TestE2EAllListedCommandsDispatch 3-OS + --help/--json/exit parity per command. Own commits.
