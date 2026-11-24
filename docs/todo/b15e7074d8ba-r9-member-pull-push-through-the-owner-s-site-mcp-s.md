---
id: b15e7074d8ba
kind: feature
title: 'R9 Member pull/push through the owner''s site MCP: shape_pull and shape_push for a granted member'
seq: 723
status: blocked
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T20:46:03.189825Z
due: 2026-12-09T00:00:00Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Part of the A/O/C case on R5 (5c1b07e994f1): C, a member with an outpost, pulls O's line, changes it on C's own machine with C's own tools, and pushes the change back; O approves. KISS: no new transport and no cloudbox change. Two tools are added to the site MCP that O's host already serves through O's outpost (bashy internal/agentos/mcp_site.go), gated by the same member grant as R5:
- shape_pull: returns the app's active source (an archive) and its revision id.
- shape_push: takes a patch and its base revision; refused with both revisions when the base is not the current line; otherwise imported as a candidate (the existing shape wish --from path) and verified on O's host. The owner approves through the existing shape_approve.
Step 0 (day 1, record the result here): confirm that an MCP client on C's machine reaches O's site MCP through the satellite as a member with a token (C's cloudbox token or an app-scoped member token issued through cloudbox). Operator rule 2026-11-24: app access always uses tokens, never an OS password, so the outbound connect path (remote OS password elevation) is not used. If it cannot, stop and report; C falls back to the browser path that A uses, and the gap is filed with its cause.
Acceptance (unit tests on the gate host, fakes): pull returns source plus revision; push on the current base yields a verified candidate authored by C; push on a stale base is refused with both revisions; a member without the grant, an account and an anonymous caller are refused both tools.

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- Member token: NOT FOUND. The site MCP under require_login needs a cloudbox hop (outpost apps.go:1194-1205), else 401 with Bearer resource metadata naming the site as its own authorization server (site_mcp.go:78-92), and no OAuth authorization/token endpoint exists anywhere in outpost, yoke or bashy. The expose token (apps.go:159-189) carries no identity (treated as anonymous); the outpost MCP bearer is the host owner's admin token (conf/file.go:285-293); shape --remote uses an owner-paired console cookie (shape_remote.go:28-65). OS-password routes (outbound connect/login, outpost connect) are excluded by the operator rule.
- So C's CLI/MCP client cannot reach O's site MCP as a member today. It needs a member token issued by cloudbox (the identity authority): a private cloudbox ticket. Until then C shapes in the browser like A (R5).
- wish --from accepts a directory only (helpers.go:367 CopyWorkspace), local only (shape_remote.go:129-132,163). No archive/bundle export of a shaped app exists; nearest: Diff (helpers.go:299), src.ExportPatch (yoke pkg/src/patch.go:17), CloneAt (helpers.go:120).

## Blocked 2026-11-24

Needs a member token issued by cloudbox (none exists; see Code inspected). For the A/O/C test C shapes in the browser like A (R5c). Unblocks when the cloudbox member-token ticket lands; record its id here.
