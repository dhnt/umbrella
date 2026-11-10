# Agentic-Era Programming Language Traits and Gap Evaluation for Bash# (`bashsharp`)

*Tool / Author: `muse` (Muse Code, powered by Meta Muse Spark)*
*Status: External SOTA research + codebase gap evaluation (`bashsharp`, `sh`, `bashy`). No sprint, no story, no implementation commitment.*

---

# Part I: What matters for a modern language in the agentic-programming era

## Method and evidence base

This part revisits a conventional "modern language" trait list against
external evidence about LLM / agent code generation. The inspected primary
sources are:

- MultiPL-E (Cassano et al.), a benchmark translating HumanEval/MBPP to 18
  additional languages — https://arxiv.org/abs/2208.08227
  (HTML: https://arxiv.org/html/2208.08227v4)
- Type-Constrained Code Generation with Language Models —
  https://arxiv.org/abs/2504.09246

Claims below marked CONDITIONAL or UNMEASURED have no direct agent-era
measurement in those sources; they are ranked by absence of evidence, not by
negative results.

## The original (human-era) list

1. Safety by default
2. Expressive, sound type system
3. Abstraction without hidden cost
4. Concurrency model
5. Tooling and ecosystem
6. Interoperability / portability
7. Readability and maintainability
8. Performance / resource control
9. Evolution and stability

## Revised (agentic-era) ranking

Top finding: the #1 trait is no longer intrinsic safety — it is **corpus
frequency / ecosystem mass**, because an agent's success is bounded first by
how much idiomatic code it has seen in training.

1. **Corpus frequency & ecosystem** (was 5, up) — Models do best on
   high-frequency languages; Codex was significantly worse on Medium/Low/Niche
   vs High-frequency languages (p=.006 / <.001 / .002). CONDITIONAL: Lua ranked
   9th at only 0.2% of GitHub, and perplexity was non-predictive.
2. **Machine-enforceable types** (was 2, reframed) — The value is
   decodability in the generation loop, not expressiveness for humans:
   type-constrained decoding more than halves compile errors and raises
   correctness, including for >30B models.
3. **Canonical idiomaticity** (was 7 readability, up) — Agent-legible idiom
   beats human readability per se: multiline comments moved pass rates
   (+1.9% Racket / -3.1% PHP); omitting Perl named-arg scaffolding cost
   -8% pass@1. "One obvious way" helps the generator converge.
4. **Precise static types as prompt signal** (split from 2) — Removing
   TypeScript's precise types ("Any-ification") cost -2.5% pass@1 (p<.001);
   removing Python annotations was not significant (p=.23). CONDITIONAL: the
   authors attribute this to the typed-code training distribution, not to
   types in the abstract.
5. **Interoperability / transfer** (was 6, slight up) — MultiPL-E covers 18
   extra languages; Codex exceeded 40% pass@1 on C++, Java, TypeScript, PHP,
   Ruby, Rust, Scala and Lua (best: JavaScript, +2.3% vs Python, n.s.).
   Languages resembling high-corpus languages inherit agent competence.
6. **Safety by default** (was 1, down) — No direct evidence that runtime
   safety (memory/null/race) improves *agent* outcomes; the only proxy is
   well-typed decoding cutting compilation errors. Plausibly valuable for
   humans reviewing agent diffs, but UNMEASURED for agents.
7. **Abstraction without hidden cost** (was 3, down) — No inspected evidence
   isolates abstraction cost for agents; problem type (tuple/dict/list)
   showed no significant mixed-effects effect. UNMEASURED.
8. **Performance / resource control** (was 8, flat) — No runtime-performance
   evidence. A candidate new metric, token efficiency ("tokens to green
   tests"), rests on a small (n=115) non-peer-reviewed sample. CONDITIONAL.
9. **Concurrency model** (was 4, down) and
   **10. Evolution / stability** (was 9, flat) — Neither is measured in the
   MultiPL-E / type-decoding evidence.

Cross-cutting candidate trait (from the wider agentic-coding discussion, but
unverified under equal-token ablation): structured, machine-readable
toolchain feedback — JSON diagnostics with stable codes and machine-applicable
fixes, LSP/MCP exposure, and fast executable verification (tests as reward).

## Part I unresolved

- No equal-training-data experiment isolates static typing from corpus size
  and idiomaticity; the TypeScript type effect remains conditional.
- No supplied evidence on concurrency, runtime safety, performance, or
  evolution/stability *for agents*; those ranks are unmeasured.
- Structured-diagnostics and token-cost ("tokens-to-green") claims are
  unverified under equal-token ablation.

In short: the agent-era premium is on **being heavily represented, canonically
idiomatic, and mechanically checkable inside the generation loop**.

---

# Part II: Gap evaluation for Bash# (`bashsharp`, `sh`, `bashy`)

## Executive summary

Top finding: Bash#'s one strong agentic-era trait is **transfer** — it is a
strict Bash 5.3 superset that lowers to Go, so an agent can fall back on two
huge pretrained corpora. Its biggest gaps are the mirror image: **almost no
Bash#-own corpus, full type-checking that only applies on the Go-unit route
(not default mixed `.bsh`), and an agent feedback loop that is unproven** (no
evidenced JSON diagnostics / LSP/MCP / tokens-to-green measurement).

Bash#'s design bet — *don't invent a language, inherit Bash's corpus and Go's
types* — is exactly right for trait 5 and partially for traits 1/4. The gaps
are in the unfinished half: the checker, formatter, diagnostics and corpus
that would let an agent actually exploit the inheritance.

## Trait-by-trait verdict

Citations are repo-relative `path:line` at the time of inspection.

- **1. Corpus frequency / ecosystem — PARTIAL.** Borrows Bash + Go mass as a
  strict Bash 5.3 superset with Go-spelled constructs, but Bash# itself is
  alpha/novel with no own-corpus evidence — a pretrained LLM has seen
  approximately no `.bsh`. `bashsharp/docs/bashpp-posix-superset-syntax.md:19`
- **2. Machine-enforceable types — PARTIAL.** The Go-unit route is
  `go/types`-checked (incl. `:=`/generics inference), but mixed `.bsh` gets
  only parse + a `CheckBashSharp` subset, not `go/types`. The
  checker-in-the-loop benefit therefore does not cover the default authoring
  mode. `bashsharp/front/gosource.go:10,22`;
  `bashsharp/transpile/check.go:19,29`
- **3. Canonical idiomaticity — UNMEASURED / GAP.** Multiple routes exist
  (shell, Go unit, fences) — several ways to write the same thing — and
  whether `shfmt`/LangBashPP formatting is round-trip canonical for
  Bash#/Go/fence constructs is explicitly unresolved. No enforced "one
  obvious way" for a generator to converge on yet.
- **4. Precise static types as prompt signal — PARTIAL.** Sensibly reuses
  Go 1.27 types on the typed core rather than inventing a new system, but
  shell text is untyped and ADTs / sum types / exhaustive `match` are absent,
  so much of a typical `.bsh` file gives the model no type signal.
  `bashsharp/README.md:63`; `bashsharp/docs/why-bashsharp.md:230`
- **5. Interop / transfer — STRONG.** Bash/POSIX surface stable, 86/86
  dialect-off superset, Go decls/imports/funcs mix into shell and everything
  lowers to Go; C# is only a planned fence. `bashsharp/README.md:63`;
  `bashsharp/docs/bashpp-posix-superset-syntax.md:19`
- **6. Safety by default — PARTIAL.** Alpha checker-only null-deref and
  exhaustive-enum checks exist, but no null syntax, no sum types, and default
  mixed mode is not fully type-checked (see trait 2).
  `bashsharp/docs/bashsharp-ergonomics-tier.md:59,101`
- **7. Abstraction without hidden cost — UNMEASURED.** Evidence states all
  lowers to Go and enums lower to `const`/`iota`, but supplies no cost,
  allocation, or runtime-overhead data. `bashsharp/README.md:63`;
  `bashsharp/docs/bashsharp-ergonomics-tier.md:58,95`
- **8. Performance / token-efficiency — UNMEASURED.** No performance,
  token-count, or tokens-to-green measurement for agents or humans was found.
- **9. Concurrency model — UNMEASURED.** Only surface evidence is Go-spelled
  `ch<-` at committed start sites; no semantics, scheduling, or agent-safety
  evidence was supplied. `bashsharp/docs/bashpp-posix-superset-syntax.md:19`
- **10. Evolution / stability — PARTIAL.** Bash/POSIX surface is stable, but
  typed-core/polyglot/agentic/Sharp are alpha, syntax-open, RFC-gated and may
  change pre-1.0 — a moving target for prompts, fine-tunes, and generated-code
  longevity. `bashsharp/ROADMAP.md`; `bashsharp/README.md:3,16`
- **11. Cross-cutting diagnostics / tooling / verification / sandbox —
  PARTIAL.** Stable codes `BASHPP-ENULL-DEREF` / `BASHPP-EENUM-NONEXHAUSTIVE`
  with `file:line:col` via `bashy check`, but JSON diagnostics,
  machine-applicable fixes, LSP/MCP, sandboxing and fast verification were
  not evidenced. `bashsharp/transpile/check_test.go:19`

## Gaps in priority order (recommendations, inferred from the above)

1. **Own-corpus gap (traits 1, 3)** — publish a canonical example/test corpus
   and freeze one idiomatic route + formatter round-trip, so models can be
   prompted/fine-tuned against a single style. Without this, agents will just
   write Bash or Go, and Bash# adds only risk.
2. **Checker coverage gap (traits 2, 6)** — extend `go/types`-level checking
   (or an equivalent checker-in-the-loop) to default mixed `.bsh`; that is
   the trait the SOTA evidence actually rewards.
3. **Structured feedback gap (trait 11)** — emit JSON diagnostics with stable
   codes and machine-applicable fixes from `bashy check`, plus LSP/MCP
   exposure, so an agent can self-repair without parsing prose.
4. **Measurement gap (traits 3, 7–9)** — add a small agent benchmark
   (HumanEval/MultiPL-E-style tasks in `.bsh`, reporting pass@1 and
   tokens-to-green vs plain Bash and Go baselines). Until then, claims in
   either direction are unmeasured.

## Part II unresolved

- Whether `shfmt` LangBashPP formatting is round-trip canonical for all
  Bash#/Go/fence constructs — unresolved in supplied evidence.
- Whether the mixed-mode evaluator enforces Go types at runtime beyond the
  `CheckBashSharp` subset — no checker-in-the-loop evidence supplied.
- `bashy` toolchain and `sh` engine evidence was incomplete/truncated in this
  pass; structured JSON diagnostics, machine-applicable fixes, LSP/MCP and
  sandboxing are not assessable beyond the stable error codes — treat as
  "not found", not "proven absent".
- No supplied evidence for tokens-to-green, hidden-cost/performance, or
  concurrency semantics (traits 7–9).

## Sources

- MultiPL-E — https://arxiv.org/abs/2208.08227
- MultiPL-E (HTML) — https://arxiv.org/html/2208.08227v4
- Type-Constrained Code Generation with Language Models —
  https://arxiv.org/abs/2504.09246
- In-repo: `bashsharp/README.md`, `bashsharp/ROADMAP.md`,
  `bashsharp/docs/bashpp-posix-superset-syntax.md`,
  `bashsharp/docs/why-bashsharp.md`,
  `bashsharp/docs/bashsharp-ergonomics-tier.md`,
  `bashsharp/front/gosource.go`, `bashsharp/transpile/check.go`,
  `bashsharp/transpile/check_test.go`
