---
id: 1358b7b33a92
kind: feature
title: A1 conform repo + module skeleton, CLI front door decision
seq: 756
status: done
priority: p0
labels:
    - conform
created: 2026-11-25T21:18:55.011741Z
assignee: claude-opus5.5
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
closed: 2026-11-25T21:22:41.98215Z
closed_by: claude-opus5.5
---

Create public github.com/dhnt/conform (MIT), Go module skeleton (contract/, walk/, cert/, cmd/conform), README, CLAUDE.md, dependency-direction test. Front door decision: conform ships its own CLI cmd/conform; bashy exposes it as a thin `bashy conform` pass-through (A6); `bashy shape verify` integration is a follow-up, not MVP. CI = local go vet + go test (no GitHub workflow, per the build-locally rule). Acceptance: repo exists; GOWORK=off go vet ./... && go test ./... green; umbrella mounts conform/ as a flat submodule with CLAUDE.md layout + script/sync.sh list updated.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
