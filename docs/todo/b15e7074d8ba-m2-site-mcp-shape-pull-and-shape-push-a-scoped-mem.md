---
id: b15e7074d8ba
kind: feature
title: 'M2 Site MCP shape_pull and shape_push: a scoped member pulls the owner''s line and pushes a patch'
seq: 723
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T20:46:03.189825Z
due: 2026-12-09T00:00:00Z
assignee: codex-gpt6.2-astra
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
closed: 2026-11-24T23:19:10.583591Z
closed_by: claude-opus5.5
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

## Moved to the backlog at the close of Sprint 706 (2026-11-24)

Still blocked: no member token exists (cloudbox would issue it; no ticket filed yet). For the A/O/C test C shapes in the browser through the panel wish box (R5c). Re-plan when a cloudbox member-token ticket exists.

## Unblocked and replanned 2026-11-24 as Sprint 709 M2 (operator: must be supported)

No cloudbox ticket is needed. Access is the owner's (share per app + the Sprint 706 scopes); cloudbox only proves identity, and its satellite app route already accepts a member's exchanged host:proxy bearer and forwards X-Periscope-User like the browser (see M1 9a05b486f0b3). This story is the shaping half:
- shape_pull (site MCP, shape scope): returns the app's active source on the OWNER's line (a tar or a file list with contents, size-capped) and its revision id. Use go-git CloneAt / tree walk (yoke pkg/shape helpers.go CloneAt ~120); no new export format beyond what the MCP result needs.
- shape_push (site MCP, shape scope): takes a unified diff and the base revision. Refused with ErrConflict naming base and active when base != the owner's active revision (the R5a rule). Otherwise the patch is applied to CloneAt(base) in a candidate workspace and committed as a candidate (extend Import, service.go ~435, to accept a patch; CopyWorkspace stays directory-only), Principal = the member, ActivationPrincipal = the owner, then verified on the owner's host. shape_approve stays the owner's.
- A member without the shape scope, an account and an anonymous caller are refused both tools; nothing is written for them.
Acceptance: yoke unit tests (patch import, stale base refusal, scope refusal) and bashy site MCP tests with the existing stubs; gate host only. E2E is M3.

## Step 0 and M2 delivery, 2026-11-24

M1's route inspection confirms that C can present the exchanged `host:proxy`
bearer to the satellite for an app O shared with C. O's outpost checks the
app grant and forwards the signed member identity and audience to the same
`/mcp` endpoint used by the browser. M2 exercised that signed request over
Streamable HTTP with fixture identities on the gate host. The client token
exchange is covered by M1. The cross-machine acceptance run belongs to M3.

`shape_pull` returns `result.revision` and `result.files` from O's committed
tree. Each file has a path, Git mode and base64 content. Source and patch
transfers have an 8 MiB limit. `shape_push` takes `base_revision` and a
unified text diff in `patch`. A successful result includes the verified
candidate ID, C as principal and O as activation principal. O can pass that
ID to `shape_approve`. A stale push reports the submitted and active
revisions before creating a candidate.

Gate evidence for Yoke `4ee516f5` and Bashy `1b3d428e`: 66 top-level
`pkg/shape` tests and 12 focused `internal/agentos` tests passed with
`GOWORK=off`, the committed module pin and `-count=1`. The site template
suite and vet for both affected packages passed. The signed HTTP test
checked the pulled file bytes, verified candidate attribution, owner-side
verifier and stale refusal. The scope matrix checked that denied calls
never reached the executor. The lifecycle test checked the active revision
before and after owner approval.
