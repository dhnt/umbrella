---
id: d9bf47e9554b
kind: feature
title: bashy make falls through to bashy dag when there is no Makefile but a dag.md (agents' make habit, dag.md the only source)
seq: 423
status: todo
priority: p1
created: 2026-11-17T18:59:32.514563Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Operator 2026-11-17 (approved design): companion of 42d05687 (remove Makefiles). bashy is for agents, and agents reach for make. Rules: (1) A Makefile present: unchanged, bashy's POSIX make exactly as today (make is a POSIX utility; conformance must not move). (2) No makefile found but dag.md present (exactly where real make would fail with 'no makefile found'): 'bashy make [TARGET...]' runs 'bashy dag TARGET...' (no target = dag's default). Accept the flags agents type: -C DIR -> run in DIR; VAR=value -> environment; -j N, --no-print-directory, -s, -k, -B accepted and mapped or ignored; -n -> dag dry run if dag has one. Unknown targets fail with dag's own error listing the targets. (3) One stderr hint per run: 'make TARGET -> bashy dag TARGET (dag.md)', so the real command is learned; --json/agent mode carries it as a hint record. (4) Never emulate GNU make semantics (`$(shell ...)`, pattern rules) and never generate or keep a Makefile. Works the same when make is reached through PATH, the make applet, or strict mode (R8) since it is bashy's own command. Acceptance: in a repo with dag.md and no Makefile, 'make test', 'make -C bashy --no-print-directory test' and 'make VAR=1 build' run the dag targets with the right cwd/env and exit status; a repo with a Makefile behaves exactly as before (POSIX make tests unchanged); the hint appears once.
