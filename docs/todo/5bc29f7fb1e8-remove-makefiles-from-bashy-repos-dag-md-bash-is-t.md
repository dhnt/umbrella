---
id: 5bc29f7fb1e8
kind: chore
title: 'Remove Makefiles from bashy repos: dag.md (Bash#) is the only build and test entry point'
seq: 422
status: done
priority: p1
created: 2026-11-17T18:53:51.603903Z
assignee: claude-opus5.5
sprint: 660
sprint_id: 666d2a0c-b433-5286-880b-b5b02134f5cf
sprint_title: 'Post-rc38: DAG-only build entrypoints and Bashy make fallback'
closed: 2026-11-23T17:43:14.651075Z
closed_by: claude-opus5.5
---

Operator 2026-11-17: Makefiles constantly cause pain; remove them from every bashy repo. Released bashy builds itself with bashy dag (Bash#) and must never assume GNU make. Found during rc.37: (1) bashy dag test covers less than make test: the Makefile's test target also runs eight script checks (test-meet-spa-fresh-regression, test-build-fail-closed, test-isolated-lanes, test-release-qa-lane, test-build-tag-matrix, test-bash-container-mode, verify-bashy-scratch, test-startup-linux) that dag.md does not; (2) three of those scripts call make themselves (test-build-fail-closed.sh, test-bash-container-mode.sh, verify-bashy-scratch.sh), and the Bash 5.3 gate scripts call make test-bash-fixtures / make test-bash-container; (3) under bashy, make resolves to bashy's POSIX make, which rejects GNU flags such as --no-print-directory, so make-based drivers fail in the official image. Scope: port every Makefile target that is still used to dag.md tasks (the release gate: test incl. the eight checks, test-bash-gate both modes, test-bash-fixtures, build-bashy-scratch, install), make the scripts call bashy dag instead of make, update docs (CLAUDE.md build commands, docs/build.md, release runbooks, CI workflows) and remove the Makefiles. Start with bashy, then yoke, coreutils, sh, outpost and the other subprojects that have one. Acceptance: no Makefile in the repo; bashy dag test runs the full former make test set and passes in the official build image; the release gate commands in CLAUDE.md are bashy dag targets; grep finds no make invocation in scripts.


## Release placement (2026-11-18)

Per operator instruction, moved from Sprint655 into follow-up Sprint660 after rc38. Current certification sources and release timing candidate remain frozen. The actual Makefile inventory includes Bash, Bashy, Bonsai, Gfy, Nadir, Outpost, Readline and legacy sh; Yoke and Coreutils currently have no Makefile. Remove only existing files after their used targets have equivalent DAG gates. Preserve pure Go POSIX make; place fallback in Bashy dispatch. Build-tooling changes are already operator-authorized and need no new approval. Keep interpreter/runtime implementation frozen and require named fixture equivalence, including both86-fixture modes. No implementation has started.

S655 correction: the tooling freeze must not be interpreted as a new approval requirement. Legacy sh targets to port include test-full, bashpp-race-gate, fmtcheck, hooks and tidy plus test.yml/full-tests.yml. Readline currently lacks dag.md; record its upstream-maintenance trade-off. Bashy DAG currently lists the eight checks; verify current behavior and remaining script-level make calls instead of assuming the historical dependency gap persists.

## Amendment (2026-11-20, Sprint 678)

Operator decision: remove hand-written Makefiles by REPLACING each with the generated forwarder from `bashy dag --makefile` (Sprint 678, fa9fcc8d), not by deleting them, so agents that look for a Makefile are taught to use `bashy dag`.

## Plan (2026-11-20)

Split into R1 f0e5c330f202, R2 4fc314bff7b9, R3 a97acb748321, R4 bbd047d08c53 per docs/plan-s660-generated-makefiles.md; this story is the parent and closes when all four close (sh skipped as legacy).

## Closure (2026-11-23, conductor claude-opus5.5)

All four children are closed:

| Story | Scope | Merged as | Closed |
|---|---|---|---|
| R1 f0e5c330f202 | bash, outpost | bash `bb200ccf`, outpost `c132137` | 11-20 |
| R2 4fc314bff7b9 | bonsai, gfy, nadir, readline | bonsai `fbc9342`, gfy `55f6a13`, nadir `72bbe85`, readline `4161b95` | 11-20 |
| R3 a97acb748321 | bashy targets, scripts and CI | bashy `289d60e4` | 11-21 |
| R4 bbd047d08c53 | bashy forwarder | bashy `74100d67` + `4fe6599e`, umbrella `e8d799851` | 11-23 |

Verification:

- Every delivery commit is on its repo's origin default branch.
- Every one is contained in the umbrella `origin/main` gitlinks.
- R4's release-gate equivalence evidence is recorded on bbd047d08c53.

The sh repo was skipped as legacy, per the plan. yoke and coreutils have no
hand-written Makefile. Coreutils' POSIX make is unchanged. The make fallback
moved to Sprint 678.

Acceptance is met as amended on 2026-11-20: Makefiles are replaced by the
generated forwarder rather than deleted. Close.
