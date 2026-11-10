---
id: 1009dcc81407
kind: feature
title: S6 Add explicit checked execution without changing defaults
seq: 85
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.066848Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S3-S5. Add opt-in --checked execution to Bash# hosts. Parse and analyze the complete input before running any statement.
Acceptance: a rejected input with an earlier side-effect sentinel causes no program side effects; valid input runs once with original argv, streams and status. Cover files, -c and stdin. Preserve existing unchecked execution defaults, shell failure options and streaming behavior. A successful bounded check reports its coverage, not universal safety.
Planning-only creation; no new errexit/nounset/pipefail defaults.
