---
id: ef2ce499a64a
kind: bug
title: 'S14 outpost bug: apps share|unshare|shares still send the pre-S619 {app, circle|email} body; move to the grant-rule form {app, circles[], groups[], emails[]}'
seq: 305
status: assigned
priority: p1
labels:
    - shaping
    - content
    - trove
    - outpost
    - parity
created: 2026-11-15T00:02:48.835468Z
weave: 257
assignee: codex-gpt6.2-sol
sprint: 710
sprint_id: 063b46d6-77e0-5d5b-8dc0-2fd08f8234a2
sprint_title: 'Owner sharing: apps and suites to circles and members, public apps, invites that arrive'
---

Planned vendor: codex. PUBLIC outpost change, small, separate commit; trove share (S6) shells to this verb so it inherits the bug. Root cause (recorded before the fix): Sprint 619 changed the host-share wire to a strictly decoded grant rule {app, circles[], groups[], emails[]} (400 invalid_request otherwise; S630 S22 fixed the cloudbox console but not outpost); outpost/internal/agent/portal/shares.go CreateHostCircleShare and AppShare still use {app, circle} / Email, and unshare matches on share.Email so rule rows are never found. Fix: rule-form body with repeatable --circle/--group/--email (one rule per call, as bashy suite share does via yoke/pkg/fleet/grant_rule.go), shares lists rule rows, unshare by id; test against yoke/pkg/fleet/cloudboxfake addHostShare. Reproduce first against the fake (expect 400) and record. Accept: fake-server test red then green; outpost apps share APP --circle family creates a rule row and who lists the circle's members; unshare removes it; --json parity. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Re-linked 2026-11-24

Moved from Sprint 639 (closed won't do) to Sprint 703 as a bug (operator rule: every bug still to resolve goes there). Sprint 706 R5 (group shaping grants from the CLI, B3) depends on this fix.

## Moved to Sprint 706 (2026-11-24, operator review)

The R5 MVP case needs it: the owner gives group support access to the app from the CLI with outpost apps share APP --group support, which is the rule form this bug breaks (UI->CLI parity). Order in 706: after R1b, before R5.

## Back to Sprint 703 (2026-11-24, operator)

App sharing already works through the console, so the A/O/C test does not wait on this CLI bug; it stays a 703 bug (UI->CLI parity).

## Moved to Sprint 710 (2026-11-24)

Sprint 710 (owner sharing) is H1. The console path works; this restores CLI parity and feeds the H6 e2e listing check.

## Worker rules (conductor, 2026-11-24, Sprint 710 H1)

- First commit (separate, before the story change): bump outpost's yoke/pkg/llmgw and yoke/pkg/provider pins from 2615421df628 to yoke origin head ac3d38415ece (pin-only: no source changes under those packages in that range), go mod tidy, build + unit tests green. `bashy mod drift` must show outpost in-sync afterwards.
- Start from current origin heads; rebase before submitting. Root cause before any fix: reproduce red first and record the cause in the commit message and on this story.
- Small diff, its own regression tests; run the touched packages' unit tests only (GOWORK=off where the module builds standalone). No e2e, no podman, no full suites on the dev box.
- Commit trailers: Sprint: 710 / Story: <title> / Story-ID: <id> plus your Agent trailer. Public repos: no host names, logins, IPs or home paths.
- Do not deploy, tag or release anything. Submit with `bashy sprint submit` naming the commits and the test command + result.
- Outpost lands on outpost main (push); the conductor bumps the umbrella pin.

## H1 reproduction before the fix

On Outpost's origin baseline with the dependency-only update (7231191), the CLI regression `GOWORK=off go test -tags fb_archives -short ./cmd/outpost -run '^TestAppsShareGrantRule$' -count=1` failed against yoke's cloudboxfake with `cloudbox: bad_request (400): body: json: unknown field "circle"`. S619 changed POST to strict `{app, circles[], groups[], emails[]}`; the CLI still sent `circle` or `email` and decoded singular response fields. Its email-based revoke therefore could not find the new rows. Existing mock tests accepted the obsolete shape.

Outpost delivery refs in weave #257 are on its local `agent/weave-issue-257` branch. Dependency pins: `7231191`. Grant-rule CLI fix: `95250d4`. The conductor takes those commits into Outpost main and updates the umbrella pin.
