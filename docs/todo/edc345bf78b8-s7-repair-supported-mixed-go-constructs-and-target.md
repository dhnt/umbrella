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

Depends on S3/S5. Implement M10 range loops and M11 union constraints within typed constructs. Keep M09 top-level Go control flow unsupported with a specific positioned diagnostic and tested workaround; preserve the streaming parser boundary.
Acceptance: range and union cases have correct output/type behavior, malformed variants refuse clearly, and shell pipe/control syntax stays compatible. Update fixtures, generated Go-delta docs and refusal lookup together. Do not solve top-level ambiguity by increasing arbitrary lookahead or changing dialect activation.
Planning-only creation; M12 is owned by S2.
