# Sprint 749 plan: a minimal, stable core

Status: **approved 2026-11-28**. Stories: M0a `0341c7477c14`, M0b (filed with the plan update), M1 `3e2c4ff166f0`, M2 `5c260398c214`, M3 `2acc0cc42eeb`, M4 `791735df2789`.
Ruling: the owner, 2026-11-28, answering the Sprint 746 open questions
(bashy `docs/commands-utils-tools.md`, "Owner ruling").
Epic: `core-split`.

## The ruling

- The core is minimal and stable, like bash and Bash#. It changes only when
  the bash or Bash# interface or contract changes, never because a tool is
  added or modified.
- bash, Bash# and the core-only bashy are tagged at the same version.
- The core verbs are only the blank fleet (`model`, `tool`, `agent`), command
  CRUD (`commands`), and `help` and `version`. `help` and `version` read what
  they print from configuration and registry data.
- Everything else is optional.
- `custom/` holds only the adapter mechanism (if needed), never actual tools.
- **Amendment, same day: optional has two packagings.** *Builtin optional*
  tools stay linked in-process, kept for performance. *External optional*
  tools are downloaded and run as separate processes. A tool moves between
  them only when there is a reason. This replaces "unlink everything".

- **Amendment 2, same day: the core depends only on bash and Bash#.** The
  core (the six verbs and the classification they use) may import only the
  Go standard library and the module graph Bash# already has: `qiangli/bash`,
  `bashsharp`, and what they pull in. It may not depend on yoke packages,
  go-git, cobra, otel, YAML libraries or any other module. Builtin optional
  tools may keep any dependency.
  The reason: a change or pin bump in a non-essential package must not
  rebuild the core or invalidate its build and test cache. Go caches per
  package, keyed by the package's own sources and the packages it imports, so a
  core that imports none of them stays cached. The final binary is still
  relinked, because it contains the builtin optional tools.

The packaging axis already exists, so nothing new is introduced. The invariant
class (yoke `pkg/src/class.go`) has `core`, `skill` and `external`. `skill`
("everything else that ships in-process") is builtin optional, and
`external` ("bin-managed: downloaded, verified and exec'd") is external
optional.

| kind | packaging | class |
|---|---|---|
| util | core, always linked | `core` |
| tool | builtin optional, linked for performance | `skill` |
| tool | external optional | `external` |

## Gap, as the code stands today

Code inspected at bashy `9830fa6c` and yoke at its pinned head.

| Ruling | Today | Gap |
|---|---|---|
| Core verbs = 5 plus `--version` | `src.CoreVerbs()` (yoke `pkg/src/class.go:50`) locks 14: `agent model tool skill self src git dag commands inspect secret ask claim resource`. It is ratcheted by yoke `class_test.go:20` and bashy `atlas_views_test.go:37` and `commandkind_test.go`. | Drop 10 verbs and add `help`. Version stays the `--version` flag. |
| `help` from data | `dispatchHelp` (bashy `internal/agentos/help.go:55`) prints compiled topic tables. | Print help from the atlas or registry plus config. A new tool's help comes from its record. |
| version | The `--version` flag exists and is answered by the shell layer (bashsharp `cli/version.go`); there is no `version` verb. | None: keep the flag as it is (D4). |
| Rest optional | After M1 the 10 dropped verbs classify `skill`, which is builtin optional, and stay linked. | None for this sprint. Moving a tool to external optional is a per-tool decision made later. |
| `custom/` = adapters only | `bashy/custom/` has 51 entries: agent CLIs (`claude codex opencode agy aider muse …`), managed externals (`aws gh kubectl helm psql …`) and `internal/adapter`. | Move the tool adapters to `optional/`. Keep only the mechanism. |
| Lockstep tags | bash, bashsharp and bashy are tagged independently. | Builtin optional tools ship in the same binary, so the binary changes when they change. The core contract therefore gets its own version, shared with bash and Bash#. The binary keeps its release version. |

| Core depends only on bash and Bash# | The core verbs run inside `bashy/internal/agentos`, whose package graph has 268 modules. The fleet nouns use yoke `pkg/fleet`, which has 63 modules: go-git, otel, bbolt, gojq, cobra and `gopkg.in/yaml.v3`. `CoreVerbs`/`ClassOf` live in yoke `pkg/src`, which has 176 modules (bleve, chromedp, badger …). yoke `pkg/atlas` is already clean: stdlib plus yoke only. The Bash# graph is bash, readline, pty, u-root and golang.org/x. | A new dependency-clean core package (M0). The rich implementations stay as builtin optional extensions behind it. |

Module counts come from `go list -deps` over each package, excluding test files. M0 measures them again on the lane.

Source protection does not change. It is per path (`src.PathClass` and the
protected manifest, yoke `pkg/src/manifest.go:37`), not per verb.

## Minimal alternatives considered

1. **Classification plus builtin optional (chosen).** Change the verb list,
   help, version and `custom/`. The dropped verbs stay linked as builtin
   optional. This is small, cheap to undo, and reuses the existing classes.
2. **Unlink every optional tool (Base/Core split).** This is a separate binary
   entry without `internal/agentos`, a mass change across bashy, yoke and
   bashsharp. The amendment makes it unnecessary. It remains available as a
   per-tool route to external optional.

## Code inspection: what the minimal core is (2026-11-28)

Inspected at bashy `9830fa6c`+ and yoke at its pinned head. Module counts come from
`go list -deps` on the dev box; this is metadata only, nothing was built.

**The allowed dependency set is the Bash# binary's graph.**
- The `bsh` binary (bashsharp `cmd/bsh`) links coreutils `cmds/all` and `multicall`.
- So "bash and Bash# only" means bash, bashsharp and coreutils plus what they pull in: about 20 modules. That includes cobra, pflag, goawk and gopsutil, and golang.org/x.
- `gopkg.in/yaml.v3` is not in that set. It is the only extra module the core needs (D1).

**The seam already exists.** The bashsharp `cli` package has hook variables
that bashy fills in `cmd/bashy/main.go:48-70`: `AgentOSDispatch`, `AgentOSWireExec`,
`AgentOSShellStartup`, `AgentOSPreamble`, `AgentOSUsage`, `AgentOSShutdown`,
`VersionProduct` and a few more. The core implements these hooks and nothing more.

**A minimal exec wiring already exists.** The adapter-exec branch of `wireExec`
(bashy `internal/agentos/agentos.go:1803`) wires only `Env`, `StdIO`,
`CommandResolver`, `ServedInProcess` (coreutils) and the coreutils exec handler.
That is the core shell profile. The full branch adds about 22 middlewares, and all of them are
builtin optional:
- telemetry, audit, exec history, index visit and the claim guard;
- the advisor, not-found hints, learn and the weave guard;
- autofix, recommend, confirm and dry-run;
- session define, GNU make, dag make and the host converters;
- host floor, contain and limit;
- the decorators and the advice callback.

**What the core holds** (rod, not fish):

| Part | Today | Lines (non-test) | Deps today |
|---|---|---|---|
| Front-door dispatch: verb → core verb or registered extension | `agentos.Dispatch` | part of 139k in agentos | 268 modules |
| Name resolution and exec of registered commands | `commandResolverFor`, `registeredHandler` (bashy `dagmake.go:437`, `registered.go`) | ~1–2k | agentos |
| Ring layer: embedded, shared and local (cloud is optional) | yoke `pkg/assetring`, `pkg/ref` | 0.7k + 1.2k | stdlib only |
| Record types plus read/write for model, tool, agent and command | yoke `pkg/fleet`: `types catalog write setpath overlay resolve kind_records kind_verbs commands` | ~6k of fleet's 29.6k | assetring, ref, yaml.v3, cobra; **binmgr** (63 modules) via `commands.go` |
| `help`, `version` | `help.go` (compiled topics); `--version` flag only | small | agentos |

**The extraction only moves files.** The only real leak is `fleet/commands.go`
importing `binmgr` for `download.url` records. In the core the field stays as
data, and installing (download and verify) becomes an external-optional extension.

**What leaves the core** (builtin optional, still linked):
- the 22 exec middlewares;
- the cloud ring and sync;
- binmgr;
- live probes and the chat context cloner on `agent`;
- the `person` and `whois` nouns;
- infra, pairing, satellites, services, workers and tokens: most of fleet's 29.6k lines;
- the atlas views and reports on `commands` (the core keeps CRUD plus a minimal show with class and kind);
- ycode wiring and the `telemetry.Init` call in `main`.

**A blank fleet is really blank.** The embedded baseline (about 200 YAML files: tools,
models, agents, plans, services, infra, adapters) becomes optional data.
`BASHY_FLEET_SEEDS=off` already drops the roster but keeps the compiled tool
launch contracts. In the core those contracts become data too.

**Behaviour rule for M0b.** Optional extensions register at init, in today's
middleware order, so the built `bashy` behaves exactly as before. The safety
handlers (confirm, dry-run, audit, claim guard, contain, limit) are optional by
the ruling but stay linked and on by default.

**Size estimate.** The core is about 9–10k lines, mostly moved from yoke `fleet`,
`assetring` and `ref` and from three agentos files. It goes into a nested module
(D2 `yoke/core`), so both yoke fleet and bashy can import it without a cycle.

## Principle (owner, 2026-11-28)

- **Move, never invent.** Everything the core needs already exists in the code.
  This sprint only moves code, so that the core is minimal and changes in
  other packages stop reaching it. No story adds a parallel implementation.
  M2 is the only story that changes behaviour, and only by printing data the
  binary already has.
- **Separate packages so change does not spread.** A change in one package must
  not cause a rebuild, a cache invalidation or a re-certification in another.
  The core is the strictest case.
- **bashy is for agents.** An agent on any OS can rely on the minimal set
  without probing:
  - bash builtins;
  - the POSIX-required utilities;
  - Bash# fence support;
  - `commands` add/show/set/remove;
  - the fleet nouns `model`, `tool` and `agent`;
  - `help` and `--version`.

  `help` and `commands --json` lead to everything else.

## Decisions (owner, 2026-11-28: "go with your recommendations")

- **D1:** the core may use the Bash# binary's module graph (bash, bashsharp,
  coreutils and what they pull in, cobra and pflag included) plus exactly one
  listed exception, `gopkg.in/yaml.v3`. It is pure Go, has no dependencies and
  has been frozen since 2022. On-disk records stay YAML, so there is no data migration.
- **D2:** the core is a nested module, `github.com/qiangli/yoke/core`, with its own
  `go.mod`. Both yoke `pkg/fleet` and bashy import it, so there is no cycle.
- **D3:** the safety handlers stay linked as builtin optional and on by default:
  confirm, dry-run, audit, the claim guard, contain and limit.
- **D4: no new commands, verbs or options** (owner, 2026-11-28). The core uses only what exists today:
  - **version** is the existing `bashy --version` flag. There is no `version` verb.
  - **discovery** is the existing `bashy commands --json`. It is already the full manifest, and Sprint 746 added `kind` to it.
  - **further information** comes from the existing `help` verb and `commands NAME`.
  - `self` (update) is an external optional tool, because it needs binmgr and the network. Building bashy is a toolchain tool. `inspect`, `skill` and kb are optional tools, all listed by `commands`.
- **D5:** the six POSIX names served by pinned external providers (`ar nm
  strip ex vi ctags`) are listed in the manifest as "guaranteed after install",
  with their install state in the existing `commands NAME --json` record. Making them pure Go in
  coreutils is a separate follow-up todo.

## Stories (MVP)

**M0a: the core module and class table** (yoke, bashy). This is a move.
- Create the nested module `yoke/core`.
- Move into it:
  - yoke `pkg/assetring` and `pkg/ref`, which use the standard library only;
  - `CoreVerbs` and the bash builtin table from yoke `pkg/src`.
- The old import paths keep working as thin aliases, or their callers are updated in the same commit. There is one implementation.
- **Ratchet:** the modules in `go list -deps` of `yoke/core` must be a subset of the stdlib, plus the module graph of bashsharp `cmd/bsh`, plus `gopkg.in/yaml.v3`. A failure names the offending import.
- **Cache check on the lane:**
  1. Test `yoke/core`.
  2. Bump a non-essential pin such as otel, and touch an optional package.
  3. `go test` of the core must still say `(cached)`, and `go build -x` must show no compile action for the core.
- Add the module to the umbrella `go.work` by hand (never `go work sync`).

**M0b: records and their add/show/set/remove move into the core** (yoke, bashy). This is a move.
- Move the record files of yoke `pkg/fleet` into `yoke/core`: `types catalog write setpath overlay resolve kind_records kind_verbs commands`, about 6k lines.
- Move bashy's resolver and registered-command exec (`commandResolverFor`, `registeredHandler`) into the core too. Fleet keeps the cloud overlay, probes, infra and the rest, and plugs in through the existing option and interface points.
- **The `binmgr` leak:** the `download.url` field stays as data in the core. Installing moves behind an interface that `binmgr` implements outside the core.
- Behaviour and on-disk files are unchanged.
- The full `pkg/fleet`, `internal/agentos` and `cmd/bashy` packages must pass, compared test by test.
- Optional extensions register at init in today's middleware order.

**M1: core verb set = `agent model tool commands help`, plus the `core-contract` surface** (yoke, bashy).
- `CoreVerbs()` becomes these five verbs. Version stays the existing `--version` flag, which the bash builtin and option layer already covers.
- The ten dropped verbs classify `skill`, meaning builtin optional, and stay linked.
- Update the tests that pin the list (yoke `class_test`, bashy `atlas_views_test`, the doc's `core-verbs` block).
- Amend and recertify `command-kinds` through kb `shapeware-issue-to-spec`.
- Lift a new `core-contract` shapeware surface. It is a spec, not a command, and asserts the agent-facing minimal set on Linux, macOS and Windows: bash builtins, the POSIX names (D5 for six), fences, `commands` add/show/set/remove, `model`, `tool`, `agent`, `help` and `--version`. Gates: test, cert, mutate, alone.

**M2: `help` reads data** (bashy). There is no new command or option. Only what the existing output reads from changes.
- `bashy --version` stays exactly as it is. The shell layer answers it (bashsharp `cli/version.go`, not cobra). Its build ID is the stamped release tag, and under the M4 lockstep rule that tag also names the core contract version, so nothing needs adding.
- **`--version` on the core verbs** (owner, 2026-11-28). Set cobra's built-in `Version` field to the existing banner (`bashsharp/cli` `versionBanner`, made reachable by an exported function), so `bashy agent --version`, `bashy model --version` and `bashy tool --version` print the same line as `bashy --version`. `commands` uses its own parser and gets the same line in a few lines of code. This adds no new command. Optional tools are left alone.
- `bashy help` takes its topics from records, not from compiled tables. It names `commands --json` as the discovery entry, so a new tool shows up without a core change.
- **Ratchet:** register a tool in a temporary ring. `commands --json` and `help commands` must show it, and no file under `yoke/core` may change.

**M3: `custom/` = adapters only** (bashy). This is a move.
- `git mv` the tool adapters from `custom/<tool>` to `optional/<tool>`.
- Keep `custom/internal/adapter`, `custom/internal/toolshortcut` and the README.
- Names and dispatch are unchanged. A test pins that `custom/` holds no tool.

**M4: lockstep release rule** (bashy docs).
- bash, Bash# and the core contract (`yoke/core`) share one version, which moves only on a bash or Bash# contract change.
- The binary's release version also moves when a builtin optional tool changes.
- Cite the M0a cache check and the M2 ratchet.

**Order:**
1. M0a, then M0b, then M1.
2. M2 and M3 in parallel.
3. M4.

## Non-goals

- A core-only build that links no optional tool (Sprint 355 design). The amendment no longer requires it.
- Moving any builtin optional tool to external optional. That is a per-tool decision with its own reason (size, licence, platform).
- Emptying the fleet baseline YAML.

## Compatibility

- Every verb keeps its name, flags and output. Only `kind` and `help` listing change.
- `custom/` → `optional/` keeps the registration names. Go import paths inside the bashy module change. Nothing outside bashy imports them (checked in M3 with `go list -deps`).

## Affected repositories

| Repo | Stories |
|---|---|
| yoke | M0 (moves or re-exports `ClassOf`), M1 |
| bashy | M0–M4 |
| umbrella | pins and report |

bashsharp and bash are unaffected.

## Acceptance and venue

- Each story runs its own unit tests plus the `internal/agentos` and `cmd/bashy` packages.
- The `command-kinds` spec must pass test, cert, mutate and alone.
- `bashy mod drift` must be clean.
- The final run is on the Windows test host's Linux lane, against the integrated main.
- No formerly green test may regress. Failures are compared by name.

## Owners, budget, risks, rollback

- **Owner:** the manager is claude-opus5.5. M3 and M4 may go to a worker.
- **Budget:** six stories with no paid services. M0a and M0b are moves across modules; M0b is the largest.
- **Known cost:** mutate takes about 28 minutes per run until conform todo `1fe89580` is fixed.
- **Risk:** agents and docs that assume the 14-verb list. A grep for `CoreVerbs` and the doc block covers this, and the ratchets catch drift.
- **Rollback:** each story is a single revertible commit. M3 is a pure `git mv`.
