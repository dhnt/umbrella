---
id: edc345bf78b8
kind: bug
title: S7 Repair supported mixed Go constructs and targeted refusals
seq: 86
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.206732Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Implement M10 range loops and M11 union constraints within typed constructs; retain M09 top-level Go control flow as unsupported with a positioned diagnostic and tested workaround.

Dependencies: S3/S5.

## Acceptance
- Range and union fixtures produce correct output/type behavior; malformed variants refuse clearly.
- Preserve shell pipes, control syntax, dialect activation and streaming parser boundaries.
- Update fixtures, generated Go-delta docs and refusal lookup together.
- Do not address M09 by increasing arbitrary lookahead.
- M12 belongs to S2. Keyword-call expressions and negative numeric arguments remain separately recorded deferred parser repairs, not implicit S7 scope.

Planned owner: codex (reviewer, gate and merge: claude).
