# Sprint 610 master execution plan

Sprint 610 delivers Bash# correctness, bounded checking and accurate execution guarantees. Sprint identity: `225786a1-0676-58ef-9bdf-e3e1018c3818`.

## Authorization and source of truth

This update is planning only. Keep the sprint in backlog, unstarted and unclaimed, and all fourteen stories in todo. Planned owners are not active assignments. No code, workers, benchmarks or release are authorized. The sprint card and story bodies remain authoritative; this plan records their execution sequence and shared gates.

Preserve the four original reviews: [agy](bashsharp-review-agy.md), [claude](bashsharp-review-claude.md), [codex](bashsharp-review-codex.md), and [muse](bashsharp-review-muse.md). S1 reconciles their findings against current code and candidate-bound evidence at execution time.

## Delivery sequence

| Stage | Stories and planned owners | Deliverable and gate |
| --- | --- | --- |
| 1 | S1 — claude | Reconcile every review finding; record current candidate SHAs, commands, evidence, known failures and dispositions. Preserve baseline inputs and controlled experiment protocol for S13 before changes. |
| 2 | S2 — codex | Repair M12 selector returns; demonstrate k=7, nested/pointer selectors and no successful literal-source fallback. Verify applicable routes and regenerate the support ledger. |
| 3 | S3 — claude | Shared analysis contract with positioned identities, explicit coverage and host inputs. Equivalent semantic verdicts across front doors; no execution or provisioning during analysis. |
| 4 | S5 — glm | Compatible deterministic text/JSON diagnostics, stable support identities and verified runtime refusal metadata. |
| 5 | S4 — claude; S8 — codex | Bounded semantic checks and snapshot-write warnings, followed by provider and authority checks. Preserve valid cases and report unknown regions explicitly. |
| 6 | S7 — codex; S14 — claude; S6 — claude | Repair M10/M11 and refuse M09; restore dialect-on compatibility; deliver opt-in checked execution with no effects on rejection and exactly-once execution of analyzed input. Serialize overlapping parser/front-door edits. |
| 7 | S9 — codex | Lifecycle-bounded contract parsing reuse and result bindings without state leakage or changed failure/cancellation behavior. |
| 8 | S11 — muse | Verified examples, formatter behavior and mode matrices, including S14 compatibility results and qualified performance/lifetime/authority claims. |
| 9 | S10 and S12 — agy | Reviewable specifications only: fence checking, locked execution, ownership, readonly identity, workers and scalar evaluation. |
| 10 | S13 — claude | Controlled maintenance comparisons using existing agent-bench machinery; report correctness, regressions, intervention, tokens and total verification cost. |

Claude is the planned reviewer, gate owner and integrator. Resolve canonical identities and managed ownership before any future execution starts.

## Dependencies and scheduling

Required delivery order is S1 → S2 → S3. S5 follows S3; establish its presentation contract before final S4/S8 integration. S4 follows S3 and integrates S5 diagnostics. S8 follows S3/S4/S5. S6 follows S3/S4/S5/S8. S7 and S14 follow S3/S5. S9 follows S8. S11 follows S4/S5/S7/S8/S14. S10 follows S1/S5/S8. S12 can draft after S1 but must consume S11 guarantees before finalization. S13 follows S2–S9/S11, transitively including S14 through S11.

The stages give a default serial schedule, not additional dependency edges. Priorities govern ready work without bypassing dependencies. Independent design drafting may proceed when its dependencies are met during an authorized execution phase. Serialize overlapping changes and integration; do not launch workers as part of this planning update.

## Resolved planning inconsistencies

- Link S14 to the required goal checklist and add S14 to S11 dependencies.
- S14 requires dialect-on and dialect-off failure sets to match by fixture identity. Record all residual differences and their causes; any remaining difference blocks closure. Documentation is not a waiver.
- Ordinary Bash `func() {…}` and `func () {…}` retain Bash function parsing. The conflicting E-live preservation wording does not override that requirement. S4 warnings apply to actually recognized Bash# forms, not these spellings alone. Specify exact parse fixtures before implementation and recheck warnings after S14 integration.

## Verification and integration

Use focused regressions per story and existing runners. Run heavy corpora, foreign suites and Classic conformance on established remote test hosts after acquiring the required resource holds. Preserve Classic 86/86. Compare dialect-on/off failures by fixture identity and track pre-existing failures separately. Run the heavy compatibility matrix once per frozen candidate; changed inputs or failures can require another candidate run.

Verify workspace and GOWORK=off builds. Each evidence record identifies exact source/dependency/candidate SHAs, commands, host role, raw result locations, expected and actual verdicts, and fresh versus reused results. Reuse evidence only with unchanged relevant inputs. Newly failing or newly skipped formerly green coverage blocks closure.

Close each story after its acceptance and relevant regressions pass. Independently review integrated results. Commit and push within each changed subproject before umbrella pin bumps; include Sprint/Story/Story-ID trailers and pass the public scrub gate. Preserve unrelated changes and published history. Sprint closure requires the integrated candidate's gates, not just closed stories.

## Boundaries and external work

Preserve unchecked streaming execution, shell failure defaults, dialect activation, silent aliases and mixed goroutine snapshot semantics. Keep repairs separate from frozen migration stages. No official release is authorized.

Sprint 600 (`1b4d2326-3a0e-583e-9cdf-358f396c39e3`) owns fence routing, per-call environment and worker lifecycle. Sprints 575 (`65ce85f5-87c0-5863-bf55-62de86f5df36`) and 581 (`cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7`) own extraction. External work gates only dependent guarantees; routing shims do not prove universal containment.

S10 and S12 deliver designs, not implemented benefits. All existing story/card deferrals remain in force, including dynamic enum guards, decorated-shell lowering, compiled advice parity, keyword-call expressions, negative numeric arguments and broader language/runtime redesign. S13 cannot count those proposals as delivered improvements.
