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

## After the operator review: spec v2.2 (same day)

The operator ruled that the serve and stop gap (finding 3) and the place of the spec's lifecycle (finding 7) be resolved, not carried.

- **Spec v2.2** (bashy `9ee40025`): the contract gains service rules and assertions F-17 to F-20. `form stop` stops the user's server and exits 0 whether or not one runs; stored forms are kept; the next `form add` starts the server again. What a signal does is left free. The lifecycle gains a `stop` step, and `serve` stops any running server first, so it behaves the same for every build.
- **A spec is self-contained.** A spec release is its own folder with one `dag.md`. The reference folder keeps the spec's lifecycle in `spec/dag.md`, with `spec/README.md` listing the files of a release; the drill fixture copies them byte for byte.
- **Certification:** lint clean on the folder and on the assembled release; the reference passes 21 of 21 over 10 runs with no noisy assertion; 127 of 127 mutants killed.

| Drill on v2.2 | Binding | Result | Sessions |
|---|---|---|---|
| build | codex-gpt6.1-terra | **3 of 3**: behaviour 40 of 40 each; lifecycle with the service (serve alive, the page answers, stop exits 0, the page is gone) in all three | 327, 311, 297 s |
| operate, control | no model (script) | PASS, including the page gone after stop | seconds |
| operate | codex-gpt6-luna | **3 of 3** on every mechanical check | 236, 247, 283 s |

Before v2.2, `serve` worked as a service in 1 of 3 builds; with the rule defined it works in 3 of 3.

What the new assertions and the reruns exposed:

8. **A race in the reference's own `stop`** (about 2 of 8 stops failed): it removed a state file that the stopping server removes too. Fixed in the reference (bashy `d486a5d0`); 0 failures in 30 cycles afterwards. The first certification had passed 3 of 3 by luck, which is why it was repeated with 10 runs.
9. **Two product defects, filed and not fixed (frozen baseline):** the pure-Go `rm -f` fails when the file vanishes just before the unlink (coreutils todo `8302f07a`); and in bashy `exec PROGRAM` does not replace the shell, so the program survives a TERM sent to the shell (bashy todo `941f35b6`). The second is why the reference's server survived TERM, and why the stop had to be a verb.
10. **A venue fault on the session host.** In one operate run the subject's own `test` step exited 1. Cause: the build opens its page by calling the system `open`, which put a real tab in the operator's browser; the browser's open connection blocked the build's server, which handles one connection at a time, and the judge's page fetch timed out (11 of 15 repeats). The drill venue now requires no-op `open` and `xdg-open`; 0 of 15 repeats fail. The mechanical grade of that run was not affected.
11. **A behaviour the contract cannot see yet.** A build whose server handles one connection at a time passes every assertion on a headless venue and stalls as soon as a browser holds a page open. A case with two clients would catch it; none exists.
12. **The gate host fault of finding 6 has a root cause:** the host's GUI layer is in a restart loop because its remote-display client gets a display of size zero. Every lane is headless now (`script/gate-lane.sh`), so no run can reach it.

## What comes next

Sprint 726: the same loop on a second app, `notepad`, with an agent in every role, the spec author writing the lifecycle, and a mechanical end-to-end test of the lifecycle after the spec and after every build (`handoff-sprint-726.md`). Left for later by the operator: stepping the operate ladder further down, and the open items of section 11 of the standard other than Sprint 726.
