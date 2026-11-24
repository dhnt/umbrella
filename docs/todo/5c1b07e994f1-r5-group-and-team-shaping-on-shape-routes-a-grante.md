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
4. The approved version is what everyone gets on the next page load; no redeploy.

Not in the MVP (follow-ups, file only when asked): C building and verifying on C's own host and pushing to O (shape push/pull needs a member-authenticated remote on O's outpost); live push of a new version to open pages; named maintainers other than the owner.
