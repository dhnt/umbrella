---
id: ee056056de3e
kind: refactor
title: 'P4a: Convert batch - yoke cmds applets + GNU-only coreutils to generated-main slot binaries'
seq: 588
status: todo
priority: p2
created: 2026-11-21T09:22:07.571881Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

IN SCOPE for 677 (operator: convert all in 677); p2 = dependency order only (after P3 pilot), not optional. Repos: yoke, coreutils, bashy. Convert yoke cmds/* applets + GNU-only coreutils to catalog entries + generated mains (same constructor/wiring as the switch in bashy internal/agentos/agentos.go), built on demand into shape slots. Coreutils sources stay in place (bug-fix-only). 3-OS dispatch gate venues: Linux = official image in a claimed gate-host lane (bashy oci); Windows = native on the gate host Windows side; macOS = the macOS QA host (claim its resource first, fresh per-run work dir, dispatch gate + parity only, release after; native-darwin leg, no Linux image). Gate: TestE2EAllListedCommandsDispatch 3-OS + per-command --help/--json/exit parity. Own commits; root cause before any red-test fix.
