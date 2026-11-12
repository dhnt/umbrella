---
id: 25910e1ade83
kind: test
title: 'T6 Portable bash# dag.md test recipe, UI-to-CLI parity audit, and 3-OS E2E verification'
seq: 162
status: todo
priority: p2
labels:
    - shaping
    - tdd
    - dag
created: 2026-11-12T18:10:17.943676Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:compose-examples-bash-commands-so-they-run-the-same-on-windows`: In `dag.md` and `.bsh` bodies, invoke bashy via `"$BASHY"`, compute script paths with `src=${BASH_SOURCE[0]//\\//}`, and sandbox `BASHY_COMMANDS_DIR`.
- `kb:in-bashy-bsh-the-background-job-marker-is-a-job-handle-not-an-os`: In `bsh` bodies, `$!` is a job handle (`g1`), not a numeric OS PID; `kill` and `kill -0` accept it, but never match it against a numeric PID column.
- `kb:a-bash-go-fence-with-its-own-go-mod-fails-inside-the-umbrella-un`: Set `GOWORK=off` when running `~~~go` fences inside the umbrella.

## SETUP
- Depends on Wave 1 (`T1`–`T3`) and Wave 2 (`T4`, `T5`) merged and single `yoke` pin bump applied in `bashy`.
- Claim shared Linux, macOS, and Windows test hosts via `bashy claim host:<name> --intent "Sprint 621 T6"` before running `--mesh` targets.

## SINGLE-UNIT REPRO
```sh
bashy gate --command 'bashy dag -f bashy/examples/shaping/tdd/dag.md roundtrip' --json
```

## GOAL
- Author `bashy/examples/shaping/tdd/dag.md` (`type: dag`, `default: roundtrip`) with targets:
  - `unit-yoke`: focused `yoke` `pkg/shape/...` and `pkg/webconsole/...` tests (`GOWORK=off`).
  - `unit-bashy`: focused `bashy` `TestShape*` tests (`GOWORK=off`).
  - `build`: builds `bashy`, verifies `shape-tdd.bsh --skill` and `--contract`.
  - `smoke-contract` (` ```bsh ` body with `~~~go` and `~~~sh` fences): tests `@require` (`exit 3`), `@guard` (`exit 126`), and `@ensure` (`exit 0` / `exit 3`) on `shape-tdd.bsh` and checks `bashy craft history`.
  - `roundtrip` (`Requires: build, smoke-contract`): runs full CLI-driven `Red -> Green -> Refactor` pipelines (`wish | verify --phase red | verify --phase green | verify --phase refactor | preview | approve | undo | incident --repair | offer | adopt`) across `kind: web`, `kind: cli`, and `kind: service`, plus shaping `shape-tdd.json` itself; writes portable evidence to `${EVIDENCE:-./shape-tdd-roundtrip.json}` (`schema_version: "bashy-shape-tdd-v1"`).
  - `mesh-linux`, `mesh-darwin`, `mesh-windows`: cross-host dispatch targets (`bashy dag --mesh`).

## ROOT-CAUSE HYPOTHESIS
- Following `examples/desk/dag.md` and `examples/dag/gh/dag.md`, software shaping TDD needs a single deterministic `dag.md` + ` ```bsh ` front door so the conductor gates every CLI verb, UI-to-CLI parity row, and all 3 OSes via `bashy gate --command 'bashy dag ...' --json`.

## SCOPE (Disjoint File Allowlist)
- `bashy/examples/shaping/tdd/dag.md`
- `bashy/internal/agentos/shape_tdd_e2e_test.go`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy dag --check -f bashy/examples/shaping/tdd/dag.md && bashy dag -f bashy/examples/shaping/tdd/dag.md roundtrip && bashy awd bashy -- env GOWORK=off go test -v ./internal/agentos -run "TestShapeTDDE2E"' --json
```

## COMMIT DISCIPLINE
- Planned worker: `agy-gemini3.8-flash` (`BASHY_AGENT=agy-gemini3.8-flash`).
- Stage named files only; never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #162`, `Story-ID: 25910e1ade83` trailers.

## BLOCKERS ESCAPE
- After 3 failed tries, commit `dag.md` and passing targets, and record host/platform blockers in `T6-BLOCKERS.md`.
- Spec: `docs/sprint-621-master-execution-plan.md`.
