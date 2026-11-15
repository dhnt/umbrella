---
id: 1d91d26edc7c
kind: enhancement
title: 'Atlas effects are per verb, not per subcommand: every gateway ''run shape show/diff/verify'' needs approval because ''shape'' carries destroy/spend'
seq: 365
status: todo
priority: p2
labels:
    - vendor-gateway
created: 2026-11-15T16:50:59.250195Z
---

Found while accepting Sprint 646 O3 (2026-11-15). The gateway effect gate (yoke pkg/weave gatewayRunEffects, yoke mcp Policy) resolves effects with atlas.Lookup(argv[0]), so read-only subcommands of a mixed verb (shape show/diff/verify/preview, todo list, sprint show) inherit the verb's most dangerous effect. That is safe (fail closed) but noisy for chat users.

Fix: per-subcommand effects in the atlas (verb + subverb lookup), used by both routes and covered by tests. The read-only subcommands then run without approval.
