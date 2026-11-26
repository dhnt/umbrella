---
id: 6525c1232820
kind: feature
title: A7 form contract recorded from the reference + bashy conform front door
seq: 762
status: done
priority: p1
labels:
    - conform
created: 2026-11-25T21:18:56.548355Z
assignee: claude-opus5.5
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
closed: 2026-11-25T23:42:00.671352Z
closed_by: claude-opus5.5
---

Depends on A3-A6. (a) Record CONTRACT.md for bashy examples/desk/form from the reference build (start from the t4 prototype F-01..F-09; add UI inventory expectations) into bashy examples/desk/form/CONTRACT.md; it passes on the reference with zero noisy assertions over 3 reference runs and kills every seeded mutant. (b) bashy: `bashy conform ...` pass-through to conform's CLI in-process, conform required in bashy go.mod at a published tag (v0.1.0), GOWORK=off build green. Runs on the gate host lanes, not the dev box. Acceptance: evidence record sealed and saved; bashy GOWORK=off build + the new command's unit test green.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
