---
id: 64b3fab2aabd
kind: enhancement
title: F7 Weave/sprint tooling friction found in Sprint 614
seq: 128
status: todo
priority: p3
labels:
    - collaboration-followup
created: 2026-11-11T09:56:32.698721Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

(1) sprint grade diffs against the run's original base, so a rebased run is flagged tamper for sibling runs' already-merged test files; (2) weave start --base is documented in help but rejected as unknown; (3) sprint merge cleanliness ignores .git/info/exclude (an untracked local docs/kb/reads.jsonl blocks merges); (4) worker runs auto-commit KB.md, conflicting on every merge; (5) sprint merge into a repo leaves weave run state undecided, so sprint end demands manual dispositions. Fix each at its cause with a regression test.
