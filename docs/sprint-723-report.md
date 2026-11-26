# Sprint 723: which model tiers rebuild `form` from spec v2?

*2026-11-26 · conductor claude-opus5.5 (session model Fable 5.2) · protocol: umbrella `docs/spec2src-protocol-v2.md`, fixed before the scored runs, amendments 1 to 4*

## Answer (narrow)

Given only spec v2 of bashy's `form` and the judge to check their own work, coding agents from four vendors rebuilt the app, and for the three vendors where it was measured so did the tier one step below. These are observations from these runs, with these exact bindings and this configuration; n = 3 per binding.

| Vendor | Start tier | Result | One step down | Result | Bound |
|---|---|---|---|---|---|
| OpenAI | `codex-gpt6.2-sol` | **3/3** | `codex-gpt6.1-terra` | **3/3** | passes at terra; lower tiers untested |
| Meta | `muse-spark1.3` | **3/3** | `muse-ember` | **3/3** | passes at ember, the lowest listed tier |
| Anthropic | `claude-sonnet5.5` | 1/3, rerun **3/3** | `claude-sonnet5` | **2/3** | passes at sonnet5; lower tiers untested |
| Google | `agy-gemini4-carbon` | 1/3, rerun **3/3** | not run | — | passes at carbon; the step down was not run (quota; to revisit) |
| Zhipu | `opencode-glm-5.3` | no result | not run | — | open: provider usage limit before any work |

A pass is complete: 13 of 13 visible CLI assertions, 17 of 17 hidden steps in 9 independent cases, the visible and hidden page inventories, and one page interaction read back through the CLI.

For comparison, Sprint 722 ran spec v1 with each vendor's cheapest model and no judge in the loop: 1 pass in 15 runs. The two sprints differ in spec, tiers and conditions, so this is context, not a controlled comparison.

## Every run

| Batch | Binding | Verdict | Session | Note |
|---|---|---|---|---|
| 1 | codex-gpt6.2-sol | PASS | 496 s | |
| 1 | muse-spark1.3 | PASS | 850 s | |
| 1 | agy-gemini4-carbon | PASS | 1018 s | |
| 1 | claude-sonnet5.5 | FAIL | 348 s | macOS binary in the snapshot; regraded without it: 33/33 |
| 1 | opencode-glm-5.3 | venue fault | 283 s | "Usage limit reached for 5 hour" |
| 2 | claude-sonnet5.5 | PASS | 303 s | |
| 2 | codex-gpt6.2-sol | PASS | 527 s | |
| 2 | muse-spark1.3 | PASS | 896 s | |
| 2 | agy-gemini4-carbon | FAIL | 649 s | nothing written before the 600 s cutoff |
| 3 | claude-sonnet5.5 | FAIL | 328 s | macOS binary in the snapshot; regraded without it: 33/33 |
| 3 | codex-gpt6.2-sol | PASS | 577 s | |
| 3 | muse-spark1.3 | PASS | 965 s | |
| 3 | agy-gemini4-carbon | FAIL | 647 s | nothing written before the 600 s cutoff |
| R1 | claude-sonnet5.5 | PASS | 338 s | rerun under amendment 2 |
| R2 | claude-sonnet5.5 | PASS | 307 s | |
| R3 | claude-sonnet5.5 | PASS | 302 s | |
| R1 | agy-gemini4-carbon | PASS | 958 s | rerun under amendment 2 |
| R2 | agy-gemini4-carbon | venue fault | 216 s | "Individual quota reached"; logged by the runner as a candidate fail |
| R3 | agy-gemini4-carbon | venue fault | 210 s | same |
| R2b | agy-gemini4-carbon | PASS | 1148 s | rerun 2, after the quota reset |
| R3b | agy-gemini4-carbon | PASS | 1325 s | rerun 3, after the quota reset |
| 4 | codex-gpt6.1-terra | PASS | 328 s | |
| 5 | codex-gpt6.1-terra | PASS | 329 s | |
| 6 | codex-gpt6.1-terra | PASS | 363 s | |
| 4 | muse-ember | PASS | 753 s | |
| 5 | muse-ember | PASS | 752 s | |
| 6 | muse-ember | PASS | 1846 s | ran to the 30-minute cap |
| 7 | claude-sonnet5 | PASS | 844 s | |
| 8 | claude-sonnet5 | PASS | 1031 s | |
| 9 | claude-sonnet5 | FAIL | 945 s | one hidden case: a hyphenated secret field name was accepted (spec gap: the rule is given by example) |

## Failures by cause

- **Spec gap, one run** (claude-sonnet5, batch 9; first recorded as an agent defect, corrected the same day). The build refused `api_key` and accepted `stripe-api-key`. The contract states this rule by example only: "secret-named fields (`api_key`, `db_password`, ...)". It never defines which names are secret, and the hidden case tested a hyphenated form the spec does not document, which breaks soundness criterion 6 (hidden cases vary documented behaviour only). The other bindings happened to generalize the way the reference does. 32 of 33 assertions passed. The reference keeps this rule as one pattern in its shared kit, and the feature is marked `critical`, which the format says is never rebuilt in the field.
- **Harness condition, four runs:** two claude-sonnet5.5 snapshots carried a binary built on the session host; two agy-gemini4-carbon sessions were ended by a runner cutoff the protocol had not stated. Both conditions were fixed (amendment 2). In batch 9 the grader removed a cached binary and the run went on to pass 32 of 33, which shows the fix working on a real snapshot.
- **Venue fault, three cells:** provider quota refusals (Zhipu once, Google twice). Not scored.
- **Agent defect:** none that decided a run. **Judge defect:** none found.

## Controls and identity

- Reference through the full grader: 3 of 3, 33 of 33 each. Empty workspace: 0 of 33. Visible contract v2: 109 of 109 mutants killed (Sprint 723 S2).
- Digests (sha256, first 16): hidden set `fd7755b171a79511`; contract `ae30df1a5d9bf392`; judge on the venue `3fd12fbdbaacfc15`; judge for subjects `aaab8d7a5005cb02`. Grader script v2.1 from amendment 2.

## Limits

- One app. The spec, the hidden cases and every classification were written by the conductor.
- n = 3 per binding; one step per vendor, so each result is a bound, not a minimum.
- The step-down batches 4 and 5 ran with the 600 s cutoff and batch 6 onward with the 30-minute one. The cutoff ended the two muse-ember sessions of batches 4 and 5 after their work was complete, and both passed; no step-down run failed because of it.
- The claude-sonnet5.5 reruns shipped no host binary, so they would have passed without the grader fix; the fix is shown by the regrades and by batch 9.
- `agy-gemini4-carbon` also served as a worker on the spec checker the same day (disclosed in the protocol). Its quota ran out during the reruns; the last two ran after the reset. Its step down was not run.
- The subject's judge runs on the session host; the grader runs on the stated Linux venue.
- Tokens were recorded for two tools only; cost for none.
- The judge-band study (S9) was not run.

## What comes next

Sprint 726 (the loop on a second app with agents in every role) and Sprint 728 (the workflow standard). Findings for planning: umbrella `docs/shapeware-workflow-findings-2026-11-26.md`.
