# Sprint 726: protocol for the notepad builds (fixed before the runs)

*2026-11-26. A short addition to `docs/spec2src-protocol-v2.md`, whose
conditions, classification rules and reporting apply unless changed here.*

## Question

Can agents of two vendors rebuild `notepad` from a spec that an agent wrote,
judged with hidden cases that another vendor's agent wrote? This is a proof of
concept, not a census.

## Roles (four vendors; no model family judges its own work)

| Role | Binding | Delivered |
|---|---|---|
| Spec author | `muse-wonder` | spec v1.0, bashy `eb41d87b`, `examples/desk/notepad` |
| Judge | `claude-opus5.5` | private hidden set `notepad-hidden-v1` and the grader set-up |
| Builders | `codex-gpt6.1-terra`, `opencode-glm-5.3-flash` | 3 runs each |
| Conductor | `claude-fable5.2-s726` | gates and records; no spec, case or source |

## Task and conditions

- Task: agent-bench `packs/spec2src/t3-notepad` (agent-bench `1beba5d`): the
  spec release, byte for byte, plus `TASK.md`. Run with
  `S2S_TASK=t3-notepad packs/spec2src/venue/run.sh`, one cell at a time, cap
  1,800 seconds, the guard and the headless session host of protocol v2.
- One venue difference from the form drill, taken from the contract's own
  Venue section: `bashy` is on the PATH as the html and pdf converter
  (`bashy lens`), on the session host and on the grading lane.
- Builds on the grading lane are offline: standard library or vendored
  dependencies only.

## Outcome per run

Two verdicts, reported apart:

1. **Behaviour:** the visible contract, the hidden cases and the page
   interaction, all PASS.
2. **Lifecycle:** agent-bench `packs/spec2src/venue/lifecycle-notepad.sh`,
   every step of the spec's `dag.md` and its service checks.

A run passes when both verdicts are PASS (the rule of story R3). A binding
passes at 2 of 3 runs or better. The two verdicts are reported apart for
every run. Every non-pass
is classified from the logs (builder, spec, hidden case, venue) before it is
counted. A venue fault is INCONCLUSIVE and may be rerun once; a provider
quota refusal is a venue fault and is deferred, not retried in a loop.

## Controls and identity (before any builder run)

Reference, source only: PASS 3 of 3 (177 of 177 assertions, lifecycle PASS).
Empty workspace: FAIL on every layer, lifecycle FAIL. Digests (sha256, first
16 hex): hidden set `4c1448e6facce37c`; `lane-grade.sh` `6f5dea925930f7a0`;
`grade-on-lane.sh` `e4f153cbf4e7c11f`; lifecycle test `ab0ea904fb994799`;
visible `CONTRACT.md` `1624be7bbbf8b60d`; `dag.md` `4fdbfa7532413078`; judge
binary (conform v0.1.1) `3fd12fbdbaacfc15`.

## Disclosures

- The judge found four points where the reference differs from its own spec
  (`--format` ignored; broader content sniffing; `r2` after an empty `add`;
  one failing `features.yaml` acceptance line). No visible or hidden case
  asserts them, so a build that follows the contract and a build that follows
  the reference both pass. They go to the report and a later spec version.
- The visible assertions run in order against one server on one fixed port;
  the hidden cases each use their own server, port and data folder.
- One smoke run with `claude-sonnet5.5`, not a subject, checks the chain
  first. It is not scored.

## Amendments

1. *2026-11-26, after the six scored cells.* `codex-gpt6.1-terra` passed 3
   of 3. `opencode-glm-5.3-flash` passed 1 of 3: run 1 failed 17 of 177
   assertions on one cause (the HTTP API's JSON printed with spaces and
   another key order, where those checks compare text; three of the 17 are
   visible), run 2 passed, run 3 delivered no file (the session read the
   spec, spent nine minutes in one thinking step and ended its turn; no
   refusal by the provider in the log). Both failures are counted as the
   builder's. Following the ladder rule of protocol v2 (step up at 1 of 3 or
   fewer), the next tier of the same vendor, `opencode-glm-5.3`, runs 3
   cells under the same conditions and digests. `opencode` has no one-shot
   probe, so its first cell is the check. The `flash` result stands as
   measured and is reported as a bound.
2. *2026-11-26, during the step-up batch (operator ruling).* A quota
   problem or any other issue with this vendor's bindings is reported and
   closed, without further runs or approval. `opencode-glm-5.3` cell 1 had
   delivered no file (the same pattern as the `flash` cell 3); cell 2 was
   stopped by the conductor after 16 minutes and cell 3 was not started.
   `opencode-glm-5.3` is reported as not measured (0 of 1). The sprint
   closes with one vendor's builder passing.
