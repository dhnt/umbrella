---
id: cb70d339abff
kind: feature
title: R5b Site MCP shaping scope for members and the bashy shape scope owner verb
seq: 725
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T21:09:07.511626Z
assignee: codex-gpt6-astra
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T22:10:56.884256Z
closed_by: claude-opus5.5
---

Part of R5 (5c1b07e994f1, the shaping scope; read its Code inspected notes first). bashy only.
- internal/agentos/mcp_site.go: siteCaller keeps the stamp's Circle and Groups (today dropped, 60/71-116). allowShape (146-154) admits a member whose caller matches the app's `shape` scope for shape_wish, shape_verify, shape_preview; shape_approve and shape_undo stay owner-only. A member without the scope who calls shape_wish gets the wish filed as a request on the owner's queue (R5a), not a bare refusal.
- Owner verb: `bashy shape scope ls|set|rm --app APP edit|shape [--circle C] [--group G] [--email E] --json`, owner only, edits the app's shaped.json through the R5a struct; unknown scope refused.
Depends on R5a (yoke version + bashy pin). Acceptance: unit tests in internal/agentos with the existing stubs (mcp_site_test.go:150-160): owner, member with shape, member with edit only, member without scope, account, anonymous; verb ls/set/rm with --json.
