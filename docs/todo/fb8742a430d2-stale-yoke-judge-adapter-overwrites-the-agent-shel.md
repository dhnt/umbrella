---
id: fb8742a430d2
kind: bug
title: Stale yoke judge adapter overwrites the agent shell shims with its own path
seq: 722
status: todo
priority: p1
created: 2026-11-24T19:49:57.353877Z
---

On the dev box the cached judge adapter binary (built two days before the others) rewrote the sh/bash/zsh agent shims to exec the judge binary instead of bashy. Every agent that resolves a bare shell name through the shim directory then failed with 'bashy judge: unknown shorthand flag: c'. It stalled the sprint 675 manager's checkpoint loop for 65 minutes during a full run. Current yoke source already validates the shim target (pkg/chat/shell_shim.go, validateShellShimTarget); the cached adapter predates it. Wanted: (1) rebuild or invalidate adapters older than the shim-target check; (2) doctor check for shim targets. Shims were repaired by hand on 2026-11-24.
