---
id: 2fde6fe6a959
kind: requirement
title: S1 Reconcile review findings and baseline evidence
seq: 80
status: todo
priority: p0
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.380449Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Maintain the authoritative reconciliation of all four docs/bashsharp-review-*.md reviews. Preserve original reviews. Every finding must have an evidence reference and one disposition: this sprint, existing capability, intentional limitation, external sprint, or deferred proposal.

## Initial disposition register
| Review finding | Disposition |
| --- | --- |
| codex G1; claude G1; muse checker/type gaps; agy G6/G9 | S3 shared analysis, S4 bounded checks, S5 coverage/diagnostics, S6 checked execution. Existing Go-unit checking remains. |
| codex G2; agy G8 | S2 M12 repair; S7 M10/M11 repair and M09 explicit refusal. |
| codex G3; claude G4/G9; agy G4/G11 | S8 provider/authority checks; S9 runtime contract improvements. |
| codex G4; claude G4; agy G5 | S8 authority matrix; Sprint 600 owns fence routing, per-call environment and lifecycle. No universal containment claim. |
| codex G5; claude G2; muse feedback gap | S3/S5 structured diagnostics and support identities. AST CLI, LSP, definitions/references/rename and query architecture are deferred. |
| codex G6; claude G6; muse dependency/deployment concerns | S10 design for existing environment planner, exact tool identities/digests and locked execution; S11 documents runtime dependencies. |
| codex G7; claude concurrency/explicitness findings; agy G7; muse concurrency unknowns | Existing structured command results, task cancellation/joining and host memory guards are recognized; S4 discarded-write warning and S11 mode matrix. Snapshot semantics remain; guest race detection and changed sharing are deferred. |
| codex G8; agy G3/G10; muse performance/cost unknowns | S11 measured performance boundaries; S12 scalar and persistent-worker designs; S13 maintenance cost measurement. No universal historical speed ratio. |
| codex agent-outcome evidence; claude token/benefit findings; muse measurement gap | Existing agent benchmarks recognized; S13 controlled maintenance comparison, no superiority/equivalence claim from equal small samples. |
| claude G3; muse corpus/idiomaticity/stability gaps | S11 existing executable corpus, formatter round trips, collision policy and accurately qualified compatibility claims; S14 dialect-on parsing. Dialect activation stays unchanged. |
| claude G5 | S11 version/claim reconciliation and current compatibility policy. New deprecation registry, warnings for silent aliases and new governance mechanisms are deferred. |
| claude G7 | Preserve failure defaults. Discarded mixed-task-write diagnostics belong to S4; S11 documents them. |
| agy G1/G2 | S12 separate bridge ownership and readonly retention/identity designs, including clone remapping and zero-size cases. |
| agy G4 decorated shell lowering and compiled advice gap | Deferred implementation proposals; S8/S11 document current host/compilation limitations. |
| agy G6 dynamic enum membership conversion | Deferred runtime guard proposal; S4 only checks statically known cases. |
| agy G8 keyword-call expressions and negative numeric arguments | Deferred parser repair proposals; no implicit expansion of S7. |
| agy G9 engine modularity | Sprints 575/581 own extraction; S3 must respect current dependency direction. |
| agy external traits; muse ADT/null/type-system aspirations; claude formal verification | ADTs, new null syntax, ownership types, algebraic effects, static contract proofs/invariants, Wasm/zero-copy ABI, accelerator lowering and incremental semantic tooling deferred. Existing runtime checks are not proofs. |
| claude G3 dialect-on Bash compatibility (79 + 7 vs 86/86) | S14 parser lookahead (`func`, `//`) gated by dialect-on fail-set comparison; S4 warns on E-live forms in non-.bsh files. Activation itself unchanged. |
| claude G4 whole-script cap (`bashy run --cap ...`) | Deferred proposal; S8 records it in the authority matrix. |
| claude memory-safety note: unmarked `unsafe` in compiled Go/cgo/C/C++/Rust islands | S11 documents it in the mode matrix. |
| agy G6.4 null checking of top-level statements and nullable call returns | S4 covers provable cases; the remainder is a deferred proposal. |
| agy G7.3 `go` statements outliving a `@timeout`/`@guard` frame | S11 lifetime matrix; no structured-concurrency change. |
| muse missing JSON, C# fences, concurrency, performance and benchmark evidence | Incomplete evidence, not absence. Recognize existing capabilities and their bounded evidence in S5/S10/S11/S13. |

This register groups duplicate claims; before closure, check every substantive recommendation and unresolved item in all four reviews against these rows and add any omitted item with its disposition. Research rankings remain review opinions, not implementation requirements or revalidated external research.

## Evidence and acceptance
Record exact candidate SHAs, known failures, evidence locations and commands. Historical review pins: bashsharp 45ae8e2d0f1d0ad384355859a8f0eb4fed2a893c; sh d2913001421b8a2a6b247ee9953ca89c84ff2868; bashy a9958c91e4853206a45b4ec20e5aecc894b89453; bashsharp-tests 6d414e2ec30d34f4b382f0966acf1ff840c330d1. Revalidate at execution time. Distinguish fresh results from inspected/reused evidence. Every finding has one owner/disposition; implementation claims require candidate-bound evidence.

Dependencies: none. S2 follows S1; S3 follows S2 by sprint delivery policy.
Planned owner: claude (reviewer, gate and merge: claude).

Before implementation, preserve the baseline candidate and controlled task inputs required by S13, including model/tool/policy identities and budgets. This is evidence planning; do not launch benchmarks during this planning-only update. Reconcile S14 parser expectations and the strict parity gate before delivery starts.

## Execution plan
Follow [Sprint 610 master execution plan](../sprint-610-master-execution-plan.md). Planning only: retain todo status and planned ownership; no implementation, workers, benchmarks or release are authorized. Dependencies and story acceptance remain authoritative.

## Baseline update (manager, 2026-11-10)
Re-measured on bashy a9958c91, sealed container, Linux test host, non-root testee: dialect OFF 86/86, dialect ON 86/86. The G3 row's "79 + 7 vs 86/86" is stale (v0.27.0); S14 is re-scoped to a regression guard plus targeted probes (see its re-baseline section). Recurring "79/86" readings were four disjoint failure sets: (A) root/no-hexdump/no-locale venue: execscript, glob-test, intl, new-exp, printf, redir, test; (B) historical dialect-on reserved `func`: comsub, comsub2, errors, func, trap, type, varenv; (C) a July 2026 engine regression (fixed); (D) Windows native gaps (S253). Compare by fixture identity, never by count.
