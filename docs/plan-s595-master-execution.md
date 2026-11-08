# Sprint 595 master execution plan: bashy CLI consistency and capability shaping

Sprint `a8bd6c0a-b86c-5928-84b5-21c8bb2865b2`. Manager: `s595-manager`. The card
and its stories are authoritative; this plan records the reviewed sequence, root
causes, delegation and gates. Reviewed 2026-11-08.

## Phases

**Phase 1 — six CLI audit bugs** (one batch, workers in isolated weave
workspaces, merged sequentially). **Phase 2 — capability guidance**: caac5708
is the requirements record, delivered by d2218fd3 → 56ec344f, with 81bb8a39
(shape target for bashy itself) before shaping advice ships, and 6ee2c255
proving verified activation. Phase 2 starts after Phase 1 merges.

## Phase 1 root causes and scopes

| Story | Root cause | Repo · scope | Owner |
|---|---|---|---|
| 52d62b99 help-format syntax | formatted help intercepts only exactly `CMD --help` (`internal/agentos/skillhelp.go` `dispatchFormattedHelp`) | bashy · `skillhelp.go` + tests/testdata | codex-gpt6-sol |
| c15db516 transpile help | `classicHelp` treats any non-empty output as success; `transpile` (bashsharp) has no usage | bashy · same lane as 52d62b99; transpile usage via bashy-side intercept in `agentos.go` | codex-gpt6-sol |
| a2c31bad db help (routing) | `help` refuses applets when `--format` is explicit | bashy · same lane as 52d62b99 | codex-gpt6-sol |
| a2c31bad db help (applet) | `yoke/cmds/db` parses `--help` as an operation | yoke · `cmds/db` | opencode-glm-5.3 |
| 934e13cc `--explain=false` | `common_options.go` ignores the `=value` of `--explain` | bashy · `common_options.go` + tests | opencode-kimi-k2.7-code |
| 8ff69f1a option metadata | `adoption.go` marks any declared flag "supported"; adapt declares `--since` but refuses it | bashy · `adoption.go` + tests/goldens | muse-spark1.3 |
| d6abbdbf canonical names | `peer` help text teaches `sphere`; fleet help says `tools verify`/`agents show` | yoke · `external/sphere/sphere.go`, `pkg/fleet/cli.go` | agy-gemini3.8-flash |

`adapt` keeps exit 125 for adapter failures (documented semantics); 8ff69f1a
changes metadata only.

## Exclusions and dependencies

- bashsharp (`transpile`) is not edited in this sprint (migration baseline
  policy); its real usage moves upstream as follow-up work.
- `adapt --since` stays unavailable until the shared cursor binding seam (S19).
- yoke fixes reach bashy through a yoke pin bump (`src_mount.go` pins +
  regenerated `testdata/skillhelp` goldens).

## Gates

Worker verify: targeted `GOWORK=off go test` of the touched packages on the
workspace. Full gates (`go test ./internal/... ./tools/...`, `make test-bash`,
yoke tests) run on the remote test host before the pin bump, never the dev box.
Help-syntax audit re-run across the 89 checked command records closes 52d62b99.

## Delegation (Phase 2, not yet launched)

d2218fd3 claude-sonnet5.5 · 56ec344f codex-gpt6-astra · 81bb8a39 claude-opus5.5 ·
6ee2c255 opencode-deepseek-v4-pro.
