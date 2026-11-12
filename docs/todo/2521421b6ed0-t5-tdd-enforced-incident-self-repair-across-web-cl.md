---
id: 2521421b6ed0
kind: feature
title: 'T5 100% CLI parity and TDD-enforced incident self-repair across web, CLI, and service apps'
seq: 161
status: todo
priority: p2
labels:
    - shaping
    - tdd
created: 2026-11-12T18:10:17.791244Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`: Agent-first CLI parity — every feature and management action available through a web app must have an equivalent Bashy CLI operation on the same entities, with equivalent identity, permissions, and approval rules.
- `kb:native-shaping-needs-ancestor-refs-and-completed-container-stops`: Preserve the rollback baseline and reconcile the owned container before changing its declaration.

## SETUP
- Depends on Wave 1 (`T1`, `T2`, `T3`) merged in `yoke`.
- Work inside isolated `weave` workspaces for `yoke` and `bashy` with `GOWORK=off`.

## SINGLE-UNIT REPRO
```sh
bashy awd yoke -- env GOWORK=off go test -v ./pkg/webconsole -run 'TestIncident.*TDD' && bashy awd bashy -- env GOWORK=off go test -v ./internal/agentos -run 'TestShapeLocalIncidentCLIParity'
```

## GOAL
- `TestShapeLocalIncidentCLIParity`: remove the `hostKind` CLI refusals in `bashy/internal/agentos/shape_local.go:114-117` so `bashy shape incident APP [MESSAGE] [--id ID] [--kind script|asset|exit|healthz] [--repair] --json` and `bashy shape offer|adopt APP ... --json` work identically from the CLI across `web`, `cli`, and `service` apps.
- `TestIncidentRepairRequiresRedThenGreen`: `yoke/pkg/webconsole/shaped_repair.go` enforces `RedOnBase && GreenOnCandidate` via `verify.Run` before auto-activating or proposing review for any `app_code` incident repair, using the exact same service path as `bashy shape incident APP --id ID --repair --json`.

## ROOT-CAUSE HYPOTHESIS
- `bashy/internal/agentos/shape_local.go:114-117` hard-refuses `incident`, `offer`, and `adopt` when `hostKind` is true (`kind: cli` / `kind: service`), breaking CLI parity; `yoke/pkg/webconsole/shaped_repair.go:149` asks for red-then-green only in prompt prose without verifier enforcement.

## SCOPE (Disjoint File Allowlist)
- `yoke/pkg/webconsole/shaped_repair.go`
- `yoke/pkg/webconsole/shaped_repair_test.go`
- `bashy/internal/agentos/shape_local.go`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy awd yoke -- env GOWORK=off go test -v ./pkg/webconsole -run "TestIncident|TestShapedRepair" && bashy awd bashy -- env GOWORK=off go test -v ./internal/agentos -run "TestShapeLocal"' --json
```

## COMMIT DISCIPLINE
- Planned worker: `muse-spark1.3` (`BASHY_AGENT=muse-spark1.3`).
- Stage named files only; never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #161`, `Story-ID: 2521421b6ed0` trailers.

## BLOCKERS ESCAPE
- After 3 failed tries, commit passing unit tests and document blockers in `T5-BLOCKERS.md`.
- Spec: `docs/sprint-621-master-execution-plan.md`.
