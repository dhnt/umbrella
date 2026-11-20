---
id: d9bf47e9554b
kind: feature
title: bashy make falls through to bashy dag when there is no Makefile but a dag.md (agents' make habit, dag.md the only source)
seq: 423
status: done
priority: p1
created: 2026-11-17T18:59:32.514563Z
assignee: muse-wonder-full
sprint: 678
sprint_id: e2cf7613-74c4-537f-ad54-327d8dcebbc1
sprint_title: Discover dag.md project tasks through make help
closed: 2026-11-20T20:46:09.516142Z
closed_by: claude-opus5.5
---

Operator 2026-11-17 (approved design): companion of 5bc29f7fb1e8 (remove Makefiles). bashy is for agents, and agents reach for make. Rules: (1) A Makefile present: unchanged, bashy's POSIX make exactly as today (make is a POSIX utility; conformance must not move). (2) No makefile found but dag.md present (exactly where real make would fail with 'no makefile found'): 'bashy make [TARGET...]' runs 'bashy dag TARGET...' (no target = dag's default). Accept the flags agents type: -C DIR -> run in DIR; VAR=value -> environment; -j N, --no-print-directory, -s, -k, -B accepted and mapped or ignored; -n -> dag dry run if dag has one. Unknown targets fail with dag's own error listing the targets. (3) One stderr hint per run: 'make TARGET -> bashy dag TARGET (dag.md)', so the real command is learned; --json/agent mode carries it as a hint record. (4) Never emulate GNU make semantics (`$(shell ...)`, pattern rules) and never generate or keep a Makefile. Works the same when make is reached through PATH, the make applet, or strict mode (R8) since it is bashy's own command. Acceptance: in a repo with dag.md and no Makefile, 'make test', 'make -C bashy --no-print-directory test' and 'make VAR=1 build' run the dag targets with the right cwd/env and exit status; a repo with a Makefile behaves exactly as before (POSIX make tests unchanged); the hint appears once.

## Placement and a related finding (2026-11-17)

- `make` is bashy's pure-Go POSIX make, `coreutils/cmds/make` (`make --version`
  under bashy: `make (qiangli/coreutils) dev`), so the interception needs no
  Makefile and no host make. It must live in bashy's command dispatch, before
  the coreutils applet: coreutils stays POSIX-only and bug-fix-only, and may
  not import yoke (where dag lives). With any makefile present, dispatch
  passes through to the applet unchanged, so the POSIX make is untouched.
- `type make` in the same shell reports `make is /usr/bin/make` while `make`
  runs the coreutils applet. `type` / `command -v` must name what actually
  runs (agents check with `command -v` before running); fix together, and
  include it in the acceptance.


## Release placement (2026-11-18)

Per operator instruction, moved from Sprint655 into follow-up Sprint660 after rc38. Current certification sources and release timing candidate remain frozen. The actual Makefile inventory includes Bash, Bashy, Bonsai, Gfy, Nadir, Outpost, Readline and legacy sh; Yoke and Coreutils currently have no Makefile. Remove only existing files after their used targets have equivalent DAG gates. Preserve pure Go POSIX make; place fallback in Bashy dispatch. Build-tooling changes are already operator-authorized and need no new approval. Keep interpreter/runtime implementation frozen and require named fixture equivalence, including both86-fixture modes. No implementation has started.

S655 correction: the tooling freeze must not be interpreted as a new approval requirement. Legacy sh targets to port include test-full, bashpp-race-gate, fmtcheck, hooks and tidy plus test.yml/full-tests.yml. Readline currently lacks dag.md; record its upstream-maintenance trade-off. Bashy DAG currently lists the eight checks; verify current behavior and remaining script-level make calls instead of assuming the historical dependency gap persists.
