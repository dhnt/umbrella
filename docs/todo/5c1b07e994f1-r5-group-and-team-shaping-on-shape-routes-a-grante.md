---
id: 5c1b07e994f1
kind: feature
title: 'R5 Group and team shaping on shape routes: a granted member shapes the owner''s app on the owner''s host with the owner''s LLM, attributed, budgeted, approver-gated'
seq: 712
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:09.233837Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md (workflow 2; team shaping = members shaping the primary owner's app). Absorbs Sprint 640 T1/T8 and Sprint 689 D2's rule; Sprint 706 R8's baseline is step 0.

## MVP (operator, 2026-11-24: KISS; cloudbox sees only owner and members)

To cloudbox and the outpost there are only the host owner and the host owner's members; real-world roles (business owner, office admin, contractor) make no difference.

Case: O owns the host and the member list. A (circle company, group support; no outpost) and C (circle contractor, group support; has an outpost) are O's members. One shaped.json feature audience {groups:[support]} grants shape. O approves.

Change: allowShape in bashy internal/agentos/mcp_site.go and the website template admit a member when the app's feature audience grants shape (the 641 audience grammar; no role table, no lease). Every wish runs on O's host with O's LLM allowance.

Acceptance (unit tests on the gate host, fakes):
0. Baseline: yoke pkg/shape/..., pkg/src/... and bashy agentos shape tests green on current heads, recorded once (ex-R8).
1. A and C each wish through the site MCP or the browser on O's host; O approves; the version records the member as author and O's allowance as the spend, with the member as spender.
2. A member outside group support: the wish demotes to O's request queue. An account stranger and an anonymous visitor: configuration only.
3. Two members change the same feature: the second is refused with both revisions returned.
4. The approved version reaches every open page without a redeploy (R10).
5. No step asks A or C for O's OS password (operator rule 2026-11-24: the owner must not have to share the OS password with members or contractors). A and C come in with their own cloudbox login (browser) or a token (CLI, MCP); shaping is gated by the relationship stamp plus the feature grant, never by OS elevation. The outpost doc says cloudbox stamps `admin` for every sharee who clears elevation on a require_login:true app. If a member can only reach the app by clearing O's host elevation, the test app runs require_login:false (members are still stamped `member` through the satellite) and the elevation dependency is filed as a cloudbox ticket by id.

Split for the before-Christmas real test (operator, 2026-11-24): this story is the member grant (shape_wish, shape_verify, shape_preview admitted for a granted member; shape_approve stays the owner's). C's pull/push is R9 (b15e7074d8ba); open pages picking up an approved version is R10 (3b89e914ed66). Still out: building and verifying a candidate with C's own host resources, and approvers other than the owner.
