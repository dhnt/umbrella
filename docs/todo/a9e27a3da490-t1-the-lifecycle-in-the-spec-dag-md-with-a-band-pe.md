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

## Run conditions for part (d), fixed before the scored runs (2026-11-26)

Base: `docs/spec2src-protocol-v2.md` with amendments 1 to 6 (conditions, isolation, grading venue, classification and rerun rules). Changes for these runs only:

- **Question:** can a builder that passed on `form` also make the spec's lifecycle steps work, with the behaviour verdict unchanged?
- **Subject:** `codex-gpt6.1-terra`, 3 runs, one at a time, after a probe. It passed 3 of 3 in Sprint 723 on spec v2.
- **Fixture:** agent-bench `a39dac5`: spec v2.1 (contract digest `50fc5bd76199390c`), `dag.md` (`46765725181c086b`), `TASK.md` v3 (`105009067f2f88c3`).
- **Runner:** agent-bench `4f1ed99` (cleanup on every exit path), started through `packs/spec2src/venue/run.sh` with the Sprint 723 private drill directory, guard, frozen adapter cache and subject judge.
- **Grader:** v2.2. Behaviour as in Sprint 723: the visible contract (now 16 assertions and the page inventory), the 9 hidden cases, the page interaction. Added: the lifecycle check, which runs the spec's own `build`, `test` and `run` steps on a fresh extraction of the snapshot; `serve` is started and stopped for information.
- **Pass rule per run:** behaviour PASS on every layer, and `build`, `test` and `run` exit 0. Reported as k of 3, with the two parts shown separately.
- **Controls (gate lane 2):** empty workspace FAIL on every layer and on the lifecycle; the reference with no `build.sh` PASS 36 of 36 with the lifecycle failing on `build` alone; the reference with a `build.sh` PASS 36 of 36 and lifecycle PASS, 4 of 4.
- **Smoke (not scored):** `codex-gpt6-sol`, PASS 36 of 36, lifecycle PASS, 354 s; the runner stopped 6 processes tied to the run's directories and left no directory behind.
- **Disclosures:** the spec-only `dag.md`, the grader change and every classification are the conductor's. `codex-gpt6.2-astra` wrote the runner fix as a worker; it is not a subject. The subject's judge runs on the session host, the grader on the stated Linux venue.

## Result of part (d) (2026-11-26)

`codex-gpt6.1-terra`, 3 runs on the fixture with the lifecycle: **3 of 3**.

| Run | Session | Behaviour (36 checks) | build | test | run | serve (information) |
|---|---|---|---|---|---|---|
| 1 | 308 s | PASS 36/36 | 0 | 0 | 0 | returned at once with status 0 |
| 2 | 293 s | PASS 36/36 | 0 | 0 (first grade: 1, venue fault, see below) | 0 | ran in the foreground, stopped on TERM |
| 3 | 379 s | PASS 36/36 | 0 | 0 | 0 | failed: address already in use |

The behaviour verdict is unchanged from Sprint 723 (3 of 3). The builder made `build`, `test` and `run` work in every run. After each run the runner stopped the processes tied to the run's directories (7, 6 and 10) and left no directory behind.

**One venue fault, root cause recorded before the fix.** Run 2's first grade failed the `test` step: the first contract command timed out at the judge's 30-second step limit. Cause: the test host's login session exports a display, and its display server was in a crash loop. Python's `webbrowser` module asks the desktop for the default browser when a display is set, and that query hung for 15 to 45 seconds until the display server restarted (measured directly: 3 of 123 calls). Run 2's build is Python and opens the page with that module. Classification: environment. Fixed in the venue: grader v2.3 hides the display from every candidate phase, as a headless venue should. Controls were rerun and the three snapshots regraded; both grades of every run are kept. The same snapshot also passed 5 of 5 regrades under v2.2.

**One spec gap, in the lifecycle (not a builder defect).** `serve` worked as a foreground service in 1 of 3 builds. The contract makes a form's page answer as soon as `form add` returns, so every build starts its own background server; the `serve` step does not say what happens when that server is already running. One build returned at once, one failed on the busy port. The step needs one more sentence (for example: when a server for this user is already running, `serve` attaches to it or replaces it), and the app needs a stop. Carried to T2 (the operate drill uses the build whose `serve` works) and to the standard.

Evidence: results rows and first grades in the private drill directory (batches `t1-731-1` to `-3`), regrades and controls in the Sprint 731 private directory; grader README in the private docs repository (v2.2 and v2.3, digests).
