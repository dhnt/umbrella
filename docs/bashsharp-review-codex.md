# Bash# review: language traits for agentic programming

Author: `codex` (the tool identity reported by this session).
Review date: 2026-11-10.
Status: research and code inspection; recommendations, not an implementation plan or release gate.

## Conclusion and evidence scope

Bash# has many of the right building blocks, but its guarantees are uneven
across execution modes. The largest gap is a dependable contract for checking a
change before executing it. Closing that gap matters more for agentic
programming than adding language features.

This review inspected the language front door, parser/checker/lowering code,
runtime, bashy policy integration, conformance fixtures, design documents, and
recorded agent experiments at these checkout revisions:

| Component | Revision |
|---|---|
| bashsharp | `45ae8e2d0f1d0ad384355859a8f0eb4fed2a893c` |
| sh | `d2913001421b8a2a6b247ee9953ca89c84ff2868` |
| bashy | `a9958c91e4853206a45b4ec20e5aecc894b89453` |
| bashsharp-tests | `6d414e2ec30d34f4b382f0966acf1ff840c330d1` |

Focused tests and small reproductions ran during the review. Historical corpus,
cross-platform, performance, and agent-outcome results were read, not rerun.
Findings refer to these revisions; historical documents retain their own
candidates and dates.

## Research basis and revised priorities

The central design objective is to make proposed changes cheap to check,
diagnose, constrain, and review. The ranking below is an engineering synthesis,
not an experimentally established universal ranking of languages.

- [From LLMs to Agents in Programming](https://arxiv.org/abs/2601.12146)
  studies compiler feedback on 699 C tasks across 16 models. Compilation
  improvements support a generate/check/repair loop, but compilation alone
  does not establish functional correctness.
- [AI Coding Agents Need Better Compiler Remarks](https://arxiv.org/html/2604.13927v1)
  finds that actionable optimization feedback helps a small model, while vague
  remarks can induce semantic errors. Its specialized vectorization benchmark
  limits generalization.
- [AxDafny](https://arxiv.org/html/2606.32007v1) demonstrates verifier-guided
  generation and repair. It also distinguishes functional verification from
  executable success under time and memory limits. Verification success on its
  proof-annotation benchmark is not a general software-correctness rate.
- [Benchmarking Coding Agents under Evolving Requirements](https://arxiv.org/abs/2610.35488)
  evaluates repeated changes and preservation of earlier requirements. Its
  observed repair and regression difficulties motivate stronger change-time
  checks.
- [Frontier Coding Agents Use Metaprogramming to Adapt to Unfamiliar Programming Languages](https://arxiv.org/abs/2606.10933)
  shows adaptation through tools, execution, and generators, with substantial
  model differences. Familiarity remains useful but is not the only determinant
  of agent effectiveness.
- [Do programming languages still matter to your AI coding agent teammate?](https://arxiv.org/abs/2606.13763)
  reports differences in cost, performance, effort, and validation across a
  17-language chess-engine case study. A single domain does not establish a
  universal language ranking.
- [Writing effective tools for agents](https://www.anthropic.com/research/writing-tools-for-agents)
  supports meaningful, concise results and deliberate tool interfaces. Extending
  these principles to compiler and semantic-query APIs is this review's inference.

## Assessment against the ten traits

The assessment includes the language, compiler, runtime, and standard toolchain;
syntax alone cannot deliver all ten properties.

| Priority / trait | Existing capability | Main gap |
|---|---|---|
| 1. Machine-checkable correctness | Go-source checking; mixed-script enum, argument, and nullable-flow checks; runtime contracts | Mixed-script checking does not establish general name/type correctness. Contracts check particular executions. |
| 2. Fast, actionable feedback | Diagnostic codes and positions; `bashy check --json`; Go-delta lookup and workarounds | Front doors expose different formats and coverage; some parser errors obscure the unsupported construct. |
| 3. Local reasoning and explicit interfaces | Typed functions, imports, explicit fences, documented grammar boundaries | Meaning depends on mixed-script, package-led, or compiled-island execution. Some differences yield successful wrong results. |
| 4. Safety and controlled authority | `@guard`, `@effects`, `@contain`, explicit `agentic` scope | Declarations, dispatch checks, and containment provide different guarantees; no universal capability boundary covers every route. |
| 5. Reproducibility and inspectability | Environment plans, fingerprints, source digests, managed toolchains, module pins | Ambient environment, overrides, standalone PATH resolution, and floating Rust installation can vary execution. |
| 6. Failure and concurrency semantics | Structured command results, `defer`, cancellation and task joining, defined yield status | Legacy shell failure semantics remain; mixed-task snapshots differ from ordinary Go sharing. |
| 7. Semantic navigation and transformation | ASTs, source maps, runtime value descriptions, structured support ledger | No integrated Bash# semantic service for definitions, references, rename, and cross-boundary type queries was found in the inspected code. |
| 8. Composition and interoperability | Shell integration, typed command capture, foreign-language bridges | Bridge restrictions and representation changes complicate end-to-end guarantees. |
| 9. Predictable performance and resources | Explicit compiled route; documented interpreter measurements | Substantial interpreted performance cliffs; no unified preflight resource assessment was found. |
| 10. Ecosystem and disciplined evolution | Normative grammar, differential fixtures, claim registry, generated Go-delta documentation | Historical plans and current behavior coexist; some headline descriptions exceed narrower measured guarantees. |

The strongest areas are process composition, explicit boundaries, and evidence
discipline. The weakest are uniform static assurance, semantic consistency, and
portability of guarantees.

## Concrete findings

### G1 — Mixed-script checking has substantial semantic blind spots

All three programs returned status 0 with no diagnostic through the current
standalone front door:

```bash
bashsharp --check -c 'func f() int { return missing }'
bashsharp --check -c 'func f() int { return "hello" }'
bashsharp --check -c 'func f() int { var p *int; return *p }'
```

These accept an undefined return name, a mismatched return type, and a local
nil-pointer dereference. The bodies were checked, not executed. Reproductions
used `go run ./cmd/bashsharp` from the bashsharp checkout.

[The mixed check entry point](../bashsharp/transpile/check.go) parses and calls
`lower.CheckBashSharp`. [That checker](../sh/lower/bashsharp.go) implements
selected obligations rather than general semantic checking. Nullable analysis
follows selected parameters and aliases; local zero values deliberately retain
runtime checks. Package-led Go-source checking has a different, richer checking
path; this finding must not be generalized to every Go entry route.

Recommendation: expose exactly what a successful check establishes and extend
coverage for names, types, calls, returns, and error handling. Dynamic shell
regions should have explicit unchecked coverage rather than silently inheriting
the apparent assurance of surrounding typed code.

### G2 — Familiar mixed Go syntax has missing or incorrect behavior

The following published [Go-delta fixtures](../bashsharp-tests/tests/go-delta/)
were reproduced on the reviewed checkout:

| Fixture | Observation |
|---|---|
| M09: top-level Go `if` | Rejected with a closing-brace diagnostic. |
| M10: `range` inside a mixed-script function | Rejected as a non-scalar `for` condition. |
| M11: union generic constraint | Rejected with `` `foo(` must be followed by `)` ``. |
| M12: struct-selector return | Succeeds and prints `k=j.ID`, rather than `k=7`. |

The [Go-delta ledger](../bashsharp/docs/go-delta.md) already records these as
gaps. M12 is particularly important: a successful process status accompanies
the wrong value. Intentional differences also exist: mixed-text goroutines
receive snapshots of ordinary bindings instead of ordinary Go shared closure
bindings.

Recommendation: fix successful wrong-result behavior first. Unsupported
constructs should produce specific diagnostics and a working alternative.
Preserve separate evidence for mixed scripts, interpreted units, and compiled
islands rather than inferring one surface's correctness from another.

### G3 — Contract availability depends on host wiring

The standalone binary rejected this program:

```bash
@require("false")
function f() { :; }
f
```

```text
BASHPP-EDECO-UNDEF: decorator require is not defined
```

[`@require` and `@ensure`](../bashy/internal/agentos/contracts.go) are supplied
by bashy's native decorator registry. The
[compiled runtime](../sh/lower/shellrt/decorator.go) likewise expects native
decorator wiring from its embedder; it does not automatically acquire the
bashy registry.

The contracts are useful runtime checks, not general proofs: postconditions
run after successful completion, and `RESULT` exposes a textual rendering of
the first result. Checks are shell commands and do not imply purity or rollback.

Recommendation: publish runtime requirements and detect missing providers during
checking. Supply consistent behavior across supported hosts for contracts
intended to travel with a program. Optional formal verification is a later
opportunity; portability and checking are more immediate needs.

### G4 — Declared effects and enforced authority need a unified explanation

The implementation already distinguishes several mechanisms:

- `@guard` narrows allowed command effects.
- `@effects` can declare effects for otherwise unknown commands.
- `@contain` supplies enforced child-process containment, including network
  restrictions within its supported boundary.
- `agentic` controls an explicit assistance scope and grants no permissions.

The [audit layer](../bashy/internal/agentos/audit.go) uses command metadata or
trusted declarations. A declaration does not establish the behavior of opaque
child processes. [Containment](../bashy/internal/agentos/contain.go) supplies
stronger enforcement within its specific boundary. The language's agentic
scope is deliberately not a transitive effect system or sandbox.

Recommendation: make effective authority inspectable before execution across
shell dispatch, native imports, and foreign workers. Distinguish declared,
enforced, and uncontained behavior; do not equate an effect cap with universal
resource containment.

### G5 — Structured feedback exists but is fragmented

[`bashy check`](../bashy/internal/agentos/check.go) has a versioned JSON report.
`bashy explain go` exposes a generated support ledger, and transpilation emits
source maps with source identities and digests. These are substantial existing
capabilities.

However, the standalone mixed checker renders text. The M11 parser diagnostic
observed in this review also differs from the text recorded in the delta table.
That matters because [refusal lookup](../bashsharp/godelta/godelta.go) matches
diagnostic text. Passing metadata tests do not establish correspondence with
every current runtime refusal.

Recommendation: share stable diagnostic identities and structured results
across front doors, including source ranges, checked coverage, and workarounds.
Build semantic navigation on this shared foundation.

### G6 — Reproducibility is developed but not complete

[Environment planning](../sh/polyglot/environment.go) records manifests, locks,
normalized environments, and fingerprints without running user programs.
Nevertheless, standalone resolution can use PATH; defaults can inherit ambient
environment; explicit overrides select different tools. The
[claim registry](../bashsharp/docs/claims.md) states that the first Rust
installation can select `stable` instead of a fixed toolchain version.

Recommendation: offer an inspectable resolved execution identity covering code,
toolchain, dependency locks, relevant environment, and runtime providers.
Provisioning alone does not establish reproducible execution.

### G7 — Concurrency is a strength with mode-specific semantics

[Task execution](../sh/interp/bashpp_concurrency.go) implements mutable-value
isolation, cancellation, descendant cleanup, and EOF joining. Structured
`run`/`capture` also preserve argv and separate failure channels; this is already
implemented in [the capture boundary](../sh/interp/bashpp_capture.go).

Recommendation: publish a guarantee matrix for mixed tasks, interpreted Go
units, compiled code, and foreign workers. Make lifetime, cancellation, sharing,
and cleanup differences explicit. The need is consistent guarantees, not simply
adding structured concurrency or typed command results that already exist.

### G8 — Resource costs can dominate repair loops

[Historical performance evidence](../bashsharp/docs/interpreted-performance-v1.md)
includes an interpreted workload taking about 37 minutes while native and
compiled runs took roughly a second. These are workload-specific,
harness-inclusive measurements, not a controlled universal speed ratio.

Recommendation: surface execution mode and known cost boundaries, and keep
expensive loops and their data inside compiled functions when appropriate.
Preserve explicit compilation rather than silently substituting it for an
interpreted correctness claim.

## Agent-outcome evidence and recommended order

The [recorded agent comparison](../bashsharp/docs/bashsharp-for-agents.md)
initially scored Bash 59/60, guards 13/60, and fences 12/60, with substantial
effect-policy integration failures. A separate follow-up changed the treatment
effect declaration and scored 59/60 in every arm, with no recorded cap denials.
Equal observed scores establish neither equivalence nor an advantage. Treatment
token-per-solve lower bounds were higher. The
[follow-up scalar record](../agent-bench/experiments/bashsharp-l2/results/sprint-287.json)
preserves the comparison and its limits.

This evidence shows that policy integration can dominate the utility of language
features. Future evaluations should measure repair success, regressions, human
intervention, and total verification cost on maintenance tasks.

Recommended priority:

1. Fix successful wrong-result behavior, particularly M12.
2. Establish a trustworthy, explicitly bounded mixed-script check.
3. Make contract and authority requirements portable and inspectable.
4. Unify structured diagnostics and support metadata.
5. Validate agent benefit on maintenance tasks exercising these guarantees.

The [historical seam measurement](../bashsharp/docs/seam.md) also identifies
deep evaluator coupling to the Classic engine. This makes checker/runtime
improvements architectural work in some cases, not merely additions to the
front-door repository. Its historical counts were not remeasured here.

## Validation performed

From the bashsharp checkout:

```bash
go test ./front ./godelta ./transpile -run '^(TestLeadingGoPackage|TestCheckShellInputRefusesWithoutFrontEnd|TestCollectCheckInput|TestCheckShellInput)$' -count=1 -timeout=60s
go test ./godelta -count=1 -timeout=60s
```

Both commands passed. The first command selected no godelta tests; the second
ran that package's tests. The three successful-check reproductions, four
Go-delta fixtures, and missing-contract-provider reproduction described above
were also run against the reviewed source with `go run ./cmd/bashsharp`.
For rejected programs, `go run` itself returned 1 and reported the product's
exit status; the successful checks and M12 returned 0.

No full Go corpus, licensed POSIX suite, foreign-language suite, cross-platform
campaign, or new agent benchmark was run. The passing focused tests do not
establish correctness for the reproduced limitations.
