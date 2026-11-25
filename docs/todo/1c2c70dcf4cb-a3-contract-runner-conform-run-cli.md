---
id: 1c2c70dcf4cb
kind: feature
title: A3 contract runner + conform run CLI
seq: 758
status: todo
priority: p0
labels:
    - conform
created: 2026-11-25T21:18:55.529022Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

Depends on A2. contract.Run(ctx, []Assertion, Env) []Result: runs each assertion's commands in order via a configurable shell (default sh -c; Env sets dir, PATH prefix, extra env, per-step timeout), threads Bindings across steps, INCONCLUSIVE on timeout/start failure. CLI: `conform run CONTRACT.md [--dir D] [--path P] [--shell S] [--timeout 30s] [--json]` prints one line per assertion 'PASS|FAIL|INCONCLUSIVE <name> <detail>' (or JSON array), exit 1 if any FAIL/INCONCLUSIVE. Port semantics of execute_contract_suite (grader_lib.py ~1296-1432) minus agent-bench specifics (no form building, no hard-rule log scanning). Tests use a tiny fake CLI written as a shell script in testdata. Acceptance: unit tests green incl. timeout and binding-across-steps cases.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
