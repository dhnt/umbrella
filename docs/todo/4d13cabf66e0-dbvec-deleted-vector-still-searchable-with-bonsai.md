---
id: 4d13cabf66e0
kind: bug
title: 'dbvec: deleted vector still searchable with bonsai at migration-A baseline 24dd0f47 (TestVecCollectionsAndItemsBothModes)'
seq: 384
status: done
priority: p1
created: 2026-11-17T06:17:10.381368Z
---

Found 2026-11-16 during the release pin alignment. yoke ./pkg/dbvec TestVecCollectionsAndItemsBothModes passes with bonsai d14bdab6 (yoke's old pin) and fails deterministically with bonsai 24dd0f47 (dbvec_test.go:247 'deleted vector still searchable'). 24dd0f4 is 'migration(A): restore reviewed baseline tree and preserve prior history', so the baseline tree lacks a repair the d14bdab6 lineage had. bashy has shipped bonsai 24dd0f47 since rc.25 (a022b00e, 2026-11-06), so rc.25-rc.36 already carry this behavior; aligning yoke's pin only exposes it in yoke's own suite. Per the migration policy: a previously green test now red is a migration regression; fix it with a small baseline-proven repair in a separate C commit in bonsai (identify the d14bdab6-lineage repair first), never by replaying feature fixes into stage A.

## Resolution (2026-11-17), correcting the note above

Not a bonsai regression. The test is flaky: it fails intermittently on every
bonsai revision tried. Root cause: strings.Contains(hits, "a@") matched a
random hex id ending in "a" (observed "92453b33...9e6a@2.2361"), about 1 run
in 16. The first diagnosis rested on two consecutive failures that looked
deterministic. Fix: yoke b783a91f compares whole ids; 30/30 runs pass. See
docs/release-failure-ledger.md.
