---
id: b15e7074d8ba
kind: feature
title: 'R9 Member pull/push through the owner''s site MCP: shape_pull and shape_push for a granted member'
seq: 723
status: todo
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
Step 0 (day 1, record the result here): confirm that an MCP client on C's machine reaches O's site MCP through the satellite as a member with C's cloudbox login. If it cannot, stop and report; C falls back to the browser path that A uses, and the gap is filed with its cause.
Acceptance (unit tests on the gate host, fakes): pull returns source plus revision; push on the current base yields a verified candidate authored by C; push on a stale base is refused with both revisions; a member without the grant, an account and an anonymous caller are refused both tools.
