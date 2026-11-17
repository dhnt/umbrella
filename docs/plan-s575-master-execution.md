# Sprint 575: independently buildable Classic, Bash#, and Yoke

## Current execution contract — operator approved 2026-11-17

Physically separate Classic Bash, Bash#, and Yoke so each builds and passes
its gates against fixed lower-layer dependencies, making only the minimum
necessary changes and preserving released behavior.

The operator appointed `s575-codex-manager` to deliver this sprint. This
contract supersedes the historical plan below. The operator changed the initial
reference-only limit to minimum necessary changes after the coupling review.
Prefer moving source/tests, package/import references and dependency wiring;
narrowly necessary structural seams are in scope, with the exact design
independently reviewed before coding. No behavior fixes, changed assertions,
skips, gratuitous redesign or widened allowlists. The operator subsequently
permitted an owned fork if that minimizes the split; external upstream tracking
is no longer required. Any deliberately forked runtime must have explicit
ownership, pinned lower dependencies and unchanged-suite evidence.

Clean start verified after fresh fetches: umbrella `f45a5ecc`, bashy
`d783c833`, sh `a4141771`, coreutils `6dd7a3ee`, bashsharp `386a868`,
bashsharp-tests `a18f4026`, yoke `c9057f1e`. Every affected checkout was on
its canonical main/master, clean and exactly synchronized with origin.
The published release `v1.0.0-rc.37` is the green preservation baseline;
the release freeze is cleared. Reproduce exact inputs and venue before
attributing a failure. New candidate failures block integration.

### Outcomes and sequence

1. S0: reuse completed ratchets `72c55602dd2e` from 580. Establish named
   baseline and acceptance DAG targets in the digest-locked official image
   on the gate host. No make, native dev-box suites, or guessed gate parity.
2. Read-only feasibility wave: independently audit the engine extraction,
   catalog/coreutils ownership, and complete release gate/dependency map.
   No product edits until the mechanical split is shown feasible.
3. S1-S4: remove Yoke/Bash# reverse dependencies from cert base and Classic
   entry points; relocate agentic ownership while preserving existing
   utility/provider behavior. Serialize changes sharing implementations.
4. S5: include the relevant evaluator/parser extraction from 581 in 575;
   the full split is required here. The existing private-state coupling is
   a design question: specify and independently review the smallest necessary
   parser/runtime boundary, preserving all behavior and test expectations.
5. S6: Yoke consumes the language boundary; bashy remains the composition
   root. Preserve every supported DAG language tag and execution contract.
6. S7: record the accepted foundation and language versions. Bash# must
   build/test without changing the accepted Bash pin; Yoke/bashy must
   build/test without changing either lower pin. Update ownership guidance.

All acceptance runs use `GOWORK=off`, versioned dependencies and recorded
resolved versions; no sibling checkout overlays. The initial coordinated
split can establish new accepted pins; upper-layer work cannot move them
to get around failures. Commit/push producers before consumers and root pins.

Each of Bash, Bash#, and bashy must build from its own fresh checkout without
the umbrella, sibling source directories, or go.work. Published pinned Go
dependencies are allowed. Each checkout has its own test entry point; the
independence gate must actually exercise those three checkout shapes.
The agreed existing product homes are `qiangli/bash`,
`bashsharp/bashsharp`, and `qiangli/bashy`; keep their existing identities.
The Classic home will own foundation source and its build front door, rather
than remain a wrapper referencing qiangli/sh. The operator permits copying
the whole current sh tree into this home. Migrate consumers to Bash packages;
archive qiangli/sh only after published replacement pins and independent gates
pass. Preserve the old repository/history; do not rewrite or delete it.

### Gate contract

Named `bashy dag` targets: `baseline`, `layer-gate`, `bash-test`,
`bash-posix`, `bashsharp-test`, `yoke-test`, `bashy-test`, `independence`,
and aggregate `accept`. Reuse existing runners. Required former test-script
checks must be present; port make-backed calls before depending on them.
Coordinate that limited work with the Makefile-removal story rather than
absorbing its repository-wide cleanup.

Classic: foundation suites, complete Bash 5.3 fixture names in both existing
modes, and certification preparation/public regression gates. Bash#: its
complete supported corpus against the accepted Bash version. Yoke/bashy:
standalone suites and composition regressions. Independence: clean standalone
rebuilds, unchanged lower source and unchanged resolved lower versions.
Certification readiness is not an official award or release authorization.

Prior structural measurements found 23 cert-base Yoke dependencies, Classic
linkage to bashsharp/front and sh/polyglot, and 12 interpreter polyglot
importers. A targeted boundary test reported boundary/outpostagent violations.
These do not replace the released artifact's green suite evidence; classify
and compare them with exact release coverage before changing anything.

### Staffing and coordination

Use Codex, Muse and AGY for the first independent read-only tasks. Exclude
OpenCode; the GLM/zcode migration is deferred until after this refactor.
Claude is permitted only for an essential blocker/review because its quota
is low. Never launch a worker onto blocked or overlapping implementation.
Run authoritative gates as manager, not from worker success claims.

## Historical plan — superseded by the current contract above

Sprint `65ce85f5-87c0-5863-bf55-62de86f5df36`. State: planned backlog; manager
unassigned. Planning only: this plan authorizes no implementation, worker launch,
take or start. An independent agent review and operator authorization come first.
The card and its stories are authoritative.

Reviewed 2026-11-06. Re-scoped from "formal-release QA" to layer separation at the
operator's direction: clean separation of the Bash, Bash# and Yoke layers comes first,
to stop duplicate work and compounding mix-ups and to unblock other sprints. The
remaining release-QA scope moves to follow-up sprints (see below).

## Main goal

Enforce Classic (sh + coreutils) ← Bash# (bashsharp) ← Yoke in the import graph,
using shrink-only ratchets. The Classic `bash` binary, `cmd/coreutils` and the cert
base build then link no Bash# or Yoke code, without regressing the Classic gate.

Authority: [`bashy/docs/plan-layer-delineation.md`](https://github.com/qiangli/bashy/blob/main/docs/plan-layer-delineation.md)
(operator-approved 2026-11-04: layers A/B/C, stories L1–L5, violations V1–V4,
removal of `--bashsharp`/`--bashpp` from the `bash` binary). This sprint delivers
that plan. It does not redefine it.

## Measured baseline (2026-11-06, `GOWORK=off go list -deps`)

- `bashy/cmd/bash` links `bashsharp/front` and `sh/polyglot` (V1).
- `-tags bashy_cert_base ./cmd/bashy` links 21 `qiangli/yoke` packages, including
  `yoke/pkg/telemetry`, through `internal/core → yoke/pkg/fleet` (V3), plus
  `bashsharp/transpile` (V4). `TestCoreImportBoundary` forbids telemetry, so it is
  presumed failing. Record that as a pre-existing failure; do not repair it silently.
- `sh/interp` imports `sh/polyglot` from 12 non-test files. 208 of 352 interp files and
  26 syntax files are `bashpp_*`. `sh/{lower,gosource,polyglot,grammar}` hold about
  110K LOC of Bash# inside the foundation module (V2).
- `coreutils/pkg/weavecli` imports `sh/polyglot` and reaches `cmd/coreutils` through
  `pkg/schedule` and `pkg/nudge`. `pkg/nudge`, `tool/mcpdoc`, the schedule LLM-budget
  hook and `posixproviders` are agentic or optional code still in coreutils.
- `yoke/pkg/dag/interp_bashpp.go` drives `LangBashPP` and polyglot directly through
  sh, bypassing bashsharp.

The existing ratchets to extend are:
- `sh/interp/gosource_dependency_test.go`
- `bashsharp/front/import_graph_test.go`
- `bashy/cmd/bashy/core_imports_test.go`
- `bashy/internal/agentos/import_graph_test.go`

## Stories

| Order | Story | Prio | Work | Exit evidence |
|---|---|---|---|---|
| — | `dad90d644fa5` | P0 | Umbrella delineation story (L1–L5); the slices below deliver it | all slices accepted |
| S0 | ratchets | P0 | Per-layer import ratchets with an explicit, shrink-only allowlist of today's violations: sh/interp bans gosource/lower/grammar (polyglot allowlisted until S5); `cmd/bash` bans yoke, coreutils, bashsharp, polyglot (allowlisted until S3); cert base bans all `qiangli/yoke` and `bashsharp/transpile` (allowlisted until S1/S2); `cmd/coreutils` bans yoke, bashsharp and the sh Bash# packages (polyglot allowlisted until S4). An umbrella `script/layer-gate.sh` runs them with `GOWORK=off` | green on pinned SHAs; mutation proof that one injected import fails; status of `TestCoreImportBoundary` recorded |
| S1 | V3 | P0 | `internal/core` stops importing `yoke/pkg/fleet`; the catalog it needs moves to a leaf package | cert-base yoke count 21 → 0; allowlist entry removed |
| S2 | V4 | P0 | `bashsharp/transpile` leaves `bashy_cert_base` (`main_core.go`) | cert base links no bashsharp; S355 "Bash# in Base" wording reconciled |
| S3 | V1 / L2 | P1 | `internal/cli` reaches the Bash# front only through an injection hook (like `AgentOSDispatch`); `bash --bashsharp/--bashpp` fails with a clear pointer to `bashy`/`bashsharp`; changelog entry | `cmd/bash` links no bashsharp or polyglot; Classic 86/86 container |
| S4 | L4+ | P1 | `weavecli`, `nudge`, `mcpdoc`, the schedule LLM hook and `posixproviders` move from coreutils to yoke; coreutils keeps opaque hooks only | `cmd/coreutils` links no Bash# package; coreutils name-set ratchet |
| S5 | L1a | P1 | `interp → polyglot` goes behind a registration seam; `sh/{lower,gosource,grammar,polyglot}` relocate into the bashsharp module, together with the interp tests that import them | `go list -deps ./interp` has no Bash# package; full sh tests, bashsharp-tests harness, bashy `make test`, 86/86 container |
| S6 | V10 | P2 | `yoke/pkg/dag` runs Bash# through bashsharp or an injected runner (pattern: `yoke/pkg/skills` `WithBashSharpRunner`) | yoke imports no `sh/lower`, `gosource` or `polyglot` directly |
| S7 | docs | P2 | Reconcile stale guidance: `sh/CLAUDE.md` ("lives here deliberately"), `bashsharp/CLAUDE.md`, `bashsharp/docs/seam.md`, the bashy CLAUDE layer table, the umbrella "ENGINE stays in sh" line, the S355 Base definition, the `dad90d644fa5` freeze wording; file the missing `af65f24e` seam card | docs agree with the delineation plan |

Sequence: S0 is the P0 entry gate, so nothing new can mix in while fixes land. S1 and S2
are small and run in parallel. Then S3 and S4. S5 is the large step. S6 and S7 can run
alongside S5. Each fix removes its own allowlist entry in the same change.

## Gates and evidence rules

- Every sh or bashy change runs Classic `make test-bash-container` 86/86 and
  `make test` before and after, on the remote test host, never the dev box. Every
  coreutils change runs `go test ./...` there as well.
- The licensed 493-TP hosts are retired. Report each change to linked certification
  inputs to S571's owner for evidence-identity revalidation
  (`bashy/docs/s561/evidence-identity.md`). This sprint does not claim that gate.
- Allowlists only shrink. A pre-existing failure is tracked separately, never reported as passing.
- Submodule workflow: commit and push inside each subproject, then bump the umbrella pin.

## Coordination

Before touching shared sh, bashy or coreutils code, coordinate with the managers of
S580 (rc.25 candidate freeze), S571 (certification residuals), S578 (fence corpora)
and S579 (shaping E2E). Land changes before or after a candidate freeze, never during
one. Claim shared test hosts with `bashy claim` before use.

## Follow-up sprints

- **Sprint 581** `cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7`, "Layer separation phase 2":
  - the 208 interp and 26 syntax `bashpp_*` files behind an extension seam
    (about 204 unexported Runner members, per `bashsharp/docs/seam.md`)
  - agentic constructs moved out of the engine
  - `set -o bashsharp` and `shopt bashpp` gated at runner construction
  - the `sh/moreinterp/coreutils` duplicate
  - `--agentic` flags in grep/find and `time --budget`
  - `execbudget` naming
  - the `github.com/dhnt/dhnt` dependency versus `bashy/dhnt`

  Depends on S5.
- **Sprint 582** `61100927-2041-52d8-9db6-0983e3bbf7f8`, "Formal-release QA evidence
  feeder for Sprint 128": original 575 items (1) and (3)–(9). It feeds Sprint 128's
  gate and never replaces it. Ownership reconciliation:
  - inventory: 379, `release-bar-v1.json`, 578 E1
  - shaping E2E: 579
  - POSIX: 341/561/571/385, with 571 R8 for public coverage
  - packaging: 128, 566, 580

  Open operator decisions: skip policy versus the 539 ledger, cloud and cluster tier
  cost, whether signing and govulncheck block, and ownership of the 341 residuals.
  Depends on S0.

## Execution boundaries

Only the operator authorizes take or start, after the agent review. This sprint
authorizes no release; v1.0.0 still requires official POSIX certification and
explicit operator approval.
