# Sprint 575: separation review before product edits

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
