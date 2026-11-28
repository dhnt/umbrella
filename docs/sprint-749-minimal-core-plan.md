# Sprint 749 plan: a minimal, stable core

Status: **backlog**. It needs operator review before start.
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

## Gap, as the code stands today

Code inspected at bashy `9830fa6c` and yoke at its pinned head.

| Ruling | Today | Gap |
|---|---|---|
| Core verbs = 6 | `src.CoreVerbs()` (yoke `pkg/src/class.go:50`) locks 14: `agent model tool skill self src git dag commands inspect secret ask claim resource`. It is ratcheted by yoke `class_test.go:20` and bashy `atlas_views_test.go:37` and `commandkind_test.go`. | Drop 10 verbs, add `help` and `version`. |
| `help` from data | `dispatchHelp` (bashy `internal/agentos/help.go:55`) prints compiled topic tables. | Print help from the atlas or registry plus config. A new tool's help comes from its record. |
| `version` verb | Only the `--version` flag exists; there is no `version` verb. | Add `bashy version`, printing build info and config data. |
| Rest optional | Classification only: after M1, `kind` makes them tools. Physically, `cmd/bashy` still links `internal/agentos`, which pulls in most of yoke. | The physical unlinking is the Sprint 355 Base/Core design (bashy `docs/sprint-355-core-optional-design.md`). |
| `custom/` = adapters only | `bashy/custom/` has 51 entries: agent CLIs (`claude codex opencode agy aider muse …`), managed externals (`aws gh kubectl helm psql …`) and `internal/adapter`. | Move the tool adapters to `optional/`. Keep only the mechanism. |
| Lockstep tags | bash, bashsharp and bashy are tagged independently. | Write the release rule. Tagging itself waits for the core-only build. |

Source protection does not change. It is per path (`src.PathClass` and the
protected manifest, yoke `pkg/src/manifest.go:37`), not per verb.

## Minimal alternatives considered

1. **Classification first (chosen for this sprint).** Change the verb list,
   help, version and `custom/`. Nothing leaves the binary. This is small,
   cheap to undo, and the `kind` view shows the target immediately.
2. **Full Base/Core split now.** This is a separate binary entry without
   `internal/agentos`. It is a mass change across bashy, yoke and bashsharp,
   and is too big for one MVP sprint. It is planned as the follow-up below.

## Stories (MVP)

**M1: core verb set = 6** (yoke, bashy)
- Change `CoreVerbs()` to `agent model tool commands help version`.
- Amend the Sprint 458 M0 record line in the comment.
- Update the ratchets (yoke `class_test.go`, bashy `atlas_views_test.go`, the doc's `core-verbs` block).
- Amend the `command-kinds` shapeware spec: the K assertions for the moved verbs flip from util to tool. Recertify: test, cert, mutate, alone.
- Route: kb `shapeware-issue-to-spec`. The feature change is filed `tbd`, gate 1, build, then the spec change.

**M2: help and version from data** (bashy)
- `bashy version` prints the build info and the configured release channel.
- `bashy help` lists the core verbs plus every registered tool, read from the atlas or registry.
- Ratchet: register a tool in a temporary ring, then check that `help` shows it and that no core path changed (`src.PathClass` = core for none of the touched files).

**M3: `custom/` = adapters only** (bashy)
- `git mv` the tool adapters from `custom/<name>` to `optional/<name>`.
- Keep `custom/internal/adapter` and `custom/internal/toolshortcut` (the mechanism) plus the README.
- Registration names, dispatch and behaviour are unchanged. This is a pure move.
- A test pins that `custom/` holds no tool.

**M4: lockstep release rule** (bashy docs)
- One paragraph in the release doc: bash, Bash# and core-only bashy share one version.
- A core release happens only on a bash or Bash# contract change.
- Tagging starts when the core-only build exists (follow-up).

## Non-goals (follow-up sprint, not filed until M1–M4 close)

- The core-only build: a `cmd/bashy` base entry that does not import `internal/agentos` (Sprint 355 design). Optional verbs then run as verified child runners.
- Moving optional verbs out of the binary.
- Emptying the fleet baseline YAML.

## Compatibility

- Every verb keeps its name, flags and output. Only `kind` and `help` listing change.
- `custom/` → `optional/` keeps the registration names. Go import paths inside the bashy module change. Nothing outside bashy imports them (checked in M3 with `go list -deps`).

## Affected repositories

| Repo | Stories |
|---|---|
| yoke | M1 |
| bashy | M1–M4 |
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
- **Budget:** about 4 small stories, with no paid services.
- **Known cost:** mutate takes about 28 minutes per run until conform todo `1fe89580` is fixed.
- **Risk:** agents and docs that assume the 14-verb list. A grep for `CoreVerbs` and the doc block covers this, and the ratchets catch drift.
- **Rollback:** each story is a single revertible commit. M3 is a pure `git mv`.
