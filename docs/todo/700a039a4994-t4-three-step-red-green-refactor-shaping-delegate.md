---
id: 700a039a4994
kind: feature
title: 'T4 Composable CLI flags (--phase, --contract) and shapeable Bash# skill-script (shape-tdd.bsh + shape-tdd.json)'
seq: 160
status: todo
priority: p1
labels:
    - shaping
    - tdd
    - bashsharp
created: 2026-11-12T18:10:17.654477Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`: Small verbs, composed (rod, not fish). Every operation is available as a `bashy shape ... --json` CLI verb that reads/writes JSON and composes in Unix pipelines. High-level orchestration is a `<100`-line `.bsh` skill-script (`shape-tdd.bsh`) with an embedded `~~~skill as guide` fence and a JSON shaping hook (`shape-tdd.json`).
- `kb:compose-examples-bash-commands-so-they-run-the-same-on-windows`: Compute script directory with `src=${BASH_SOURCE[0]//\\//}` before `dirname`; call tools through `"$BASHY"`, never bare `bash` or `PATH`; sandbox `BASHY_COMMANDS_DIR` in command-registration tests.
- `kb:a-bash-go-fence-with-its-own-go-mod-fails-inside-the-umbrella-un`: Always set `GOWORK=off` when running or testing `examples/` `.bsh` commands inside the umbrella.

## SETUP
- Depends on Wave 1 (`T1`, `T2`, `T3`) merged in `yoke`.
- Work inside isolated `weave` workspaces for `yoke` and `bashy` with `GOWORK=off`.

## SINGLE-UNIT REPRO
```sh
bashy awd bashy -- env GOWORK=off go test -v ./internal/agentos -run 'TestShapeVerifyPhase'
```

## GOAL
- `bashy/internal/agentos/shape.go`: add `--phase=red|green|refactor` and `--contract ID...` to `bashy shape verify APP ID [--json]` so every TDD step is a stateless, composable CLI rod:
  - `bashy shape verify APP ID --phase red --json`
  - `bashy shape verify APP ID --phase green --json`
  - `bashy shape verify APP ID --phase refactor [--contract ID...] --json`
- `yoke/pkg/shape/delegate.go` + `yoke/pkg/webconsole/shaped_candidate.go`: update `WishPrompt` to drive `Red -> Green -> Refactor` via CLI verbs and expose `{red_on_base, green_on_candidate, refactor_clean}` in `bashy shape show/verify --json` and the Genie review bar.
- `bashy/examples/shaping/tdd/shape-tdd.bsh` + `shape-tdd.json`: `<100`-line executable Bash# skill-script (`#!/usr/bin/env -S bashy --bashsharp`) with an embedded `~~~skill as guide` fence, `@guard`/`@require`/`@ensure` contract, and externalized policy in `shape-tdd.json` (`SHAPE_TDD_CONFIG` shaping hook, following `examples/collab-save/collab-save.bsh` + `collab-save.json`).

## ROOT-CAUSE HYPOTHESIS
- `bashy/internal/agentos/shape.go:54` (`verify APP ID`) currently takes no `--phase` or `--contract` flags, and there is no composable `.bsh` TDD skill-script with a shaping hook.

## SCOPE (Disjoint File Allowlist)
- `yoke/pkg/shape/delegate.go`
- `yoke/pkg/webconsole/shaped_candidate.go`
- `bashy/internal/agentos/shape.go`
- `bashy/examples/shaping/tdd/shape-tdd.bsh`
- `bashy/examples/shaping/tdd/shape-tdd.json`
- `bashy/skills/bashy/commands/shape.md`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy awd yoke -- env GOWORK=off go test ./pkg/shape/... ./pkg/webconsole/... && bashy awd bashy -- env GOWORK=off go test -v ./internal/agentos -run "TestShape" && bashy --bashsharp bashy/examples/shaping/tdd/shape-tdd.bsh --skill >/dev/null' --json
```

## COMMIT DISCIPLINE
- Planned worker: `opencode-glm-5.3` (`BASHY_AGENT=opencode-glm-5.3`).
- Stage named files only; never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #160`, `Story-ID: 700a039a4994` trailers.

## BLOCKERS ESCAPE
- After 3 failed tries, commit passing unit tests and document blockers in `T4-BLOCKERS.md`.
- Spec: `docs/sprint-621-master-execution-plan.md`.
