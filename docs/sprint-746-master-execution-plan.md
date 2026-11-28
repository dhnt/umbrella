# Sprint 746: utils vs tools, the minimal bashy built-in set (MVP)

Manager: claude-opus5.5. Requested by the operator on 2026-11-28, after an audit of bashy's layering
against the shapeware specs.

## Goal

One vocabulary and one pinned list of what bashy must build in:

- **command**: anything you can type. This is the umbrella word, and prose may keep using command, util and tool interchangeably.
- **util**: the built-in minimum. That is the shell builtins, Bash#, the 116 POSIX-required utilities, and the bashy core verbs (registry, blank fleet, skills, help, inspect, self, the result envelope).
- **tool**: everything else registered with bashy, by source: core, optional, example, toolchain, custom. Tool is the same word as in *tool as a service*.

It also removes a module smell found in the same audit: bashsharp's go.mod requires yoke only for tests that belong to bashy.

## Operator rulings (2026-11-28)

1. GNU-only coreutils, the names outside the POSIX 116, are classified as **optional tools** but **stay linked in**. Classification is not packaging.
2. MVP: the doc, the ratchet and a demotion-candidate list. **Nothing leaves the binary in this sprint.** Unlinking is the Base/Core split (`bashy/docs/sprint-355-core-optional-design.md`).
3. The sprint is managed by claude-opus5.5; delegate only where it helps.
4. Follow the shapeware procedure for every behaviour change (kb `shapeware-issue-to-spec`, `shapeware-lift-app`).

## Code inspected (2026-11-28; bashy 72365e3e, yoke 04f13f6d, bashsharp 0ec897e)

- **Shell builtins:** `bash/interp/builtin.go:46-160`. bashy adds `awd`, `setsid`, `runner-state` and `strmatch`. Plain `bash` disables `nohup`, `setsid` and `newgrp` (`bashsharp/cli/main.go:600`).
- **POSIX 116:** `yoke/pkg/atlas/origin.go:30`.
- **Atlas records:** `bashy/internal/agentos/atlas.go:33` (`atlasRecord`: class, dispatch_class, origin, posix) and `:95` (`atlasCatalog`).
- **Views:** `atlasViews` at `:696`, the view switch at `:870`, and `printAtlasByKey`.
- **One-command report:** `commandFeatureReport` (`commands.go:393`) via `atlasFeatureFields` (`atlas.go:1349`).
- **In-process front-door verbs:** the `Dispatch` switch (`agentos.go:708-1455`) minus `adaptedVerbs` (`adapter_dispatch.go:35`). The list is in `bashy/docs/commands-utils-tools.md`.
- **Shapeware surfaces:** no bashy surface covers `bashy commands` today. The existing ones are `agent-identity`, `shape` and `hitl`.
- **bashsharp's yoke require:**
  - It comes only from `cli/main_test.go:20` (`_ "github.com/qiangli/yoke/cmds/all"`).
  - Several `cli/*_test.go` files go-build `github.com/qiangli/bashy/cmd/bashy`, `yoke/cmd/yoke`, or run `bashy ycode`. These modules are not in bashsharp's go.mod; the tests work only under the umbrella go.work.
  - These tests arrived with the CLI move (bashsharp 4295cf1, 2026-11-17).

## Stories

| Story | What | Repo | Procedure |
|---|---|---|---|
| U1 `194d9cf946b5` | `bashy/docs/commands-utils-tools.md`: words, util list, the yoke commands built in today, demotion candidates | bashy | doc |
| U2 `3613c719f5e4` | lift the narrow `bashy/shapeware/command-kinds` surface; new feature `util-tool-kind`: `bashy commands NAME --json` carries `"kind": "util" or "tool"`, `bashy commands --view kind` lists both; a go test pins the core util verbs to the doc | bashy | shapeware: lift (today's behaviour), then new feature as `tbd`, gate 1, build, spec change, gates |
| U3 `3a25d5ece9bd` | move bashsharp's bashy, yoke and ycode coupled cli tests to `bashy/cmd/bashy`; drop the yoke require and yoke-only replaces; add a ratchet | bashsharp, bashy | not a shapeware surface (no observable behaviour changes; tests move unchanged); root cause before fix, by test name |

### U2: the shapeware route

1. **Lift.** `bashy/shapeware/command-kinds/` contains `SKILL.md`, `CONTRACT.md`, `features.yaml`, `dag.md` and `judge.sh`, modelled on `agent-identity`.
   - The contract asserts today's `bashy commands NAME --json` fields (`dispatch_class`, `origin`, `posix`) for one name per class: builtin, POSIX coreutils, GNU-only coreutils, yoke applet, core verb, workplace verb.
   - The new feature is filed as `tbd` with its acceptance lines.
2. **Gate 1.** The operator approved the util list and the vocabulary on 2026-11-28 and delegated delivery to the manager ("take the sprint and deliver"). The manager records gate 1 on the card.
3. **Build in a work copy** (implementation, about 40 lines):
   - `commandKind(atlasRecord)` returns util for a shell builtin or a POSIX-required name. It also returns util for a front-door verb in `coreUtilVerbs` (and its aliases). Everything else is a tool.
   - `Kind` goes on `atlasRecord` and into the one-command report.
   - `kind` is added to `atlasViews`.
   - `TestCommandKindCoreVerbsMatchDoc` pins `coreUtilVerbs` to the doc's list, and checks that every listed verb exists.
4. **Spec change.** The `util-tool-kind` feature becomes `verified`, its assertions are added, and `reference-commit` moves to the built commit.
5. **Gates** on the Windows test host's Linux lane: `check`, `test`, `cert` (3 runs), `mutate`, `alone`. Also `go test ./internal/agentos -run 'Atlas|Commands|CommandKind'`.

## Not in MVP (follow-up todos)

- Unlinking built-in tools from the binary (sprint 355 split).
- Emptying the fleet baseline YAML.
- Renaming `custom/` (today it holds agent-CLI and managed-external adapters; operator-added commands live in the `commands add` ring).
- bashsharp tests that go-build `qiangli/bash/cmd/bash`, a go.work-only dependency (`cli/carrier_unix_test.go:54`).
- The interpreter's `BASHY_*` names.
- Shapeware specs for the rest of the util set.

## Venue

Builds and tests run on the Windows test host's Linux lane (`~/lanes/gate-lane.sh run`), never on the dev box. Claim the lane first, then release it.

## Acceptance

- U1: the doc is merged; its lists match the code inspected.
- U2: `conform spec check` is clean. `test`, `cert`, `mutate` (every mutant killed) and `alone` all PASS on the lane. The go test passes.
- U3:
  - `GOWORK=off go test ./...` in bashsharp passes.
  - `go list -m all` and `go list -deps -test ./...` in bashsharp name no yoke, bashy or ycode.
  - Each moved test passes by name in bashy, and no formerly green test is skipped.
- Pins: the umbrella pins are bumped and `bashy mod drift` is clean for bashsharp and bashy.
