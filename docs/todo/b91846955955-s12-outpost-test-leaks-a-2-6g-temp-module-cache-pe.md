---
id: b91846955955
kind: bug
title: S12 outpost test leaks a 2.6G temp module cache per run (os.Setenv HOME)
seq: 221
status: done
priority: p1
labels:
    - test
created: 2026-11-13T12:29:42.908258Z
assignee: claude-opus5.5-s631
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
closed: 2026-11-13T12:33:24.073533Z
closed_by: claude-opus5.5-s631
---

Root cause (recorded 2026-11-13): cmd/outpost/connect_test.go TestKeepAliveExitsOn401 sets HOME with os.Setenv instead of t.Setenv, so HOME=<tempdir> leaks to the rest of the test process. Later tests that shell out to go download the whole module cache into that temp HOME; module files are read-only, so the TempDir cleanup fails and ~2.6G is left in TMPDIR per run (11G found on the dev box during S631, disk fell 66G -> 48G free). Classification: test defect. Fix: t.Setenv("HOME", tmp).
