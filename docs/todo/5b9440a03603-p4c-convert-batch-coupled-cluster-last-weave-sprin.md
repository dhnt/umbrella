---
id: 5b9440a03603
kind: refactor
title: 'P4c: Convert batch - coupled cluster last (weave+sprint, mb/inbox, bus/room, kb, chat, meet, todo, dag, foreman)'
seq: 590
status: todo
priority: p2
created: 2026-11-21T09:22:07.862854Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

IN SCOPE for 677 (operator: convert all in 677); p2 = dependency order only (LAST batch), not optional. Repos: yoke, bashy. Coupled cluster: weave+sprint, mb/inbox, bus/room, kb, chat, meet, todo, dag, foreman. Duplicated wiring from the switch accepted (mb weave.ResolveSprintScopeByHandle, dag sprintCapacityServices), removed later. 3-OS dispatch gate venues: Linux = official image in a claimed gate-host lane (bashy oci); Windows = native on the gate host Windows side; macOS = the macOS QA host (claim first, fresh per-run work dir, dispatch gate + parity only, release after). Gate: TestE2EAllListedCommandsDispatch 3-OS + parity; merged-tip build before acceptance. Own commits per sub-batch.
