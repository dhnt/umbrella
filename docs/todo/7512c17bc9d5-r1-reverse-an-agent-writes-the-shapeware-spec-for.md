---
id: 7512c17bc9d5
kind: feature
title: 'R1 reverse: an agent writes the shapeware spec for the second app'
seq: 782
status: todo
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.465764Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

One binding (spec author) writes CONTRACT.md, features.yaml, examples and the behaviour section of SKILL.md for the second app, following kb runbook shapeware-spec-from-app. Done when conform spec check is clean, the reference certifies (3 runs, no noisy assertion) and every mutant is killed, all on a gate lane. No change to the app's behaviour. The conductor gates; it does not write the spec. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (operator rulings 2026-11-26, after Sprint 731)

Code inspected (bashy main `3d708c4f`): `examples/desk/notepad` is a Go app of about 3,600 lines (`main.go`, `cli.go`, `convert.go`, `export.go`, tests, `notepad.bsh`, `register.sh`, `shaped.json`, `contract.bsh`). Its `dag.md` has `serve`, `test`, `register` and `show`, with no `Band:` lines and without `source`, `build`, `install`, `run` or `stop`. It has no `SKILL.md`, `CONTRACT.md` or `features.yaml`. `form` (same folder level, spec v2.2) is the worked example of everything asked here.

Added to this story:
1. **The spec author also writes the lifecycle.** Besides `CONTRACT.md`, `features.yaml`, `examples/` and `SKILL.md`: `spec/dag.md`, the lifecycle of the app as a spec, and `spec/README.md`, the file list of a spec release, in the layout of `examples/desk/form/spec/`. Steps run with `sh` and need no bashy: `source`, `build`, `test`, `install`, `run`, and for this service `serve` and `stop`, each with `Effects:` and `Band:` (`none` or `unmeasured`). The contract defines how the service is stopped, with at least one assertion (form's "Service rules", F-17 to F-20, are the model). The folder's own `dag.md` gains the missing steps and band lines so the lint passes on the reference folder too.
2. **The author works from the kb runbook** `shapeware-spec-from-app` (`bashy kb show shapeware-spec-from-app`; shipped in bashy `kb/defaults`), not from the conductor's coaching. The conductor notes every point where the author had to guess or the runbook was wrong, and those become runbook fixes in R4.
3. **Done** is unchanged and adds: `conform spec check` reports nothing on the reference folder and on the assembled spec release; the reference passes the lifecycle end-to-end test of story E1.
4. No owner review step is required (operator: not needed for this sprint). The author still lists open questions in the spec; the conductor records them for the report.

Lessons from form that the brief to the author must carry: a rule given by example is a lint error, define the set; a service needs a stop that the contract can check (a signal is not one: bashy todo `941f35b6`); state the venue; the reference decides what the lifecycle may demand, so run every step on the reference before claiming it.
