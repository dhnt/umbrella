---
id: fa4742dd83db
kind: bug
title: 'yoke atlas TestCensusCoversEveryPackage fails: pkg/boundary, nativepath, nfthelper, outpostagent, pagecontrol have no census entry'
seq: 380
status: done
priority: p2
created: 2026-11-16T04:37:40.117432Z
---

Pre-existing on clean yoke main 08731082 (reproduced in a detached worktree, macOS, GOWORK=off go test ./pkg/atlas -run TestCensusCoversEveryPackage), found 2026-11-15 while gating Sprint 641 J7. Not caused by J7's NarrowEffects change. Root cause not yet recorded: likely packages added (e.g. pkg/pagecontrol in 2b74a473) without a census entry. Bisect the first red commit before fixing.

## Resolution (2026-11-15)

Root cause: five packages were added without a row in pkg/atlas/packages.go.
Bisected: green at d820b289^, red at d820b289 (pkg/nfthelper, 2026-10-30);
then a38244a8 nativepath, 8d294b62 outpostagent, 4bbb57fb boundary and
2b74a473 pagecontrol. It stayed red because those changes ran package-scoped
tests only and yoke has no running CI for ./pkg/atlas. Classified as a
product metadata defect.

Fix: yoke b01a6445 adds the five census rows. GOWORK=off go test ./pkg/atlas
passes for the whole package.
