---
id: 1d91d26edc7c
kind: enhancement
title: 'Atlas effects are per verb, not per subcommand: every gateway ''run shape show/diff/verify'' needs approval because ''shape'' carries destroy/spend'
seq: 365
status: done
priority: p2
labels:
    - vendor-gateway
created: 2026-11-15T16:50:59.250195Z
closed: 2026-11-18T20:13:30.635462Z
---

Found while accepting Sprint 646 O3 (2026-11-15). The gateway effect gate (yoke pkg/weave gatewayRunEffects, yoke mcp Policy) resolves effects with atlas.Lookup(argv[0]), so read-only subcommands of a mixed verb (shape show/diff/verify/preview, todo list, sprint show) inherit the verb's most dangerous effect. That is safe (fail closed) but noisy for chat users.

Fix: per-subcommand effects in the atlas (verb + subverb lookup), used by both routes and covered by tests. The read-only subcommands then run without approval.

Fixed 2026-11-15 by yoke a6dcf59c (atlas NarrowEffects applied in the gateway effect gate and MCP policy: read-only subcommands of mixed verbs govern as reads), pinned in umbrella a1600fad under Sprint 641 J7. Limit: narrowing looks one subcommand level deep, so a nested read such as `desktop policy route get` still takes the verb's write effects (safe default; found by Sprint 664 W2).
