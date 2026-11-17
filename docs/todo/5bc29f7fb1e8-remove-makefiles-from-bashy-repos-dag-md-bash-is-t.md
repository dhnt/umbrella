---
id: 5bc29f7fb1e8
kind: chore
title: 'Remove Makefiles from bashy repos: dag.md (Bash#) is the only build and test entry point'
seq: 422
status: todo
priority: p1
created: 2026-11-17T18:53:51.603903Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Operator 2026-11-17: Makefiles constantly cause pain; remove them from every bashy repo. Released bashy builds itself with bashy dag (Bash#) and must never assume GNU make. Found during rc.37: (1) bashy dag test covers less than make test: the Makefile's test target also runs eight script checks (test-meet-spa-fresh-regression, test-build-fail-closed, test-isolated-lanes, test-release-qa-lane, test-build-tag-matrix, test-bash-container-mode, verify-bashy-scratch, test-startup-linux) that dag.md does not; (2) three of those scripts call make themselves (test-build-fail-closed.sh, test-bash-container-mode.sh, verify-bashy-scratch.sh), and the Bash 5.3 gate scripts call make test-bash-fixtures / make test-bash-container; (3) under bashy, make resolves to bashy's POSIX make, which rejects GNU flags such as --no-print-directory, so make-based drivers fail in the official image. Scope: port every Makefile target that is still used to dag.md tasks (the release gate: test incl. the eight checks, test-bash-gate both modes, test-bash-fixtures, build-bashy-scratch, install), make the scripts call bashy dag instead of make, update docs (CLAUDE.md build commands, docs/build.md, release runbooks, CI workflows) and remove the Makefiles. Start with bashy, then yoke, coreutils, sh, outpost and the other subprojects that have one. Acceptance: no Makefile in the repo; bashy dag test runs the full former make test set and passes in the official build image; the release gate commands in CLAUDE.md are bashy dag targets; grep finds no make invocation in scripts.
