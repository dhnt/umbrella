# Sprint 575: separation review before product edits

## Superseded run recovery — 2026-11-19

The operator's reference-only rescope defers the shared-engine, neutral-contract
and separate CLI redesign. Earlier structural-review entries below are historical,
not authorization to replay those changes into the current delivery.

All six remaining pre-rescope Weave runs were reviewed. No missing applicable
reference change remained to integrate:

| Run | Commits | Original tip | Disposition |
| --- | ---: | --- | --- |
| bash-home 4 | 3 | d005bf774e35a9ff13679ab5a41b80439043c27a | Superseded CLI fork with new selector refusal behavior |
| bash-home 5 | 6 | 92b222fa4a2e66d4fcc0daaee390903480602bee | Deferred engine removal and fixture changes |
| bashsharp 2 | 3 | 3e0abf034e6311c8dff419017ec23c668c8f6ea8 | Deferred value, handler and error contract redesign |
| bashy 109 | 3 | ec95e808fa1c70dfe1e2a1852f16220c192484e2 | Deferred catalog extraction and new refusal behavior |
| bashy 111 | 2 | c5314adb47ab6f365918ff8c1891e140545578f7 | Equivalent gate support delivered through published standalone tooling |
| coreutils 3 | 1 | 00da501c087f7ad7bf0a04298e6410b2c8d7ec3a | Imports already relocated; remainder needs deferred contracts and removes retained tests |

Before retiring any workspace, all 18 commits and their full prerequisite history
were saved in six checksum-verified Git bundles, with original run evidence.
The supported superseded disposition also preserved each exact tip as
`refs/salvage/abandoned-<run>` in its owning repository. Every retained ref and
bundle was independently checked against the original tip after retirement.
The six obsolete workspaces are gone; their stories are unassigned and labeled
`superseded-plan`, without claiming implementation acceptance.

No old implementation was merged, no verification was represented as newly
passing, and no frozen POSIX source, artifact, licensed test or active run input
was changed by this recovery.


Date: 2026-11-17. Manager: `s575-codex-manager`.
Status: original source review with subsequent delivery evidence below; full separation remains in progress.

## Agreed outcome and homes

Each product must build and run its own gates from a fresh independent
checkout, without the umbrella, sibling source directories, or go.work:

- Classic: `qiangli/bash`, now carrying the accepted owned source import.
- Bash#: `bashsharp/bashsharp`, retaining its existing Go module identity.
- Composed product: `qiangli/bashy`, consuming fixed lower versions and Yoke.

The operator initially authorized relocation and package-reference/dependency
changes only, then changed the limit to minimum necessary changes after this
review. Narrowly necessary structural seams are now in scope; independently
review the exact design before implementation.
The released rc.37 behavior is preserved; tests must not be weakened.

## Findings checked against source

### The engine is coupled within Go packages

`sh/syntax/nodes.go:351` declares `Command` with the private `commandNode`
method. Bash# nodes declare their implementations in
`sh/syntax/bashpp_nodes.go:1614`. Moving the node declarations to a new
package does not preserve that method's package identity.

`sh/syntax/parser.go:2963` calls Bash# helpers inside Classic parsing.
Those helpers use private parser state and transactions, not merely an
importable function. `sh/interp/api.go:117` stores private Bash# state on
`Runner`; `sh/interp/runner.go:5903` dispatches directly to Bash# methods.
The typed variable hooks also participate in ordinary variable access.

Consequently, full physical extraction cannot be delivered as the proposed
directory moves and import replacements alone. It needs a defined parser
and runtime boundary. That is a scope decision, not a refactoring test
failure and not authority to change behavior. No such edits were made.

### Catalog extraction is not dependency-free

`bashy/internal/core/commands.go:20` imports `yoke/pkg/fleet` for the actual
catalog implementation, command records and CLI. `yoke/pkg/fleet/commands.go`
imports assetring, atlas and binmgr; `Command.Ensure` provisions verified
downloads through binmgr. Moving a file into a different `yoke/...` package
cannot satisfy the cert-base rule banning the entire Yoke module.

The old S1 description therefore omits a real dependency-ownership decision.
Do not remove command behavior or call a Yoke-hosted leaf independent of Yoke.

### Some proposed S4 removals would introduce reverse dependencies

`coreutils/tool/mcpdoc.go` is a dependency-free metadata projection.
`coreutils/cmds/man/man.go:81` uses it. Moving that implementation into Yoke
would make this core utility depend upward. Keep this neutral helper below.

`coreutils/cmds/all/all.go` registers the provider/gate applets. Preserve
their current names and behavior; do not change the certified inventory
as a side effect of relocation. Ownership of agentic policy and neutral
utility mechanisms must be distinguished before moving their packages.

## Design required before engine implementation

The full physical split and the original reference-only edit limit could not
both be met by the proposed package moves. The operator changed the limit to
minimum necessary changes. The next design step
is to specify the necessary parser/runtime structural seams, preserve all
existing semantics and tests, and review the exact change before coding it.
Leaving the implementation shared and merely pinning it is not the agreed
full physical split. The operator subsequently permitted an owned fork if
needed, removed external-upstream tracking, and authorized moving sh source
into qiangli/bash before retiring qiangli/sh. The design must compare the
minimum necessary seam with an explicitly owned fork, preserve behavior,
and enforce the Bash <- Bash# <- bashy dependency direction.

## Gate and dependency audit

AGY completed the read-only gate audit (story `be8c35fd5732`). The release
ledger records green default Go suites, 189 Yoke packages and 86 named Bash
fixtures in each mode. Three make-backed checks were explicitly omitted in
that venue: build-fail-closed, container-mode and scratch verification.
This is released evidence reuse, not new execution of those gates.

`TestCoreImportBoundary` is selected only by the core/cert-base build tags;
it is not exercised by the normal untagged Go suite. Its boundary/outpostagent
violations were already recorded in bashy's story `32566c96a2b2`. The split
must eliminate the offending ownership edges, without widening exceptions.

The former Makefile `test` has nine prerequisites. At the audit baseline, DAG `test` ran
the freshness regression and freshness check, but lacked seven prerequisites
and the freshness target's fresh-binary build step. S0G `4b22a277ee4e` is a
tooling-only port of that exact coverage and the make-backed fixture/mode
paths. Existing assertions and failure-injection expectations must stay intact.

The tooling slice is now accepted: bashy `27255b0d` includes the managed merge
of candidate `8b06fc2a`. Runtime evidence at `09105dcd` covers all nine
prerequisites, the default Go suite and both sealed 86-fixture modes, with
zero fixture skips or timeouts. The final candidate changes only the gate
entry point after that runtime measurement; an exact diff proves unchanged
runtime inputs, and static checks passed on the final and merged trees.
The default Go suite used the conventional nested checkout layout after the
untouched release reproduced the same roster-test failure at the mount root.
The scratch verifier retains its existing no-container-runtime branch inside
the build image; no new skip or weaker assertion was introduced.

Foundation source is accepted and published at `adb3b4e0c28d`, through
graded candidate `99501d39` and managed merge `64e799a`. All 3,269 frozen
source files are preserved; Go and golden files match after the declared
reference transforms, with module metadata differences recorded separately.
The final root and nested-module grade passed with eight Go CPUs and serial
packages; the captured output distinguishes fresh runs from Go cache reuse.
This accepts source relocation before the engine split and Classic CLI work.

`TestSpellingShadowParseScaling` was sensitive to CPU allocation: at one Go
CPU, both untouched and relocated source failed eight of ten repeats; at eight
Go CPUs, both passed all ten. The assertion and implementation remain unchanged.
Follow-up `4bd2091a0e2b` records that existing timing-guard limitation separately.

Foundation contracts A1 and A2 are accepted and published together at
`72c4bd210f74` (`v0.0.0-20261118005152-72c4bd210f74`). A1's full root and
nested-module suite passed at `9ad0c38c`; final `305e4b3d` changed only adapter
comments, attribution and the new nil-hook test, whose focused suite passed
fresh in the locked image. The strengthened test uses an observable real
Classic Runner, proving that adapted nil hooks never fall back to it.

A2's complete root package run at `774d0f9e` failed only its newly introduced
whitespace test: `encoding/json` rejects whitespace before calling the
preserved decoder. All existing root packages passed. Final `ab033e74`
exercises that decoder directly and refuses a nil carrier detail; fresh
`errdetail` and `polyglot` suites passed. The unchanged nested module reuses
A1 evidence. Both source reviews and managed grades passed; merges are
`f2a0228` and `7b442d44`. Existing assertions and decoder logic are preserved.
This accepts execution contracts, not completed engine isolation.

Standalone Bash# and coreutils currently pin an older interpreter than the
release composition. Record each resolved version when establishing the new
accepted foundation; a workspace success is not an independent-build proof.

After separation the Classic-mode fixture lane belongs to the foundation;
the Bash#-mode compatibility lane belongs to Bash#. An aggregate compares
both results. Making Classic depend upward just to run the second mode
would violate the required dependency direction.

## Attribution and validation limits

Codex reviewed engine feasibility (story `8b7e558fdedf`); Muse reviewed
catalog/coreutils ownership (`0c140cac4e12`). Both were launched with
read-only authority. The manager checked the cited private AST boundary,
Classic dispatch, fleet provisioning dependencies and coreutils man/MCP
relationship directly. Historical seam counts were not remeasured and
are not presented as current qualification evidence.


The real worker-envelope integration assertions are preserved under bashy's
`integration/weavecli`, accepted at candidate `cf02d8c8`, merge `00063f18`
and published metadata commit `7d04e7cf`. Exact source comparison permits
only the public API dot import plus the unchanged JSON helper. The focused
integration suite passed fresh in the official image. Coreutils' neutral
contract migration may now remove its old worker-test copy; the final product
cutover still must rebind this coverage to the owned Bash# runtime.

Owned-engine candidate `49e621ae` passed its standalone build and all root
packages except `TestGoSourceLibraryEmission` and
`TestTranspileStandaloneGoBuild`. The first failure was three unmigrated
`.go.golden` generator headers; `4365081d` corrects only four fixture headers
and its fresh lower suite passed. The second requested the correct new runtime
commit before publication. The reviewed candidate branch is now published;
the public Go proxy/checksum service retained the initial unknown-revision
response. Keep checksum verification and the frozen runtime pin unchanged;
that venue propagation delay is not a product repair or accepted passing gate.
