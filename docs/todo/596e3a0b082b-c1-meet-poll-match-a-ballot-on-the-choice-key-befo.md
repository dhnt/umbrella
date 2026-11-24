---
id: 596e3a0b082b
kind: bug
title: 'C1 meet poll: match a ballot on the choice key before the colon (bug ed305169); poll coverage row'
seq: 574
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:47.637347Z
sprint: 685
sprint_id: f684d38b-201d-5579-bd47-c70e26524188
sprint_title: 'Group shaping coverage: every bashy app as a test case, plus cross-outpost agent steering in one circle'
---

The only code the poll coverage row needs. Form multi-respondent mode already works and is unit-tested (examples/desk/form/server/many_test.go). bashy meet poll with a described --choice (KEY: description) records every ballot invalid because normalizeChoice (yoke/pkg/meet/poll.go) matches the whole string (todo ed305169). Fix: match on the key before the first colon and have the poll prompt ask for the key. Unit test: table test in yoke/pkg/meet with described choices. Close ed305169 with it. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.
