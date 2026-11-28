# Sprint 746 report: utils vs tools, the minimal bashy built-in set

Manager: claude-opus5.5. U3 was delivered by a claude-opus5.5 worker and
reviewed by the manager. Plan: [sprint-746-master-execution-plan.md](sprint-746-master-execution-plan.md).

## What changed

- **One vocabulary.**
  - **command** is the umbrella word, and prose may keep using it loosely.
  - **util** is the built-in minimum: never offered, metered or sold.
  - **tool** is everything else registered with bashy, by source: core, optional, example, toolchain or custom. It is the same word as in *tool as a service*.
  - The definitions are in bashy `docs/commands-utils-tools.md`.
- **No second list.** The util set derives from the existing invariant class (yoke `pkg/src/class.go`):
  - A util is every shell builtin, bashy's own (`awd` …) included.
  - A util is also every `core` name, except a GNU coreutils name POSIX does not require. The operator ruled those optional tools that stay linked.
  - The core verbs are the existing locked 14 (Sprint 458 M0): `agent model tool skill self src git dag commands inspect secret ask claim resource`.
- **Observable behaviour.**
  - `bashy commands NAME --json` now carries `"kind": "util" | "tool"`.
  - `bashy commands --view kind` lists the utils, then the tools: 172 utils and 215 tools at this commit.
  - `TestCommandKindCoreVerbsMatchDoc` pins the doc's core verb list to `src.CoreVerbs()`.
- **The yoke commands built in today** are listed in the doc: the in-shell applets, and the front-door verbs that run in-process. Every built-in tool is a candidate to move out of the binary, and none was moved (operator ruling).
- **bashsharp is free of yoke, bashy and ycode.**
  - Eight bashy-product tests moved from `bashsharp/cli` to `bashy/cmd/bashy` with their bodies unchanged: `TestAgentTUINativeOverPTY`, `TestInteractiveBashPPLiveDialect`, `TestInteractiveBashPPPOSIXGrammarContract`, `TestNoExecParsesWithoutRunning`, `TestGoSourceExecutableEnvironment`, `TestOwnedExecLargeArgAndEnv`, `TestCLIBashyExplicitBashPPOptionRemainsDiscoverable`, and the bashy front of `TestCLIBashPPPOSIXContract`.
  - bashsharp's yoke require and ten copied fork replaces are gone. go.mod shrinks by about 200 lines and go.sum by about 1060.
  - The ratchet `TestModuleNamesNoYokeBashyYcode` keeps them out.

## Root cause (U3)

The yoke require was test-only:
- `cli/main_test.go` blank-imported `yoke/cmds/all`.
- Seven test files built bashy, yoke or bash binaries by package path. Those modules were absent from bashsharp's go.mod, so the tests ran only under the umbrella go.work.

The tests arrived when the CLI moved from bashy into bashsharp (bashsharp 4295cf1, 2026-11-17). The import was not needed:
- Replacing it with `coreutils/cmds/all` left the PASS/FAIL/SKIP name list identical in both modes.
- Classification: test placement (test defect), not product.

## Shapeware route (U2)

The route followed kb `shapeware-issue-to-spec` for a new feature, and `shapeware-lift-app`:
1. Lift the narrow surface `bashy/shapeware/command-kinds` from today's behaviour (C-01..C-10), with `util-tool-kind` filed as `tbd`.
2. Gate 1, settled by the manager under the operator's delegation and recorded on the card.
3. Build.
4. Spec change: K-01..K-12, the feature becomes `verified`, spec 0.2.0, reference bashy a32a1a39.

## Evidence (fresh runs, the Windows test host's Linux lane)

| Check | Result |
|---|---|
| lift at bashy 5e983886: test / cert / mutate / alone | 10/10, PASS, 56/56, PASS |
| command-kinds at the integrated tip 2a2209ba: lint, test, cert (3 runs, none noisy), mutate, alone | clean, 22/22, PASS, 94/94, PASS |
| bashy `go vet ./internal/agentos ./cmd/bashy`; build linux, darwin, windows | PASS |
| bashy `go test ./internal/agentos` (full package) | ok (537 s) |
| bashy `go test ./cmd/bashy` (full package) | ok: 25 top-level PASS = 17 existing + 8 moved |
| bashsharp b379d8d: `go list -m all` / `go list -deps -test ./...` name no yoke, bashy or ycode | clean |
| bashsharp ratchet; workspace-mode `./cli/... ./front/...` | PASS; ok (193 PASS; the only names missing against baseline are the 8 moved tests) |
| bashy 9830fa6c (bashsharp pin bump): vet, windows build, `./cmd/bashy`, agentos command subset | PASS |

## Pre-existing failures and venue findings (recorded, not repaired)

| Finding | Evidence | Class | Tracked |
|---|---|---|---|
| bashsharp `GOWORK=off go test ./cli` fails: tests build `qiangli/bash/cmd/bash`, a module bashsharp cannot require (cycle) | identical failures at 0ec897e | test defect, pre-existing | umbrella todo `32ac76b4` |
| `shapeware/index.bsh check` fails every surface | bare `conform` has no `spec` | product defect, pre-existing | bashy todo `7dd90046` |
| `TestToolShortcutE2E` failed twice mid-sprint (PTY timeouts) | passed at baseline, at the spec commit and at the code commit when re-run alone; failed only while another job loaded the same host | venue (host load) | this report |
| command-kinds `mutate` took 28 min for 22 assertions | each mutant reruns the whole contract including the cited go test | judge performance | conform todo `1fe89580` |
| `gofmt -l` flags `bashsharp/cli/carrier_windows_test.go` and five `bashy/cmd/bashy` files | untouched by this sprint | style, pre-existing | this report |

## Pins

- Pushed to main: bashy `9830fa6c` (bashsharp b379d8d) and bashsharp `b379d8d`.
- The umbrella gitlinks are bumped.
- ycode requires bashsharp only indirectly through its bashy pin. The bashy↔ycode edge is a cycle that trails by design and is bumped by hand.

## Open questions for the owner (in the doc, not decided)

1. Should `help`, `run`, `full` and `out` join the core verbs?
2. Should `dag`, `claim`, `secret`, `ask`, `resource`, `src` and `git` stay core? Changing either set amends the Sprint 458 record and source protection.
3. Should `custom/` be renamed, so that "custom" means only operator- and agent-added commands?

## Not in this sprint

- Moving built-in tools out of the binary (the Sprint 355 Base/Core split).
- Emptying the fleet baseline YAML.
- Shapeware specs for the rest of the util set.
