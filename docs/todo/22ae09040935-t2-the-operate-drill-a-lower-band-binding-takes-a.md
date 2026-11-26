---
id: 22ae09040935
kind: task
title: 'T2 the operate drill: a lower-band binding takes a built folder through build, test, install, run and serve, cold'
seq: 797
status: done
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:56:51.585032Z
assignee: claude-fable5.2
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
closed: 2026-11-26T15:15:24.202974Z
closed_by: claude-fable5.2
---

A new small drill (agent-bench pack task): the subject gets one passing T1 folder and its run block, with no other context, and must run the lifecycle: build, test, install, one CLI command with the expected answer, start the service, fetch the page, stop the service. Graded mechanically: exit codes, the contract run against the installed app, and no step improvised outside dag.md. Start one band below the builder and step down, 3 runs per binding; include a small local model on the test host if one is registered. Protocol note before runs; probes; quota check. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip' (operator 2026-11-26). Reuse agent-bench packs/spec2src with venue/, the Sprint 723 grader and kb runbook spec-to-source-drill. Operator review before start.

## Protocol for the operate drill, fixed before any run (conductor, 2026-11-26)

**Question.** What is the least agent that can take a built `form` folder, cold, through its lifecycle exactly as `dag.md` writes it: build, test, install, one command, serve, fetch the page, stop?

**Task.** agent-bench `packs/spec2src/t2-operate` (story `407c6bd8df99` builds its grader). The fixture is the graded snapshot of T1 run 2 (`codex-gpt6.1-terra`; behaviour 36 of 36; its `serve` runs in the foreground) with the spec's `dag.md` and an operate `TASK.md`. The subject gets that folder and nothing else. Code inspected: the fixture, the runner's `spec2src` path, `scripts/arm_home.py`.

**Pass rule per run, all mechanical.** No file of the folder changed; the launcher is installed in the subject's HOME; the contract passes against the installed app (the judge, 16 assertions and the page inventory); `answer.json` holds the pending form `drill-1`; `page.html` holds every field label. The subject's own `report.txt` is recorded and decides nothing. Result per binding: k of 3; 2 of 3 or better passes.

**Controls, before any subject.** The untouched folder fails. `reference/operate.sh`, a plain script with no model, passes: that is the `none` baseline, and it shows the steps are exact.

**Subjects and order.** Flat-billed bindings only, below the builder's tier, one vendor at a time, probe first: (1) `codex-gpt6-luna`; (2) `agy-gemini3.8-flash`; (3) `opencode-glm-5.3-flash`, if its plan has quota. One step per vendor gives a bound, not a minimum. Not run, and said so in the report: the registry's L2 bindings (all billed by usage; they need the operator's approval) and the local model `genie-gpt-oss-20b` (it must be served from the test host, never from the dev box; no such door is set up).

**Conditions.** The Sprint 723 arm conditions (isolated HOME, guard, plain system shell, frozen adapter cache, the judge on the PATH), through `packs/spec2src/venue/run.sh` with `S2S_TASK=t2-operate`, at the runner with the cleanup fix. The session and its grade run on the session host, inside the arm; the wall-time cap is the runner's. Headless: `BROWSER` is set to a no-op so that no build opens a browser window on the session host. A provider refusal is a venue fault: the cell is rerun and both attempts are kept. Every non-pass is classified (spec gap, agent defect, judge defect, venue fault) from the screen log before it is counted.

**Disclosures.** The task, the grader rules and every classification are the conductor's. The worker that writes the grader (`codex-gpt6.2-astra`) is not a subject. Registry bands are seeded; results are reported by exact binding name.

**Known limit carried from T1.** The `serve` step does not say what happens when the app's own background server is already running; 2 of 3 T1 builds did not serve in the foreground. The drill uses the build that does.

## Result (2026-11-26)

Task and grader: agent-bench `packs/spec2src/t2-operate` (`3972d8e`, story `407c6bd8df99`). Controls before any subject: the untouched folder FAILs (nothing installed); the plain script `reference/operate.sh`, with no model, PASSes every check with the real judge. Smoke (not scored): `codex-gpt6-sol` PASS, 278 s.

| Binding | Runs | Result | Sessions | Note |
|---|---|---|---|---|
| no model (`reference/operate.sh`) | control | PASS | seconds | the steps are exact |
| `codex-gpt6-luna` | 3 | **3 of 3** | 267, 242, 262 s | every check passed in every run |
| `opencode-glm-5.3-flash` | 3 | **3 of 3** | 283, 434, 434 s | its tool cannot answer a one-shot probe; the first run was the check |
| `agy-gemini3.8-flash` | 0 | not measured | - | the probe was refused: plan quota reached. Venue fault; no run started; left to a later drill |

Session times include the runner's 150 seconds of quiet before it ends a session. Every pass is complete: no file of the folder changed, the launcher installed in the subject's HOME, the contract passing against the installed app, the pending form in `answer.json`, every field label in `page.html`. Each subject reported exit status 0 for build, test, install and run, and the signal's status for the stopped service. After each run the runner stopped the processes tied to the run (4 to 6) and left no directory behind.

**What this measures.** Operating a built `form` folder through the spec's lifecycle needs no model when the steps are run as a script, and both agent bindings tried, each from a tier at or below the builder's, did it cold 3 of 3. The ladder was not stepped further down: the registry has no flat-billed binding below these (its L2 bindings are billed by usage and need the operator's approval; the local model has no door on the test host). So the result is a bound.

**Limits.** One app, one built folder (the Python build whose `serve` runs in the foreground), n = 3, two vendors. The session and its grade ran on the session host inside the isolated HOME, not on the Linux test host. "No step improvised" is checked only through its effects (no file changed, the installed app passes the contract); the screen logs were not audited step by step. The task, the grader rules and the classification are the conductor's.
