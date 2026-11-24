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
