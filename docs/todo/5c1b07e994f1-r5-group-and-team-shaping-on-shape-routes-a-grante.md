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

Spec: docs/access-tiers.md (shaping workflows 2 and 3 are one workflow; team shaping = contributing owners as members of the primary owner). Closes what Sprint 691 framed (member-level use of invited apps) and deferred. Absorbs the designs of Sprint 640 T1 (owner/member authority on shape routes, owner-visible request queue) and T8 (candidates per requester, rebase and re-verify before approval, approvers = owner plus named maintainers, conflicts surfaced never merged silently), both retired by supersession; and Sprint 689 D2's rebase rule. Venue = the owner's host; spend = the owner's allowance, recorded with who spent it; revision author = the member. allowShape in bashy internal/agentos/mcp_site.go and the website template admits member when the app's feature grants it (641 shapeable audience grammar, the one grant model); a wish beyond the grant demotes to the owner's request queue, never a dead end. Defaults adopted (operator may overrule at review): grant per feature by audience, no per-member role table; approvers owner + named maintainers; no driver lease. No team scope, no second role model. Depends on R1 and on cloudbox grants and admission as they exist. Acceptance: one fixture with owner, granted member, granted member who owns a host, ungranted member, account, anonymous against one app; granted candidates land on the owner's line with author and spend recorded after approval; the ungranted wish becomes a request; a conflicting candidate is refused with both revisions; the owner on a second device shapes the app on its host through the gateway or the site MCP with the same path and evidence as a granted member. Unit tests on the gate host; integration as a Sprint 699-style story later.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Step 0 = the R8 baseline (d8b7f10afa31): targeted unit tests yoke pkg/shape/..., pkg/src/... and bashy internal/agentos shape tests on the gate host, one evidence record. Acceptance fixture trimmed to five callers against one app: owner, granted member, ungranted member, account, anonymous. A member who owns a host and the owner on a second device take the granted-member path; assert that in one line, no extra fixtures. Tests grant through shaped.json feature audiences directly, so Sprint 703 S14 (ef2ce499a64a) gates only CLI grants, not this story's unit work. Reuse the Sprint 684 kit revision store for author, conflict refusal and both-revisions return. Operator to confirm the three defaults before assignment.

## Minimum acceptance case (operator, 2026-11-24): small business with a contractor

Three people in one group (support) across two circles (company: O and A; contractor: C), one app, one line on O's host. O is the primary owner (the host owner) and sits in company / support like A; as host owner O passes every audience regardless, so the listing is for the record, not for access.

| Who | Level | Relationship to O | Circle / group | How they shape |
|---|---|---|---|---|
| O, office manager/admin | owner (O's outpost hosts the app) | owner | company / support (same as A) | shapes locally; the only approver |
| A, business owner | account (no outpost) | member | company / support | browser or site MCP on O's host, the member path (workflow 2) |
| C, contractor | owner (C's own outpost) | member | contractor / support | builds and verifies a candidate on C's host, pushes it to O, pulls O's line back (workflow 3) |

Grant: one shaped.json feature audience {groups:[support]} grants shape to A and C; approvers = O. Negatives in the same fixture: a member of O outside group support (wish demotes to O's request queue), an account stranger and an anonymous visitor (configuration only).

Steps the test proves:
1. A wishes on O's host; the candidate runs on O's host with O's LLM allowance; spend is recorded against O with A as spender; O approves; the version has author A.
2. C pulls O's current line, shapes and verifies on C's host, then pushes the candidate to O; O sees it as incoming, it is rebased onto O's current line and re-verified on O's host, O approves; author C.
3. A and C change the same feature concurrently: the second is refused with both revisions returned, never merged silently.
4. Every viewer (A, C, O) sees the approved version without a manual redeploy, as fast as verify and approve allow.
