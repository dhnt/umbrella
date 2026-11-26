---
id: 0fff3963a638
kind: task
title: 'R3 build: two bindings rebuild the second app from the spec, 3 runs each'
seq: 784
status: done
priority: p1
labels:
    - conform
created: 2026-11-26T11:23:44.225958Z
assignee: claude-fable5.2-s726
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
closed: 2026-11-26T21:34:24.897587Z
closed_by: claude-fable5.2-s726
---

Two bindings that passed on form, from two vendors, neither used in R1 or R2. Fixture = the R1 spec; hidden set = R2; harness, guard, grader and amended conditions as in Sprint 723 (docs/spec2src-protocol-v2.md). A short protocol note fixed before the runs; probe each binding in a real arm; gate with every non-pass classified. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (2026-11-26)

Changes after Sprint 731:
- The fixture is the spec release (the files listed in the app's `spec/README.md`, byte for byte) plus a `TASK.md` modelled on agent-bench `packs/spec2src/t1-form/fixture/TASK.md`.
- **Every build is also judged by the lifecycle end-to-end test (story E1)**: the spec's own `build`, `test`, `install`, `run`, `serve` and `stop` steps must work at the venue. A run passes when the behaviour grade passes and the lifecycle test passes; the two are reported separately.
- Builders follow kb runbook `shapeware-source-from-spec` only if they find it themselves; the task does not name it. The conductor notes what each builder guessed.
- Venue conditions that are now fixed and must stay: the runner with cleanup (agent-bench `4f1ed99`), headless lanes, a headless session host (no-op `open` and `xdg-open` in the drill's tool directory), one binding at a time per vendor, probe first, a quota refusal is a venue fault.
- Proposed bindings, to be confirmed by the operator: `codex-gpt6.1-terra` and `opencode-glm-5.3-flash`.
- No operate leg with an agent in this sprint (operator: not now).

## Result (2026-11-26)

Task agent-bench `packs/spec2src/t3-notepad` (`1beba5d`), protocol `docs/sprint-726-protocol.md` with amendments 1 and 2, runs one at a time on the session host, graded on gate lane 2.

| Binding | Run | Session | Behaviour (of 177) | Lifecycle | Classification |
|---|---|---|---|---|---|
| `claude-sonnet5.5` | smoke | 410 s | PASS, 177 | PASS | not scored |
| `codex-gpt6.1-terra` | 1, 2, 3 | 328, 359, 368 s | PASS, 177 each | PASS each | |
| `opencode-glm-5.3-flash` | 1 | 1,240 s | FAIL, 160 | FAIL (`test`) | builder: the API's JSON printed with spaces and another key order, compared as text; 3 of the 17 failing checks were visible |
| `opencode-glm-5.3-flash` | 2 | 1,501 s | PASS, 177 | PASS | |
| `opencode-glm-5.3-flash` | 3 | 747 s | nothing delivered | not run | builder: one nine-minute thinking step, then the turn ended; no provider refusal in the log |
| `opencode-glm-5.3` | 1 | 641 s | nothing delivered | not run | builder: the same pattern |
| `opencode-glm-5.3` | 2, 3 | stopped, not started | not measured | | closed by operator ruling |

`codex-gpt6.1-terra` passes, 3 of 3. `opencode-glm-5.3-flash` 1 of 3. `opencode-glm-5.3` not measured. **The story's bar of two vendors at 2 of 3 or better is not met; it is closed on the operator's ruling of 2026-11-26** (an issue with this vendor is reported and closed, with no further runs). The `opencode` tool has no one-shot probe, so its first cell was the check. No builder was seen using the kb runbook `shapeware-source-from-spec`. Snapshot of each `codex` build: one Python file, a launcher and `build.sh`. Report: `docs/sprint-726-report.md`.
