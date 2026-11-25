---
id: a0f0c4aadb31
kind: bug
title: 'Release registration step fails: register-product-release.sh still requires darwin/amd64 (dropped in rc.40) and looks up the outpost commit on the GitHub API unauthenticated'
seq: 753
status: assigned
priority: p1
labels:
    - release
created: 2026-11-25T15:18:04.755025Z
assignee: claude-opus5.5
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
---

Found by release.yml run 45641994904 (v1.0.0-rc.41-dev, 2026-11-25T15:17Z): publish succeeded (pre-release, 34 assets), then 'register development product release' exited 1 with 'missing outpost-v1.0.0-rc.41-darwin-amd64'. Root cause (product, release tooling): scripts/register-product-release.sh loops os in darwin linux windows x arch in amd64 arm64, but darwin/amd64 is no longer built (5 platforms since rc.40). Second defect in the same script: line 13 resolves the outpost commit via api.github.com without auth (the step's env passes no GITHUB_TOKEN), so the call can 403 on the shared runner rate limit; that is what failed rc.40's run 45111432045 (curl 403, then the JSON decode traceback, before any webhook POST), not the hosted webhook. Effect: the published bytes are unaffected; the hosted release index is not told about the release, so outposts do not auto-roll to it. promote.yml's 'register stable product release' runs the candidate's copy of the script after creating the release, so promoting rc.41 will publish and then fail this step the same way. Fix (post-release, bashy main): derive the platform list from the dist (or the 5 supported platforms), pass GITHUB_TOKEN to the step or use OUTPOST_COMMIT from the job; VALIDATE_ONLY regression test. Registering rc.41 afterwards needs a dispatch that uses the fixed script (operator decision).
