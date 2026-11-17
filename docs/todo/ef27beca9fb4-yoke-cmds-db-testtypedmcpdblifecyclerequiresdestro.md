---
id: ef27beca9fb4
kind: bug
title: 'yoke cmds/db TestTypedMCPDbLifecycleRequiresDestroyGrant fails: lifecycle call exits 0 without a destroy grant'
seq: 385
status: todo
priority: p1
created: 2026-11-17T06:17:10.461383Z
---

Found 2026-11-16 during the release run. Fails on clean yoke main df81da35 and before Sprint 641's policy change (a6dcf59c^), with db_test.go:272 'exit=0 stderr=""', so it is not caused by NarrowEffects. It looks like a security-relevant gate (a destroy-effect db lifecycle call should be refused without a grant). Bisect the first red commit and record the cause before fixing.
