---
id: ef27beca9fb4
kind: bug
title: 'yoke cmds/db TestTypedMCPDbLifecycleRequiresDestroyGrant fails: lifecycle call exits 0 without a destroy grant'
seq: 385
status: done
priority: p1
created: 2026-11-17T06:17:10.461383Z
---

Found 2026-11-16 during the release run. Fails on clean yoke main df81da35 and before Sprint 641's policy change (a6dcf59c^), with db_test.go:272 'exit=0 stderr=""', so it is not caused by NarrowEffects. It looks like a security-relevant gate (a destroy-effect db lifecycle call should be refused without a grant). Bisect the first red commit and record the cause before fixing.

## Resolution (2026-11-17)

Bisected with git bisect run: green at 6a43f159 (test added), first bad
979150de "O3 sync route answers gated and settles approvals on the pull
route" (Sprint 646). Since then the policy answers privileged effects with
the gated pull-route handoff {state: "gated", effects}, IsError, "not
executed", instead of the exit-126 denial text. The call is still refused
and never executes: a test defect, not a permission gap. Fix: yoke f86d1d7f
asserts the refusal itself. One unrelated ./cmds/db run failed with an
uncaptured test name and did not reproduce in 3 reruns; see
docs/release-failure-ledger.md.
