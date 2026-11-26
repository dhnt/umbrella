# Sprint 731: the full trip on `form`, from spec to a running service

*2026-11-26 · conductors: claude-opus5.5 (start), then claude-fable5.2 · conditions: `spec2src-protocol-v2.md` with amendments 1 to 6, plus the run conditions written on stories T1 (`a9e27a3da490`) and T2 (`22ae09040935`) before their runs.*

## Answer (narrow)

With the lifecycle inside the spec, bashy's `form` went the whole way by agents: a builder made the spec's lifecycle steps work while rebuilding the app from its contract, and two lower-tier agents then took a built folder, cold, through build, test, install, one command, serve, fetch the page and stop. A plain script with no model did the same. These are observations from these runs, with these exact bindings; n = 3 per binding.

| Stage (the standard, §3) | Who did it | Gate | Result | Band |
|---|---|---|---|---|
| 1 Instructions to spec | the conductor, from the existing app (reverse step) | owner review: not run | spec v2.1 exists | unmeasured |
| 2 Compile the spec | no model | `conform spec check` | nothing reported on the spec with its lifecycle | none |
| 3 Spec to source | `codex-gpt6.1-terra` | the judge: visible contract, 9 hidden cases, page interaction | **3 of 3**, 36 of 36 checks each | passes at this binding; lower tiers not run |
| 4 Source to artifact (`build`) | the same builder supplies `build.sh`; the grader runs the step | exit 0 at the venue | 3 of 3 | none: an exact step |
| 5 End-to-end test (`test`) | no model | the contract on the fresh build, exit 0 | 3 of 3 (one first grade failed on a venue fault, below) | none |
| 6 Install | `codex-gpt6-luna`, `opencode-glm-5.3-flash`, and a script | launcher installed; consent gate: not built | **3 of 3** each | passes at these bindings and with no model |
| 7 Run and serve | the same | the contract against the installed app; the saved answer and page | **3 of 3** each | the same |
| 8 Field shaping | not part of this sprint | | | |

## What was built for it

- **A lifecycle for the app as a spec** (agent-bench `packs/spec2src/t1-form/fixture/dag.md`). Its steps run with `sh` and need no bashy: `build` runs the builder's `build.sh`; `test` runs the judge on the contract; `install` writes a launcher on the PATH; `run` takes `ARGS`; `serve` runs the service in the foreground. The builder may not change the file and must make the steps work.
- **A lifecycle check in the private grader** (v2.2, then v2.3): after the behaviour grade it runs the spec's own `build`, `test` and `run` steps on a fresh copy of the snapshot and reports their exit codes.
- **The operate drill** (agent-bench `packs/spec2src/t2-operate`): a built folder as the fixture, a mechanical grader, and a no-model control script.
- **A runner that cleans up** (agent-bench `4f1ed99`, bug `6afd1714`): it stops every process tied to a run's directories and removes them on every exit path. In the eleven sessions of this sprint it stopped 4 to 10 leftover processes each time and left none.

## Every run

| Drill | Binding | Verdict | Session | Note |
|---|---|---|---|---|
| build, smoke | codex-gpt6-sol | PASS | 354 s | not scored |
| build 1 | codex-gpt6.1-terra | PASS | 308 s | lifecycle: build, test, run exit 0 |
| build 2 | codex-gpt6.1-terra | PASS | 293 s | first grade: `test` exit 1, venue fault; regraded |
| build 3 | codex-gpt6.1-terra | PASS | 379 s | |
| operate, control | no model (script) | PASS | seconds | |
| operate, smoke | codex-gpt6-sol | PASS | 278 s | not scored |
| operate 1 to 3 | codex-gpt6-luna | PASS, PASS, PASS | 267, 242, 262 s | |
| operate 1 to 3 | opencode-glm-5.3-flash | PASS, PASS, PASS | 283, 434, 434 s | |
| operate | agy-gemini3.8-flash | not measured | - | quota refusal at the probe |

Operate sessions include the runner's 150 seconds of quiet before it ends a session.

## Findings

1. **The lifecycle steps are exact, so operating needs very little.** A script with no model passes the operate task. The two agent bindings tried passed 3 of 3 cold. The plan's hypothesis that stages 4, 6 and 7 need a much lower band than stage 3 holds for this app, as a bound.
2. **Handing the builder the lifecycle costs nothing.** The same binding that passed 3 of 3 without it in Sprint 723 passed 3 of 3 with it, in about the same time (293 to 379 s against 328 to 363 s).
3. **A service needs a start and a stop that the spec defines.** The contract makes a form's page answer as soon as `form add` returns, so every build starts its own background server. The `serve` step did not say what happens when that server is already running: of three builds, one ran in the foreground, one returned at once, one failed on the busy port. The contract has no stop. This is a spec gap, found only because the lifecycle was exercised.
4. **A spec that fails lint cannot be the proof.** The fixture moved from spec v2 to v2.1 because v2 still carried the lint error found in Sprint 723, and the standard says a lint error blocks the build.
5. **The reference decides what a lifecycle may demand.** The first `serve` step said "exits 0 on TERM"; the reference ends with the signal's status. The step was corrected before any scored run.
6. **One more venue fault that looked like a build failure.** One `test` step timed out on its first command. Cause: the test host exported a display whose server was in a crash loop, and a desktop query made by Python's `webbrowser` module hung for 15 to 45 seconds. The grader now hides the display from every candidate phase; controls were rerun and both grades are kept. The host fault is filed as todo `13d4dc76`.
7. **Where the spec's lifecycle lives is undecided.** `form`'s folder in bashy carries the reference build's lifecycle, whose steps run through bashy. The `sh` lifecycle that was measured exists only in the drill fixture. A spec folder that is also a built app needs one answer.

## Bands recorded

In bashy `examples/desk/form/SKILL.md` (`4b8cc25f`), as bounds by binding with the date: building from the spec, and operating a built folder. Registry bands for these bindings are still seeded, so no level is stated. The `Band:` lines of the folder's own bashy-run `dag.md` stay `unmeasured`.

## Limits

- One app, one built folder for the operate drill, n = 3 per binding, two vendors per drill at most.
- The spec, the spec-only lifecycle, the hidden cases, the grader changes and every classification were written by the conductor.
- The operate ladder was not stepped below the two bindings: the registry's lower bindings are billed by usage or have no door on the test host.
- Operate sessions and their grade ran on the session host inside an isolated HOME; build grades ran on the Linux test host.
- The consent gate, the owner review and field shaping were not exercised.
- Tokens and cost were not recorded.

## What comes next

The operator review of `shapeware-workflow-standard.md` (story W3), with the open items of its section 11 and three questions from this trip: what `serve` and stop mean for a service app; where a spec's own lifecycle lives when the folder is also the reference build; and whether the usage-billed and local bindings should be run to step the operate ladder down.
