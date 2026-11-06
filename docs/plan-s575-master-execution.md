# Sprint 575 master execution plan: layer separation (Classic ← Bash# ← Yoke)

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
