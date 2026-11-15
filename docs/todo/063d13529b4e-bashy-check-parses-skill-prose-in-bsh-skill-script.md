---
id: 063d13529b4e
kind: bug
title: bashy check parses ~~~skill prose in .bsh skill-scripts as shell (false error)
seq: 369
status: todo
priority: p3
created: 2026-11-15T20:05:20.392696Z
---

Found 2026-11-15 (Sprint 641 J4): bashy check examples/desktop/desktop.bsh reports 'line 11: for foo must be followed by in, do...'; line 11 is prose inside the ~~~skill block ('Use existing member, group, suite...'). Same error on the unchanged file (pre-existing). bashy --bashsharp -n and bash -n of the body pass. Expected: check skips the skill block the same way the Bash# runtime does.
