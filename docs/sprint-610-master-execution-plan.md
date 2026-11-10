# Sprint 610 master execution plan

Sprint 610 delivers Bash# correctness, bounded checking and accurate execution guarantees. Sprint identity: `225786a1-0676-58ef-9bdf-e3e1018c3818`.

## Authorization and source of truth

This update is planning only. Keep the sprint in backlog, unstarted and unclaimed, and all fourteen umbrella stories (S1–S14) in todo. Planned owners are not active assignments. No code, workers, benchmarks or release are authorized by this plan. The sprint card and story bodies remain authoritative; this plan records their execution sequence, shared gates and the planning decisions taken on 2026-11-10.

One sprint-linked story lives in the bashy repository, not in this umbrella store: `3e64bbed8228` "Sealed Bash 5.3 gate evidence and fixture-name baseline comparison", the operator-directed implementation follow-up to bashy todo `1b05b83d9c33`. It was authorized separately by the operator; the codex weave run in the bashy checkout has submitted it (two commits, not yet pulled to bashy main), and the goal checklist keeps reporting it uncovered until that merge lands. This plan does not authorize it; it records it as the gate prerequisite of S14 and links it to the S14 goal item so the checklist is fully covered.

Preserve the four original reviews: [agy](bashsharp-review-agy.md), [claude](bashsharp-review-claude.md), [codex](bashsharp-review-codex.md), and [muse](bashsharp-review-muse.md). S1 reconciles their findings against current code and candidate-bound evidence at execution time.

## Baseline as of 2026-11-10

| Item | Value |
| --- | --- |
| Review pins (historical) | bashsharp `45ae8e2d`; sh `d2913001`; bashy `a9958c91`; bashsharp-tests `6d414e2e` |
| Sealed gate evidence | bashy `a9958c91`, Linux test host (WSL, non-root testee): `make test-bash-container` 86/86 and `make test-bash-container-bashpp` 86/86 |
| Claims refresh | bashsharp `cd8b8c9` rewrites claims.md row 47: dialect-on 86/86 in the sealed Linux gate; "79 + 7" was measured on v0.27.0 or earlier |
| Root guard | bashy `550fc0ac`: `make test-bash` refuses to run as root and points to the sealed gate |
| Umbrella pins | bashsharp `cd8b8c9` and bashy `550fc0ac` are checked out but not yet pinned here; the pin bump is a `sync` commit, not part of this plan |

The claude review's G3 premise (86/86 off versus 79 + 7 on) is stale. Every recurring "79/86" reading came from one of four disjoint failure sets: (A) root/no-hexdump/no-locale venue: execscript, glob-test, intl, new-exp, printf, redir, test; (B) historical dialect-on reserved `func`: comsub, comsub2, errors, func, trap, type, varenv; (C) a July 2026 engine regression, since fixed; (D) Windows native gaps (S253). Compare by fixture identity, never by count. S1 must rewrite the G3 register row at execution time to cite this evidence; the current row still carries the stale figure with the baseline-update section appended beneath it.

Dialect-on parity is proven on one candidate in the sealed Linux container only. Dialect-off 86/86 is proven natively on Linux, macOS and Windows. S11 must qualify the dialect-on claim exactly that narrowly until further venues run.

## Delivery sequence

| Stage | Stories and planned owners | Deliverable and gate |
| --- | --- | --- |
| 1 | S1 — claude | Reconcile every review finding; rewrite the G3 row against the sealed-gate evidence; record current candidate SHAs, commands, evidence, known failures and dispositions. Preserve baseline inputs and controlled experiment protocol for S13 before changes. |
| 2 | S2 — codex | Repair M12 selector returns; demonstrate k=7, nested/pointer selectors and no successful literal-source fallback. Verify applicable routes and regenerate the support ledger. |
| 2 (parallel) | S14 guard and probes — claude; gate tool `3e64bbed8228` — codex (bashy) | Both gate modes run in the release gate with fixture-name comparison against prior evidence; a NEW failing name blocks. Add the E-live probe scripts (`func() {…}`, `func () {…}`, `ls //tmp`, typed `func NAME(...)`, methods, leading `//` in .bsh) and run each dialect on and off. Needs only S1's baseline, not S3/S5. |
| 3 | S3 — claude | Shared analysis contract with positioned identities, explicit coverage and host inputs. Equivalent semantic verdicts across front doors; no execution or provisioning during analysis. |
| 4 | S5 — glm | Compatible deterministic text/JSON diagnostics, stable support identities and verified runtime refusal metadata. |
| 5 | S4 — claude; S8 — codex | Bounded semantic checks and snapshot-write warnings, followed by provider and authority checks. Preserve valid cases and report unknown regions explicitly. |
| 6 | S7 — codex; S14 parser fix (only if a probe fails) — claude; S6 — claude | Repair M10/M11 and refuse M09; apply the start-site lookahead change red/green on the failing probe, no maxLookahead increase; deliver opt-in checked execution with no effects on rejection and exactly-once execution of analyzed input. Serialize overlapping parser/front-door edits. |
| 7 | S9 — codex | Lifecycle-bounded contract parsing reuse and result bindings without state leakage or changed failure/cancellation behavior. |
| 8 | S11 — muse | Verified examples, formatter behavior and mode matrices, including S14 named-fixture evidence and the venue-qualified dialect-on claim, plus qualified performance/lifetime/authority claims. |
| 9 | S10 and S12 — agy | Reviewable specifications only: fence checking, locked execution, ownership, readonly identity, workers and scalar evaluation. |
| 10 | S13 — claude | Controlled maintenance comparisons using existing agent-bench machinery; report correctness, regressions, intervention, tokens and total verification cost. |

Claude is the planned reviewer, gate owner and integrator. Resolve canonical identities and managed ownership before any future execution starts.

## Dependencies and scheduling

Required delivery order is S1 → S2 → S3. S5 follows S3; establish its presentation contract before final S4/S8 integration. S4 follows S3 and integrates S5 diagnostics. S8 follows S3/S4/S5. S6 follows S3/S4/S5/S8. S7 follows S3/S5. S9 follows S8. S11 follows S4/S5/S7/S8/S14. S10 follows S1/S5/S8. S12 can draft after S1 but must consume S11 guarantees before finalization. S13 follows S2–S9/S11, transitively including S14 through S11.

S14 is split by its re-scope. The regression guard (item 1) depends on S1 and on the bashy gate tool `3e64bbed8228` landing on bashy main. The probes (item 2) depend on S1 only. The conditional parser fix (item 3) depends on S3/S5 for diagnostic identities and runs only when a probe fails; if every probe passes, S14 closes on gate evidence and probe results without parser changes. S4's E-live warning fixtures are rechecked after whichever S14 outcome lands.

The stages give a default serial schedule, not additional dependency edges. Priorities govern ready work without bypassing dependencies. Independent design drafting may proceed when its dependencies are met during an authorized execution phase. Serialize overlapping changes and integration; do not launch workers as part of this planning update.

## Resolved planning inconsistencies

- 2026-11-10 (first pass): S14 linked to the goal checklist; S14 added to S11 dependencies; ordinary Bash `func() {…}` and `func () {…}` retain Bash function parsing, overriding the conflicting E-live preservation wording; S4 warnings apply only to actually recognized Bash# forms.
- 2026-11-10 (this pass): S14's "79 + 7" premise is stale; the story is re-scoped to guard + probes + conditional parser fix, and the card's S14 acceptance sentence is amended to match. The strict parity gate stays: dialect-on and dialect-off failure sets must match by fixture identity, every residual difference is recorded with its cause and blocks closure, and documentation is not a waiver. The gate is now expected to show two empty sets rather than recover seven fixtures.
- The bashy story `3e64bbed8228` was uncovered on the goal checklist; it is linked to goal s14 as the guard prerequisite. It is not an umbrella story and keeps its own repo lifecycle.
- S14's story body records "Planned owner: claude" without the reviewer/gate line the other stories carry; claude reviews, gates and merges as for every story.
- S1's register row for claude G3 and the S14 "Outcome (original)" section keep the stale figure for provenance; the re-baseline sections above them are authoritative.

## Verification and integration

Use focused regressions per story and existing runners. Run heavy corpora, foreign suites and Classic conformance on established remote test hosts after acquiring the required resource holds. Never run the sealed container gate on the dev box. Preserve Classic 86/86 in both gate modes. Compare dialect-on/off failures by fixture identity and track pre-existing failures separately. Run the heavy compatibility matrix once per frozen candidate; changed inputs or failures can require another candidate run.

Verify workspace and GOWORK=off builds. Each evidence record identifies exact source/dependency/candidate SHAs, commands, host role, raw result locations, expected and actual verdicts, and fresh versus reused results. Reuse evidence only with unchanged relevant inputs. Newly failing or newly skipped formerly green coverage blocks closure.

Close each story after its acceptance and relevant regressions pass. Independently review integrated results. Commit and push within each changed subproject before umbrella pin bumps; include Sprint/Story/Story-ID trailers and pass the public scrub gate. Preserve unrelated changes and published history. Sprint closure requires the integrated candidate's gates, not just closed stories.

## Boundaries and external work

Preserve unchecked streaming execution, shell failure defaults, dialect activation, silent aliases and mixed goroutine snapshot semantics. S14 changes only how the dialect parses, never when it is active. Keep repairs separate from frozen migration stages. No official release is authorized.

Sprint 600 (`1b4d2326-3a0e-583e-9cdf-358f396c39e3`) owns fence routing, per-call environment and worker lifecycle. Sprints 575 (`65ce85f5-87c0-5863-bf55-62de86f5df36`) and 581 (`cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7`) own extraction. External work gates only dependent guarantees; routing shims do not prove universal containment.

S10 and S12 deliver designs, not implemented benefits. All existing story/card deferrals remain in force, including dynamic enum guards, decorated-shell lowering, compiled advice parity, keyword-call expressions, negative numeric arguments and broader language/runtime redesign. S13 cannot count those proposals as delivered improvements.
