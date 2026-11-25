---
id: 50afc2441064
kind: feature
title: A6 mutation harness incl. UI mutants
seq: 761
status: todo
priority: p1
labels:
    - conform
created: 2026-11-25T21:18:56.294823Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

Depends on A3+A4. Package cert: Mutant{Name, Layer, Apply} where a mutant wraps the candidate environment (CLI: a PATH shim that alters one command's output/exit, e.g. drop a JSON key, flip status, wrong exit; UI: an HTML transform, e.g. drop a label, flip required, remove an option, hide a button). Mutate(contract, env, mutants) reports killed/survived per mutant; suite strength = killed/total. Seed a default mutant set derived from the contract assertions (one per assertion key/exit) plus UI mutants from the inventory. Acceptance: on the fake CLI in testdata every seeded mutant is killed; unit tests green.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
