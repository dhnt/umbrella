---
id: 227e29b78d35
kind: feature
title: 'T1 Red-on-Base verifier primitive: prove candidate-added checks fail on base before passing on candidate'
seq: 157
status: todo
priority: p1
labels:
    - shaping
    - tdd
created: 2026-11-12T18:10:17.300995Z
sprint: 621
sprint_id: 12e0ca54-4941-5b64-bc6c-4eb80ac71a59
sprint_title: 'Software Shaping TDD workflow: Red-Green-Refactor verification across web, CLI, and service shaping'
---

## KNOWN TRAPS (`bashy kb context`)
- `kb:native-shaping-needs-ancestor-refs-and-completed-container-stops`: An ancestor restore or isolated verifier clone needs both `BaseSHA` and `CandidateSHA` reachable. Advertise both revisions temporarily in the isolated clone and restore prior HEAD/refs cleanly after staging candidate-added checks onto `BaseSHA`.
- `kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`: Keep the Go verifier primitive KISS/MVP (rod, not fish): add `Phase: "red"|"green"|"refactor"` on `verify.Options` and `RedCheckResults` on `evidence.Record` with deterministic JSON output; do not add new packages.

## SETUP
- Work inside an isolated `weave` workspace for `yoke`.
- Always run Go commands with `GOWORK=off`.

## SINGLE-UNIT REPRO
```sh
bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run 'TestVerifyRedOnBase'
```

## GOAL
- `TestVerifyRedOnBaseRejectsTautologicalCheck`: a candidate-added check (`From == "candidate"`) that exits `0` on `BaseSHA` fails `verify.Run` when `Phase` is `"red"` or `"green"` (default TDD).
- `TestVerifyRedOnBasePassesGenuineRedGreenCheck`: a candidate-added check that exits non-zero on `BaseSHA` (`RedOnBase: true`) and exits `0` on `CandidateSHA` (`GreenOnCandidate: true`) passes `verify.Run` and populates `RedCheckResults` in `evidence.Record`.
- `TestVerifyPhaseRedOnly`: `Options{Phase: "red"}` runs only the Red-on-Base check against `BaseSHA` and exits `0` iff `RedOnBase: true`.

## ROOT-CAUSE HYPOTHESIS
- `yoke/pkg/shape/verify/verify.go:280-399`: `freezeChecks` tags net-new candidate check scripts under `checks/` as `From: "candidate"`, but `verify.Run` only executes checks after detaching the verifier clone to `CandidateSHA`.

## SCOPE (Disjoint File Allowlist)
- `yoke/pkg/shape/verify/verify.go`
- `yoke/pkg/shape/verify/verify_test.go`
- `yoke/pkg/shape/evidence/evidence.go`

## GATE (`--verify`, 3 clauses)
```sh
bashy gate --command 'bashy awd yoke -- env GOWORK=off go build ./pkg/shape/... && bashy awd yoke -- env GOWORK=off go test -v ./pkg/shape/verify -run "TestVerifyRed" && bashy awd yoke -- env GOWORK=off go test ./pkg/shape/...' --json
```

## COMMIT DISCIPLINE
- Planned worker: `codex-gpt6-sol` (`BASHY_AGENT=codex-gpt6-sol`).
- Stage named files only (`git add pkg/shape/verify/verify.go pkg/shape/verify/verify_test.go pkg/shape/evidence/evidence.go`); never `git add -A`.
- Include mandatory `Sprint: #621`, `Story: #157`, `Story-ID: 227e29b78d35` trailers.

## BLOCKERS ESCAPE
- After 3 failed attempts on an unexpected isolation issue, commit partial passing tests and write `T1-BLOCKERS.md` with exact reproduction output.
- Spec: `docs/sprint-621-master-execution-plan.md`.
