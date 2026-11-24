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

## MVP (operator, 2026-11-24: KISS; sharing exists, the shaping scope is new)

To cloudbox and the outpost there are only the host owner and the owner's members. Sharing an app with a member already works (cloudbox grant, the console; who can reach the app = view). What is new is the shaping scope on top of that share. Nothing implements it today: Sprint 638 S6 (701ee51247b9) designed per-audience levels but was superseded and never built.

Case: O hosts the app and owns the member list. A (circle company, group support; no outpost) and C (circle contractor, group support; has an outpost) are O's members, and the app is shared with group support. O sets scopes: A edit, C shape. O approves.

Scopes (owner-defined, stored in the app's shaped.json on O's host, using the existing audience grammar of circles, groups and emails; identity and membership stay cloudbox's):
- view: the existing share; nothing new.
- edit: change content and declared settings, saved as revisions with the author.
- shape: wish, verify and preview code changes, plus pull/push (R9).
Approve stays the owner's for every scope. A wish beyond the caller's scope demotes to a request on the owner's queue. Access is by cloudbox login or token, never an OS password.

Change:
- Owner verb (CLI parity with any UI): `bashy shape scope ls|set|rm --app APP edit|shape --group G|--circle C|--email E --json`; owner only; writes shaped.json; an unknown scope is refused.
- Enforcement in one place per surface: `allowShape` in bashy internal/agentos/mcp_site.go and the website template check the caller's verified member stamp (circle, groups) against the app's scopes; no other role table, no lease.

Acceptance (unit tests on the gate host, fakes):
0. Baseline: yoke pkg/shape/..., pkg/src/... and bashy agentos shape tests green on current heads, recorded once (ex-R8).
1. With A at edit and C at shape: C wishes, verifies and previews a code change; O approves; the version records C as author and O's allowance as the spend. A's content edit lands as a revision authored by A. A's code wish demotes to a request.
2. A member of the share without a scope can view only; an account stranger and an anonymous visitor get configuration only; neither can set scopes.
3. Two members change the same item: the second is refused with both revisions returned.
4. The approved version reaches every open page without a redeploy (R10).
5. No step asks A or C for O's OS password.

Out: a scope field on the cloudbox grant rule itself (cleaner long term, a private cloudbox ticket; follow-up only); approvers other than the owner; building a candidate with C's own host resources.
