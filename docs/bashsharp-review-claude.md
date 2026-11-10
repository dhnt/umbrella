# Bash# review — gaps as a language for the agentic era (by `claude`)

Read-only evaluation of Bash# (`bashsharp`, the `sh` engine, `bashy`) against
the language traits that 2025–2026 evidence ranks highest when LLM coding
agents write, read and operate code. Status as of 2026-11-10. File references
are relative to the umbrella root; doc-only plans are distinguished from
shipped code.

## Yardstick: agentic-era trait ranking

Ranked by strength of external evidence, not by type-theory appeal:

| # | Trait | Evidence |
|---|---|---|
| 1 | Fast, strict, single-verdict verification loop (check/compile/test, actionable diagnostics) | **Strong** — compiler-feedback repair fixes ~74% of real Rust compile errors ([RustAssistant](https://arxiv.org/pdf/2308.05177)); type-constrained decoding halves compile errors ([PLDI 2025](https://arxiv.org/abs/2504.09246)) |
| 2 | Enforced static types (no silent `any`; ADTs/exhaustiveness/no-null as components) | Strong for compile errors; AI-written TS uses `any` ~9× more than humans ([arXiv 2602.17955](https://arxiv.org/abs/2602.17955)) |
| 3 | Training-corpus coverage + stability (compat promise, machine-readable deprecations) | **Strong** — deprecated-API use 25–37%, 70–90% with outdated context ([ICSE 2025](https://arxiv.org/html/2406.09834v1)); synthetic corpus ~doubles low-resource pass@1 ([MultiPL-T](https://arxiv.org/abs/2308.09895v2)) |
| 4 | Explicitness / locality (no magic, action-at-a-distance, aliases) | Practitioner opinion ([Ronacher 2026](https://lucumr.pocoo.org/2026/2/9/a-language-for-agents/)) |
| 5 | Deterministic deps + supply-chain safety | Strong threat data — 19.7% hallucinated packages, 43% recur ([USENIX Sec 2025](https://arxiv.org/abs/2406.10279v3)) |
| 6 | Memory safety | Table stakes |
| 7 | Capability / effect tracking, deny-by-default | Prototype-level (tacit [2603.00991](https://arxiv.org/abs/2603.00991), CaMeL [2503.18813](https://arxiv.org/pdf/2503.18813)) |
| 8 | Machine-friendly surfaces (JSON diagnostics, stable codes, fix plans, dry-run) | Shipped elsewhere, unmeasured |
| 9 | Verifier-friendliness (contracts checkable automatically) | Strong in niche (Dafny 82% vericoding, [2509.22908](https://arxiv.org/abs/2509.22908)) |
| 10 | Simple concurrency model | Weak-indirect |
| 11 | Simple deployment | Opinion |
| 12 | Token efficiency | Measured spread 1.16–1.69× vs Python, familiarity-driven ([2607.22807](https://arxiv.org/html/2607.22807)) |

## Scorecard

| # | Trait | Bash# | Key evidence |
|---|---|---|---|
| 1 | Verification loop | 🔴 weakest link | see G1 |
| 2 | Enforced types | 🟡 | Typed Go core; shell variables remain untyped strings, typed-func args are converted/checked at call time (`sh/interp/bashpp_funclit_test.go:158-168`); `any`, bare `func` param types allowed; enum exhaustiveness only for typed-parameter tags (`sh/lower/bashsharp.go:196-224`); null safety is a checker rule, not a type (`bashsharp/docs/bashsharp-ergonomics-tier.md:59`) |
| 3 | Corpus + stability | 🟡 | Base is Bash/POSIX/Go (high corpus). But alpha (`bashsharp/ROADMAP.md`), 1.0 freeze is future, `bashsharp/rfcs/` holds only the template, Bash++ aliases silent with no expiry (`bashsharp/README.md:135-137`), doc drift (`bashsharp/docs/claims.md` Go 1.27.1/CPython 3.13 vs code 1.27.2/3.15) |
| 4 | Explicitness | 🟡 | Explicit decorators; policy advice opt-in and inspectable (`bashy inspect advice`). But no strict mode, and the dialect changes valid Bash: `//` comment (go-delta M14), `type NAME TYPE` (M13), goroutine writes lost (M08) |
| 5 | Supply chain | 🟡 | Go imports via go.mod/go.sum; Node and images digest-pinned. Rust `DefaultToolchain = "stable"` and Python newest 3.15 patch float; digests fetched from vendor at runtime (`yoke/external/gotoolchain/gotoolchain.go`, `yoke/external/rust/rust.go`); no script/fence lockfile — `env sync --locked` deferred (`bashsharp/docs/bashpp-polyglot-environments.md:186-221`) |
| 6 | Memory safety | 🟢 | Pure-Go engine; interpreted `unsafe` refused (`sh/UNSAFE_STRUCT_OVERLAY_DESIGN.md`). Compiled Go/cgo and C/C++/Rust islands have real `unsafe`, process-isolated but unmarked |
| 7 | Effects / capabilities | 🟡 | Strong bashy runtime: 11-atom atlas (`yoke/pkg/atlas/atlas.go`), narrow-only caps, deny-by-default inside `@guard` (`bashy/internal/agentos/audit.go:96-165`), `@contain` net-deny. Not language: standalone `bashsharp` gate is nil, no static effect checking (excluded: `bashsharp/docs/bashpp-agentic-mvp-plan.md:210`), ambient authority outside a guard, redirections/builtins ungated, fences run with host authority |
| 8 | Machine surfaces | 🟢/🟡 | Versioned envelopes, exit codes 0–6, engine `--dry-run`, `bashy-check-v1`, typedjson AST. But parse errors → generic `BASHY0001` with no line/col (`bashy/internal/agentos/check.go:313-315`); `bashsharp --check` text-only; no AST verb, no fix field, no LSP |
| 9 | Verifier-friendliness | 🟡 | `@require`/`@ensure` shipped but opaque shell commands, "never an expression language" (`bashy/internal/agentos/contracts.go`); runtime-only; absent in standalone `bashsharp`; no invariants or property tests |
| 10 | Concurrency | 🔴 | Four stacked models: jobs/coproc, goroutines with env snapshot, fence workers, DAG |
| 11 | Deployment | 🟡 | `transpile --standalone` → Go module; fences need runtime provisioning; multi-package codegen open |
| 12 | Token efficiency | 🔴 | Own S5 rerun: all arms 59/60, Bash# arms ~5% more tokens/solve (`bashsharp/docs/bashsharp-for-agents.md:150-154`); first run −77 pp, ~5× tokens from effect-cap misconfiguration |

## Gaps, prioritized

### G1 — the verdict is optional, shallow and split (trait 1)

- `bashsharp --check` / `bashy check --bashsharp` run only `lower.CheckBashSharp`
  (keyword args, defaults, enums, nil-flow — `sh/lower/bashsharp.go`).
- The ~20 profile type rules (`CheckProfile`: `EASSIGN-TYPE`, `EIF-COND`,
  `EGENERIC-INFER`, …, `sh/lower/profile_diagnostics.go:30-49`) run **only in
  transpile** (`sh/lower/compile.go:172`, sole caller). A program can pass
  `check` and fail `transpile`.
- The interpreter never invokes the checker; statements before a syntax error
  still execute (`bashsharp/cmd/bashsharp/main.go:238`). Same type errors
  surface only at runtime. This is the "runs despite failing the type check"
  flaw practitioners hold against TypeScript.
- Fences: `--check` does not compile them; TypeScript runs `strict:false`
  (`sh/polyglot/typescript.go`); Python gets `ast.parse` only; PowerShell has
  no check step.

**Smallest fix:** fold `CheckProfile` into `CheckBashSharp`; check-before-run
for `.bsh`; `check --fences` invokes each fence's real compiler/type checker
(tsc strict; mypy/pyright when present).

### G2 — diagnostics not agent-actionable (trait 8)

Parse errors need real codes and positions; `bashsharp --check --json`;
a `fix`/`hint` field reusing the `bashy explain go` workaround table; an AST
verb over the existing typedjson codec. Cheap — every piece exists already.

### G3 — "strict superset" only with the dialect off; bashy defaults it on (traits 3, 4)

86/86 with the dialect off, **79 + 7** with it on (`bashsharp/docs/claims.md:47`);
`bashy/cmd/bashy/main.go:65` sets `AgentOSBashPPDefault = true` and `.sh`
runs as Bash# in bashy (`bashsharp/README.md:131`). Agents writing ordinary
Bash meet silent meaning changes.

Dialect-on superset is achievable. Syntax probe (`bash -n`):

| Bash# form | Bash | Class |
|---|---|---|
| `func greet() {…}`, `func (r *T) M() {…}`, `outer: for …` | syntax error | R — free |
| `func() {…}` / `func () {…}` | defines shell function `func` | E-live |
| `type T struct {…}`, `type NAME TYPE` | `type` builtin | E-live |
| `import "fmt"` | runs command `import` (ImageMagick ships one) | E-live |
| `x := 42` | runs command `x` → normally 127 | E-dead |
| leading `// …` | runs `//` → 126 | E-dead (only at command start) |

Steps: (1) `func` lookahead — keyword only before `NAME(` or a non-empty
receiver; `func()` stays a Bash definition (expected to recover the seven
fixtures; verify against the named list). (2) Restrict `//` comments to
command position (`ls //tmp` stays Bash). (3) Default-on claims only R and
E-dead; E-live forms activate on `.bsh`, a `bashsharp` shebang or
`set -o bashsharp`. (4) Gate: full conformance matrix dialect-on must yield a
byte-identical fail-set to dialect-off (already proposed in
`bashy/docs/plan-distributed-chunked-execution.md`). (5) `check` warns on
E-live forms in non-`.bsh` files. Residual risk — user functions, aliases or
PATH binaries named `x`, `import`, `func`, `type` — is why (3)–(4) are needed
beyond lookahead.

### G4 — effects are runtime middleware, not language (trait 7)

Vocabulary (atlas) and enforcement (caps, `@contain`) exist, but: no static
check, nil gate in standalone `bashsharp`, ambient authority by default,
fences escape. Smallest step: a static check that a function's
`@effects`/`@guard` declaration covers the atlas effects of its commands, and a
whole-script cap (`bashy run --cap read,net`).

### G5 — stability governance (trait 3)

Machine-readable deprecation registry (Bash++ aliases warn once in
`--json`/agent mode); file syntax changes through `rfcs/`; a compatibility
policy page for alpha-tier constructs; fix the `claims.md` version drift.

### G6 — supply chain outside Go (trait 5)

Pin the Rust toolchain version, pin the Python patch, embed toolchain digests
in source as Node does, and land `env sync --locked` for fence dependencies.

### G7 — explicitness defaults (trait 4)

`.bsh` (not `.sh`) defaults to `errexit`/`nounset`/`pipefail` — the project's
own note calls bash failure semantics "contextual and surprising"
(`bashsharp/docs/bashpp-automation-shortcomings.md:36-38`). `check` warns on
goroutine writes to shell-scope variables (M08).

### Lower priority

One documented concurrency model with warnings on mixing (trait 10);
invariants and property tests (trait 9); an LSP, after G2, as a thin wrapper
over coded JSON diagnostics.

## What the evidence says to stop

Bash#'s own controlled agent trial measured **no benefit** from its novel
features (guards, fences) over plain Bash, at slightly higher token cost —
consistent with the external evidence that novelty does not pay for agents
while a strict verdict, stability and enforced effects do. Invest in G1–G4,
which make the existing language checkable, before new syntax; new syntax
also fights the corpus-coverage factor (trait 3).
