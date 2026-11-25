---
id: 60d43cb7e7f0
kind: bug
title: 'bashy internal/agentos: three tests red at origin main before the 710 pin bump (CommonOptionsVocabulary, SkillHelpGoldens/mcp, SrcPinsMatchLinkedModules)'
seq: 737
status: todo
priority: p1
labels:
    - bashy
    - tests
created: 2026-11-25T05:26:42.987797Z
---

Seen 2026-11-24 by the Sprint 710 conductor on the gate host (Linux test host, WSL, GOWORK=off). The tests fail identically WITH and WITHOUT the 710 pin bump (bashy 3535205f vs its parent c450753f), so they were red before the bump. Not fixed in 710; root cause each before any fix.
- TestCommonOptionsVocabularyReport: the new fetch -A/--user-agent option is not in the reviewed baseline. Suspected origin: Sprint 697 A4 (todo 14d2d8b5, site identity user-agent).
- TestSkillHelpGoldens/mcp: the mcp help golden differs. Suspected origin: Sprint 709 mcp connect (bashy d68365d8 / earlier 709 mcp commits).
- TestSrcPinsMatchLinkedModules: bashy's recorded src pin for yoke disagrees with go.mod. It was already stale before 710's bump. Suspected origin: a yoke pin bump that did not update the src-pin record (check 709's c450753f and earlier).
The fourth red in the same run, TestEmbeddedAdaptersMatchSourceTree, is tracked separately as todo 01b745b8.
Bisect each against the last green gate evidence before changing goldens.
