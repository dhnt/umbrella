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

## Outcome
Add opt-in --checked execution to standalone bashsharp and bashy's Bash# execution path. Analyze complete input before executing that same input once.

Dependencies: S3/S4/S5/S8.

## Acceptance
- Cover files, -c and stdin. A parse/semantic/provider rejection after an earlier side-effect sentinel produces no program side effects.
- Execution uses the analyzed input rather than rereading potentially changed source.
- Valid input runs once with original argv, streams, exit status and cancellation behavior.
- Reuse host-provider requirements from S8; a successful bounded check reports its coverage.
- Preserve unchecked streaming execution, shell failure options, dialect activation and legacy aliases.
- No new errexit/nounset/pipefail defaults; no universal safety claim.

Planning record only: implementation requires a separate execution instruction. Leave this story todo and unassigned; no code, worker launch or release is authorized by this rewrite.
