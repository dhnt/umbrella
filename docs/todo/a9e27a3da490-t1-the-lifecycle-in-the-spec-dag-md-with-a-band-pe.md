---
id: a9e27a3da490
kind: task
title: 'T1 the lifecycle in the spec: dag.md with a band per step, required by the linter and handed to the builder'
seq: 796
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:56:51.246113Z
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
---

Operator ruling 2026-11-26: no separate pipeline; the lifecycle is part of the spec. (1) form's spec folder carries its dag.md with a Band: line per step next to Effects:, per docs/shapeware-spec-v0.md section 5a. In a spec-only release the build step is the spec-to-source step (an agent at the stated band builds from the contract; the judge decides). (2) A conform spec check rule: the five steps exist and each states a band. Inspect conform spec/check.go and the dag.md parser in bashy first. (3) The spec2src task hands the builder that dag.md and asks it to make the steps work; the grader additionally checks at the venue that build, test and run work; the behavioural verdict is unchanged. One builder binding that passed in Sprint 723, 3 runs. Decide first what install means at a venue with no bashy (a launcher on PATH is the smallest answer) and write it into the step. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip'. Operator review before start.

## Progress and decisions (conductor, 2026-11-26)

Done before the handoff: the lint rules (conform `1be6b39`) and the band lines in `form`'s own `dag.md` (bashy `ecc8e527`).

Code inspected: agent-bench `packs/spec2src` (fixture, `task.yaml`, `selfcheck.py`, the grader adapter), bashy `examples/desk/form` at `ecc8e527` (`CONTRACT.md`, `dag.md`), the format §5a.

Parts (a) and (b), done in agent-bench `e662de6`:
- The fixture carries `dag.md`, the lifecycle of the app as a spec. Its steps run with `sh` from the folder and need no bashy: `source` (nothing to fetch), `build` (`sh ./build.sh`, supplied by the builder), `test` (`conform run CONTRACT.md --path . --fresh-home`), `install` (a launcher in `$PREFIX/bin`, default `$HOME/.local/bin`, that runs the folder's `./form`), `run` (`ARGS` split by `xargs`, never evaluated), `serve` (`./form serve` in the foreground; stops on INT or TERM). Bands: `none` for `source` and `test`, `unmeasured` for the rest.
- `TASK.md` v3 keeps the Sprint 723 text and adds one paragraph: `dag.md` is part of the spec, do not change it, make its steps work; `./form` must still work when `build` has not been run.
- `conform spec check` reports nothing on the fixture (gate lane, conform `5148116`); the pack selfcheck passes.

Decisions:
1. **The fixture moves to spec v2.1.** Spec v2 still carries the lint error that Sprint 723 found (a rule given by example). The standard says a lint error blocks the build, so the proof app cannot be built from a spec that fails lint. Cost: the grader controls are rerun with the v2.1 contract.
2. **`./form` still works cold.** The behavioural grade is unchanged from Sprint 723 and does not depend on `build`. The lifecycle check (build, test and run at the venue, by exit code) is an added layer of the grade.
3. **`install` needs nothing from the builder.** The step itself writes the launcher, so any implementation with `./form` installs the same way.
4. **`serve` is a requirement that comes from the lifecycle, not from the contract.** The contract has no serve and no stop verb: a form's page answers as soon as `form add` returns. A service that an operator agent starts and stops needs one, so the step states it, as the reference's own `dag.md` does. Finding for the standard: a spec whose app is a service needs a start and a stop that the contract can check.
5. Not in the MVP: showing the lifecycle result in the public result row (it is read from the private grade record).

Remaining: (c) the private grader runs `build`, `test` and `run` at the venue and reports their exit codes; controls; a smoke run, because the runner changed (bug `6afd1714`, fixed in agent-bench `4f1ed99`); (d) 3 runs with `codex-gpt6.1-terra`.
