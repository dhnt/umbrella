---
id: fa4742dd83db
kind: bug
title: 'yoke atlas TestCensusCoversEveryPackage fails: pkg/boundary, nativepath, nfthelper, outpostagent, pagecontrol have no census entry'
seq: 380
status: todo
priority: p2
created: 2026-11-16T04:37:40.117432Z
---

Pre-existing on clean yoke main 08731082 (reproduced in a detached worktree, macOS, GOWORK=off go test ./pkg/atlas -run TestCensusCoversEveryPackage), found 2026-11-15 while gating Sprint 641 J7. Not caused by J7's NarrowEffects change. Root cause not yet recorded: likely packages added (e.g. pkg/pagecontrol in 2b74a473) without a census entry. Bisect the first red commit before fixing.
