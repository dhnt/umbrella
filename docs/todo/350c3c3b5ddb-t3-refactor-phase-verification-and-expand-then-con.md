---
id: 350c3c3b5ddb
kind: feature
title: 'T3 Refactor-phase and --contract verifier primitive (--phase refactor)'
seq: 159
status: todo
priority: p1
labels:
    - shaping
    - tdd
created: 2026-11-12T18:10:17.540168Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`: KISS/MVP and expand-then-contract. Reuse the existing `--contract` flag vocabulary (`bashy/internal/agentos/shape.go:108`) rather than inventing a new `--retire` flag or a separate `preflight.go` file.

## SETUP
- Work inside an isolated `weave` workspace for `yoke`.
- Always run Go commands with `GOWORK=off`.

## SINGLE-UNIT REPRO
```sh
bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run 'TestRefactorPhase'
```

## GOAL
- `TestRefactorPhaseInvariance`: `verify.Options{Phase: "refactor"}` requires all baseline + existing checks to pass (`100% Green`), enforces zero uncontracted surface removals (`CompareSurface`) and zero effect-cap escalation, and does not require a new failing-on-base check.
- `TestRefactorPhaseContractRemoval`: `verify.Options{Phase: "refactor", Contract: []string{"old_unit"}}` permits removing a previously expanded unit/route/flag only when explicitly listed in `Contract` and all remaining checks pass.

## ROOT-CAUSE HYPOTHESIS
- `yoke/pkg/shape/verify/surface.go:135-196` (`CompareSurface`) and `yoke/pkg/shape/service.go` currently lack `Phase: "refactor"` and `Contract: []string` options on `svc.Verify`.

## SCOPE (Disjoint File Allowlist)
- `yoke/pkg/shape/verify/surface.go`
- `yoke/pkg/shape/verify/surface_test.go`
- `yoke/pkg/shape/service.go`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy awd yoke -- env GOWORK=off go build ./pkg/shape/... && bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run "TestRefactorPhase" && bashy awd yoke -- env GOWORK=off go test ./pkg/shape/...' --json
```

## COMMIT DISCIPLINE
- Planned worker: `claude-sonnet5.5` (`BASHY_AGENT=claude-sonnet5.5`).
- Stage named files only (`git add pkg/shape/verify/surface.go pkg/shape/verify/surface_test.go pkg/shape/service.go`); never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #159`, `Story-ID: 350c3c3b5ddb` trailers.

## BLOCKERS ESCAPE
- After 3 failed tries, commit passing unit tests and document blockers in `T3-BLOCKERS.md`.
- Spec: `docs/sprint-621-master-execution-plan.md`.
