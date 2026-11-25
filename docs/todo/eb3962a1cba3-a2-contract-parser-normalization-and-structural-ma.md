---
id: eb3962a1cba3
kind: feature
title: A2 contract parser, normalization and structural matcher (Go port)
seq: 757
status: todo
priority: p0
labels:
    - conform
created: 2026-11-25T21:18:55.268899Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

Port grader_lib.py parse_contract_md, normalize_cli_output, _substitute_command_placeholders, _match_template_string, _parse_expected_json, match_json_structural, check_assertion_output (lines ~781-1045) to package contract as pure functions: Parse(io.Reader) ([]Assertion, error) with Name/Prose/Commands/Expected/Exit; Bindings (placeholder -> value, bind on first match, consistent later); Check(a Assertion, stdout string, exit int, b Bindings) Result{Name, Status PASS|FAIL|INCONCLUSIVE, Detail}. Fixtures: copy packs/shapeware/t4-lifecycle/fixture/CONTRACT.md (strip the canary comment) into contract/testdata/form-v1/CONTRACT.md plus recorded outputs; table tests for each placeholder, '...' open fields (object key and scalar), loopback normalization, plain-text-only-where-given, exit mismatch, malformed contract. Acceptance: same verdicts as the Python on the fixtures; unit tests green.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
