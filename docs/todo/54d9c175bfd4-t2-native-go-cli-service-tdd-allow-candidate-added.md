---
id: 54d9c175bfd4
kind: feature
title: 'T2 Native Go/CLI/service TDD: allow candidate-added tests with Red-on-Base and Green-on-Candidate accounting'
seq: 158
status: todo
priority: p1
labels:
    - shaping
    - tdd
created: 2026-11-12T18:10:17.421944Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:native-shaping-needs-ancestor-refs-and-completed-container-stops`: Preserve the rollback baseline in every isolated verifier clone when staging candidate `*_test.go` files onto `BaseSHA`.
- `kb:windows-go-sdk-junction-resolution`: Preserve handle-based path resolution when invoking `go test` across OSes.

## SETUP
- Work inside an isolated `weave` workspace for `yoke`.
- Always run Go commands with `GOWORK=off`.

## SINGLE-UNIT REPRO
```sh
bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run 'TestProgramGoCandidateAddedTests'
```

## GOAL
- `TestProgramGoBaselineTestsStayImmutable`: modifying or deleting any baseline `*_test.go` file or `Test*` function present in `BaseSHA` is rejected by `guardProgramTree`.
- `TestProgramGoCandidateAddedTestsRedGreen`: adding a net-new `*_test.go` file or `Test*` function in `CandidateSHA` is permitted, tagged `From: "candidate"`, verified Red-on-Base (`go test -json` fails or fails to compile against `BaseSHA` when `RequireRed: true`), and verified Green-on-Candidate (all baseline `Test*` + all candidate `Test*` pass in `go test -json`).

## ROOT-CAUSE HYPOTHESIS
- `yoke/pkg/shape/verify/program.go:220-244` (`guardProgramTree`) and `yoke/pkg/shape/verify/program_go.go:202-320` (`programBaselineChecks`, `verifyGoProgram`), documented at `yoke/docs/shape-programs.md:65`, freeze all `*_test.go` paths and refuse candidate test additions.

## SCOPE (Disjoint File Allowlist)
- `yoke/pkg/shape/verify/program.go`
- `yoke/pkg/shape/verify/program_go.go`
- `yoke/pkg/shape/verify/program_test.go`
- `yoke/docs/shape-programs.md`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy awd yoke -- env GOWORK=off go build ./pkg/shape/... && bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run "TestProgramGo" && bashy awd yoke -- env GOWORK=off go test ./pkg/shape/...' --json
```

## COMMIT DISCIPLINE
- Planned worker: `claude-opus5.5` (`BASHY_AGENT=claude-opus5.5`).
- Stage named files only (`git add pkg/shape/verify/program.go pkg/shape/verify/program_go.go pkg/shape/verify/program_test.go docs/shape-programs.md`); never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #158`, `Story-ID: 54d9c175bfd4` trailers.

## BLOCKERS ESCAPE
- After 3 failed tries, commit passing unit tests and document remaining blockers in `T2-BLOCKERS.md`.
- Spec: `docs/sprint-621-master-execution-plan.md`.
