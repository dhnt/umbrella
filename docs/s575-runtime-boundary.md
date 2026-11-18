# Sprint 575: owned language engine and shared execution boundary

Status: Codex round-2 design, independently reviewed by Muse. Foundation
handler and error contracts accepted; owned-engine adoption and final isolation
gates remain in progress.
Date: 2026-11-17. Story: `a4b8f1a7ee1a`.

## Ownership

The foundation is the flat root Go module `github.com/qiangli/bash`.
Relocate the frozen sh source there first, preserving behavior and licenses.
Keep coreutils at `github.com/qiangli/coreutils`, consuming this foundation.
The first relocation commit retains the complete source snapshot; it does
not claim that language extraction has already happened.

Bash# keeps `github.com/bashsharp/bashsharp`. It owns its parser, AST,
expansion and evaluator packages under `engine/`, copied from the frozen
implementation with corresponding tests/fixtures. Preserve the copied logic;
remove language branches from Classic in separate reviewed commits after
the new language path is established. This deliberate fork avoids a large
public parser/Runner state API. External upstream tracking is not required.

The strict dependency direction is Bash <- Bash# <- bashy. Bash# uses pinned
Bash neutral environment/handler contracts and utilities; Bash never imports
Bash#. Full bashy composes the B superset runtime with Yoke; the independent
Bash executable uses A. No qiangli/sh replacement remains after cutover.
Archive that repository last, preserving its history.

## Minimum shared handler boundary

Bash's accepted `interp` adapter exposes the following execution-only API:

```go
func WithHandlerContext(ctx context.Context, hc HandlerContext) context.Context
func AdaptHandlerContext(hc HandlerContext, kind HandlerKind, hooks HandlerHooks) HandlerContext

type HandlerKind int
const (
    HandlerKindExec HandlerKind = iota + 1
    HandlerKindCall
    HandlerKindOpen
    HandlerKindReadDir
)

type HandlerHooks struct {
    DryRun        func() bool
    Async         func() bool
    Umask         func() os.FileMode
    SignalIgnored func(string) bool
    Builtin       func(context.Context, []string) error
    DescribeValue func(string) (ValueDescription, bool)
}
```

Keep the existing public HandlerContext fields and methods. An adapted
context stores hooks and kind privately; its methods consult those hooks.
Unadapted Classic contexts retain their original runner-based paths. An
adapted context with an empty hook set reports neutral results without
falling back to the Classic Runner. Callback function values are copied;
the state captured by those callbacks remains live. Preserve the exec-only restriction on Builtin.

Every language-engine handler dispatch publishes both its own private
context and a compatible foundation context. Cover exec, call, open and
directory dispatch, async paths and subshells. Both views have the same
live environment, directory, stdio, exec flags and operation position.
Convert positions through public offset/line/column accessors, preserving
invalid positions as invalid. Callbacks capture the current language Runner
so dry-run, umask, signal state, builtin behavior and typed value description
remain live, rather than construction-time copies.

Stat/lstat remain pass-through and receive no new handler kind or mandatory
context wrapping. Preserve existing bare-context handling. Both views carry
Agentic, ExecAs, ExecClearEnv and ExecReplace. Keep the language engine's
private network-redirection/exec-replacement/test markers on the original
context chain; they are consumed by its own handlers. Do not translate those
private markers to the foundation or call foundation defaults from B.

HandlerContext is deliberately two views, not two incompatible middleware
contracts: B retains its private runner-bound shape, while foundation-typed
middleware reads the explicitly published adapted foundation view. Do not
alias B's private runner-bound context to A's struct or lose either key.

The language engine retains its own default exec/open/directory/stat
handlers. Foundation defaults access foundation-private Runner state and
redirection markers and must not be used as language-engine fallbacks.

## Shared type identity

Proposed aliases from language engine to the accepted foundation:

- expand: ValueKind, Variable, Environ, WriteEnviron and all corresponding
  value-kind constants, explicitly including Object, KeepValue and Unset/Unknown.
- interp: ExecHandlerFunc, CallHandlerFunc, OpenHandlerFunc, ReadDirHandlerFunc,
  ReadDirHandlerFunc2, StatHandlerFunc, ExitStatus, SignaledStatus,
  ValueField and ValueDescription.

Preserve foundation status identity through SignaledStatus.Unwrap and the
NewExitStatus/IsExitStatus compatibility functions. Reuse neutral foundation
environment constructors/methods where aliases would prohibit duplicate
method declarations. No alias of the language Runner, parser or AST is allowed.

Keep language AST, parser, Runner and options owned by Bash#. Audit events
and structured diagnostics with language positions need explicit conversion
at the product boundary; do not alias events that embed incompatible AST
position types. Review the full source use before treating this alias list
as sufficient for compilation.

## Neutral error detail boundary

Coreutils' command envelope currently imports `polyglot` for one structured
error record and its extractor. Keep that data below the language runtime:
the foundation's `errdetail` leaf owns `ErrorDetail`, its unchanged JSON tags
and `UnmarshalJSON`, a deep `Clone` helper, and an extractor using `errors.As`
against `ForeignErrorDetail() *ErrorDetail`. The leaf imports only standard
library packages. Bash# aliases the DTO and retains its private worker-error
implementation and constructors; private `clone`/`err` receiver methods become
package-local helpers rather than methods on a non-local alias.

The private carrier publishes a cloned detail through that small method.
Keep the existing public language wrapper and its behavior. Preserve ordinary
and wrapped errors, legacy string frames, empty cause levels, exact message
rendering, clone isolation and unwrap identity. Coreutils consumes only the
leaf and retains its existing eight-cause envelope limit. Real worker tests
belong with the language runtime or an integration package; coreutils' own
tests use the neutral decoder and carrier without importing upward.
Muse's initial DTO-only suggestion was insufficient; Codex independently
reviewed this complete carrier boundary before implementation.

## Product composition and order

Relocate the Classic CLI path from bashy into the Bash home, preserving
Classic invocation/startup behavior. The existing Bash# command front door
switches to its owned engine. Full bashy and Yoke retain one owned B superset
runtime for both Classic-compatible and opt-in Bash# modes, as the existing
single-runtime product does. Mechanically migrate their full concrete type
boundary together, including middleware, harnesses and front/transpile hooks.
This avoids adding dual concrete Runner/AST branches to the product.

Move the existing shared CLI surface to Bash#'s public `cli` package and
rewire full bashy's imports and injected hooks to it. Keep the independent
Classic CLI in Bash. Codex independently reviewed this composition against
the existing CLI source; the owned engine and CLI gates still have to prove it.

Cover cold invocation, warm serve/session, MCP session, interactive startup
and direct embedding paths. Setting a language selector on a Classic Runner
is not a substitute for constructing the language-owned parser and Runner.
Rewire yoke/pkg/dag/interp_bashpp.go through the owned Bash# engine or its
injected runner, preserving every supported tag. Its Classic-compatible
interpreter, contracts and skills use the same B runtime in Classic mode;
the independent pure Classic artifact uses A. Preserve effect-cap ordering,
per-task isolation and status mapping.

Move/provide B's interactive package for the product. Keep ownedexec's frame,
marker and adoption protocol shared with the foundation/coreutils and preserve
signal-launcher environment restoration. Ycode's Bash# AST inspection needs
B types; its independent Classic TUI fallback may retain A. Outpost's transitive
pins must close as well. The certified/base wrapper may delegate to a separate
A Classic app only if applets, startup and flags are preserved; the full product's
command registry must remain intact. Do not silently replace its applet route
with the lean shell-only executable.

Dependency order: foundation source relocation -> shared handler boundary ->
owned language engine/aliases -> language front door -> product composition ->
Classic language-code removal -> accepted/published pins -> independent gates.
Coreutils changes only its foundation imports/pin unless a demonstrated
boundary requirement demands more. Preserve all utility/provider behavior.

The source review of Classic removal also covers shared-file branches:
parser transactions, AST fields and printer/walker cases; Runner allocation,
reset and dispatch; ordinary variable/builtin/signal hooks; and CLI selection.
Remove each B branch while preserving its existing Classic path. Move mixed
language tests by individual case, retaining their Classic assertions in A.
Do not leave B-named false-return stubs as a substitute for removing the
implementation. Preserve the shared neutral data contract above, including
Object/Variable identity and generic serialization helpers needed by B;
remove A's B-dialect activation logic, not those shared data types. The later
removal review's suggestion to delete the Object contract is not adopted.

Classic fixtures run against the Bash artifact; language-mode compatibility
and the supported language corpus run against the Bash# artifact. The
aggregate requires both. Each independent checkout runs its own DAG targets
in the official image, without sibling sources or go.work. No test weakening,
skips or unrelated repairs. The new boundary is accepted only on unchanged
Classic/Bash# behavior plus the existing handler/context integration cases.

## Review focus and evidence limits

Review sh/interp/handler.go and runner.go, coreutils/shell/handler.go,
bashy's cold/warm CLI and MCP session paths, and both DAG runner bindings.
The independent review must check every context construction path, private
default-handler dependency, error/status identity and shared environment type.
This is a source-derived design, not a passing build or suite result.

Muse round 2 confirmed the six handler-hook signatures and bounded scope.
The manager incorporated pass-through stat, explicit error/constant identities,
exec flags, distinct AST/Runner ownership and Yoke composition coverage.
The review's suggestion to alias the private runner-bound context and mirror
foundation-private markers was not adopted: the design intentionally retains
B's context/markers and publishes an additional adapted A view, with B-owned
defaults. Source use and integration tests must verify that invariant.
