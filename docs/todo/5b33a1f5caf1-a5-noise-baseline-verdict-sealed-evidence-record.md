---
id: 5b33a1f5caf1
kind: feature
title: A5 noise baseline, verdict, sealed evidence record
seq: 760
status: todo
priority: p1
labels:
    - conform
created: 2026-11-25T21:18:56.03867Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

Depends on A3. Package cert: Baseline(runs [][]contract.Result) marks assertions that disagree reference-vs-reference as noisy (port compute_noise_baseline/grade_candidate_against_baseline/combine_verdicts, grader_lib.py ~1433-1530); Verdict per layer (cli, ui) combined with AND (any FAIL -> FAIL; any INCONCLUSIVE -> INCONCLUSIVE; else PASS); Evidence record JSON: conform version, contract sha256, candidate identity (caller-supplied digest), reference identity, environment summary, each result with fresh|reused, timestamp; Seal = sha256 over canonical JSON, Verify(record) bool. CLI: `conform cert --contract C --reference-cmd ... --candidate-cmd ... --runs N --out evidence.json` may be minimal. Acceptance: unit tests for noise marking, AND verdict, seal tamper detection.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
