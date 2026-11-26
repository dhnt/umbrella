# Handoff: Sprint 726 (the loop on a second app, `notepad`, run by agents)

*2026-11-26, from the conductor of Sprint 731 to the session that takes
Sprint 726. The stories were triaged the same day with the operator's
rulings. The sprint is in the backlog and has not been started; start it
only when the operator says so.*

## Goal

Rebuild `notepad` from a spec that an agent wrote, judged with hidden cases
that another vendor's agent wrote, by two builder bindings. Every role is
filled once by an agent. The conductor gates and records; it writes no
spec, no case and no source.

## Operator rulings for this sprint (2026-11-26)

- KISS and MVP. No story beyond the ones below.
- **The spec author also writes the lifecycle** (`spec/dag.md`), not the
  conductor.
- **No required owner review step.** The author still lists open questions.
- **No operate leg with an agent, and no extra planning stories, for now.**
- **Add an end-to-end test of the lifecycle** after the spec is written and
  after source is generated: the `dag.md` steps must build, install, run and
  serve. Mechanical, no model.
- **Use and test the kb runbooks** for source to spec and spec to source,
  and improve them during the sessions.
- Proof of concept, not a census. A quota refusal is a venue fault: defer.

## Reading order

1. The 726 card (`bashy sprint show 726`) and its five stories.
2. `docs/sprint-731-report.md` and `docs/shapeware-workflow-standard.md`:
   what was proven on `form`, and the stage table.
3. bashy `examples/desk/form`: the worked example. `CONTRACT.md` (spec
   v2.2, "Service rules", F-17 to F-20), `spec/dag.md` and `spec/README.md`
   (the spec's own lifecycle and the file list of a spec release).
4. kb runbooks (`bashy kb show <name>`): `shapeware-spec-from-app`,
   `spec-to-source-drill`, `shapeware-source-from-spec`,
   `shapeware-operate-from-dag`, and the retro
   `shapeware-drill-retro-sprints-722-725`.
5. `docs/spec2src-protocol-v2.md` with its amendments, and the run
   conditions written on the Sprint 731 stories `a9e27a3da490` and
   `b390ac728272`.

## Master execution plan

Stories run in this order. Each has one gate; nothing starts before the
gate before it has passed.

| # | Story | Who | What is delivered | Gate (all mechanical, on a claimed gate lane) |
|---|---|---|---|---|
| 0 | Start | conductor | lease taken, lane claimed, quota of the four role bindings checked, each binding probed | probes answer |
| 1 | R1 `7512c17bc9d5` spec from the app | spec author: `muse-wonder` | in bashy `examples/desk/notepad`: `SKILL.md`, `CONTRACT.md`, `features.yaml`, `examples/`, `spec/dag.md`, `spec/README.md`, and the missing steps and band lines in the folder's `dag.md` | lint clean on the folder and on the assembled spec release; the reference certifies 3 runs, none noisy; every mutant killed |
| 2 | E1 `2783fea521f4` lifecycle end-to-end test | a worker binding, or the conductor if it is a small edit of the form code | one test that runs every `spec/dag.md` step in order and checks the service | the reference passes; an empty folder fails; a folder with one broken step fails on that step alone. This closes R1 |
| 3 | R2 `f232758ae073` hidden cases | judge: `claude-opus5.5` | private hidden cases and the grader set-up for notepad | the reference passes 3 of 3 through the grader including the lifecycle phase; the empty workspace fails; digests recorded |
| 4 | Fixture, protocol, smoke | conductor | agent-bench fixture (the spec release plus `TASK.md`), a short protocol note fixed before the runs, one smoke run with a binding that is not a subject | the chain runs end to end |
| 5 | R3 `0fff3963a638` builds | builders: `codex-gpt6.1-terra`, `opencode-glm-5.3-flash` | 3 runs each | per run: the behaviour grade and the lifecycle test, reported separately; every non-pass classified from the logs before it is counted |
| 6 | R4 `13c5d160eabf` close | conductor | measured bounds in notepad's `SKILL.md`; a short report; runbook fixes for every guess noted in R1 to R3 | scrub gate; kb pages edited with the `bashy kb` verbs |

The role bindings are a proposal: confirm them with the operator at the
start. They are from four vendors so that no model family judges its own
work. None of them may be used as a worker on a drill-related story.

Stories 1 and 3 are role sessions: one session each, with the story text
as the whole brief. Story 2 can be prepared while story 1 runs. The slow
step is the mutation check in story 1 (17 minutes on form's 21 assertions);
schedule the lane for it.

## What already exists, so nothing is built twice

- **Runner:** agent-bench `DAG.md` with cleanup on every exit path
  (`scripts/reap.py`). Drill scripts: `packs/spec2src/venue/` (`env.sh`,
  `probe.sh`, `run.sh`, `guard.sb.template`).
- **Form tasks to copy:** `packs/spec2src/t1-form` (build) and
  `packs/spec2src/t2-operate` (its `reference/operate.sh` runs every
  lifecycle step as a plain script).
- **Private grader:** the form grader v2.4 in the private docs repository,
  with its README (controls, digests, venue notes). Its lifecycle phase is
  the starting point for E1.
- **Private drill directory:** the Sprint 723 one on the dev box (frozen
  adapter cache, the subject's judge, the guard, no-op `open` and
  `xdg-open`). The guard's paths are tied to that directory, so reuse it
  with new batch names, or build a new one from the template.
- **Judge:** conform v0.1.1 for grading and certification; a build from
  conform main for `conform spec check`. Both are on gate lane 2.

## Traps (each one cost time in Sprint 731)

- **Venue first.** Three results that looked like failures were venue
  faults: a display exported on the test host, a real browser opened on
  the session host by a build that calls `open`, and a shell that shadows
  the judge. Lanes are headless now (`script/gate-lane.sh`); the drill's
  tool directory must hold no-op `open` and `xdg-open`; run scripts under a
  plain system shell with a PATH that has no bashy shims.
- **Never run a form-creating or page-opening loop on the dev box without
  the no-op `open`.** It fills the operator's browser with tabs.
- **The reference decides what the spec may demand.** Run every lifecycle
  step and every new assertion on the reference, several times, before any
  builder sees it. On form this found a race in the reference's `stop` and
  two product defects (coreutils todo `8302f07a`, bashy todo `941f35b6`).
- **A service needs a stop the contract can check.** A signal is not one
  while bashy todo `941f35b6` is open.
- **`conform cert` needs `--dir`** set to the folder that holds the
  examples, or every assertion that reads a file is reported as noisy.
- **Judge runs leave server processes on the lane** (conform todo
  `20ee398e`). Stop them by their path after each certification.
- **Sprint mechanics:** export the lease token before sprint commands;
  `accept` needs `submit`, and a conductor-done story needs `claim` first;
  commit by pathspec in shared checkouts, and work on a submodule through a
  worktree off its origin main; take a story's full id from its file.
- **The gate host's display server is in a restart loop** (todo
  `13d4dc76`). Lanes no longer see it. The Sprint 731 conductor restarts
  the host's Linux subsystem once to stop it; check the todo for the state.

## Not in this sprint

The owner review as a required step, an operate leg with an agent, the
judge study, the instructions path for notepad (`e130889b`), stepping any
ladder further down, and Sprint 730.
