---
id: a0f0c4aadb31
kind: bug
title: 'Release registration step fails: register-product-release.sh still requires darwin/amd64 (dropped in rc.40) and looks up the outpost commit on the GitHub API unauthenticated'
seq: 753
status: done
priority: p1
labels:
    - release
created: 2026-11-25T15:18:04.755025Z
assignee: claude-opus5.5
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
closed: 2026-11-25T17:42:16.411367Z
closed_by: claude-opus5.5
---

Found by release.yml run 45641994904 (v1.0.0-rc.41-dev, 2026-11-25T15:17Z): publish succeeded (pre-release, 34 assets), then 'register development product release' exited 1 with 'missing outpost-v1.0.0-rc.41-darwin-amd64'. Root cause (product, release tooling): scripts/register-product-release.sh loops os in darwin linux windows x arch in amd64 arm64, but darwin/amd64 is no longer built (5 platforms since rc.40). Second defect in the same script: line 13 resolves the outpost commit via api.github.com without auth (the step's env passes no GITHUB_TOKEN), so the call can 403 on the shared runner rate limit; that is what failed rc.40's run 45111432045 (curl 403, then the JSON decode traceback, before any webhook POST), not the hosted webhook. Effect: the published bytes are unaffected; the hosted release index is not told about the release, so outposts do not auto-roll to it. promote.yml's 'register stable product release' runs the candidate's copy of the script after creating the release, so promoting rc.41 will publish and then fail this step the same way. Fix (post-release, bashy main): derive the platform list from the dist (or the 5 supported platforms), pass GITHUB_TOKEN to the step or use OUTPOST_COMMIT from the job; VALIDATE_ONLY regression test. Registering rc.41 afterwards needs a dispatch that uses the fixed script (operator decision).

**Fixed (2026-11-25):** bashy 33eb4197. The script skips darwin/amd64 as `verify-release-asset-set.sh` does, and both workflow steps pass `GITHUB_TOKEN: ${{ github.token }}`. The receiver accepts any non-empty artifacts map, so a five-platform payload is valid. Regression: `scripts/register_product_release_test.go` `TestRegisterProductReleaseRegistersBuiltPlatforms` passes, and fails on the old script and workflows. Also confirmed by promote.yml run 45665724813, which failed the same way. rc.40 and rc.41 remain unregistered; registering rc.41 with the fixed script is an operator decision, not part of this story.

**Retry path and rc.41 registered (2026-11-25 10:16 PST):** promote.yml's manual re-run could not retry registration: it refuses a released version and runs the candidate's copy of the script. bashy 7056994f adds a `register_only` dispatch input; its job runs the current ref's script against the candidate's go.mod outpost pin and the published outpost assets, which it checks against the release `checksums.txt`. Run 45673460107 (`-f version=v1.0.0-rc.41 -f register_only=true`) succeeded, and the hosted index answered `{"ok":true,"prerelease":false,"tag":"v1.0.0-rc.41"}`. rc.40 was never promoted and needs no registration.
