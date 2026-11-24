---
id: 5c1b07e994f1
kind: feature
title: 'R5a Shaping scope core (yoke): scopes in shaped.json, member candidates on the owner''s line, out-of-scope wish to the owner''s queue'
seq: 712
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:09.233837Z
assignee: agy-gemini4-carbon
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T21:56:45.351421Z
closed_by: claude-opus5.5
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

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- bashy internal/agentos/mcp_site.go: allowShape (146-154) admits owner only; siteCaller (60) keeps Principal and Tier and drops the stamp's Circle and Groups (caller 71-116). s.shape passes the caller as --user (542) into executeShapeCLI (shape_local.go:55, Caller at 93).
- yoke pkg/shape: web-app activation is PER PRINCIPAL (program.go:38-43 ActivationPrincipal; state per app+principal, state/store.go:40; candidates and locks per principal, service.go:160-176). A member's wish today would make the member's own version, not a revision on O's line. New: a scoped member's candidate activates on the owner's line, with Principal = the member (author).
- Conflict: Approve already refuses with ErrConflict when active != BaseRev (service.go:574-575); it does not return both revisions. Small addition: name both revisions in the refusal.
- Spend/allowance for shaping: none in shape, webconsole or agentos. MVP records who (Candidate.Principal/Actor, tracking.go:174); separate spend accounting is out.
- Request queue: fileRequest (webconsole/shaped_candidate.go:372) writes to the WISHER's own candidate dir, triggered only by a Protected page (727); listed only for that principal (669-697). New: an out-of-scope wish files a request on the owner's queue.
- shaped.json: appserver.Manifest (appserver/manifest.go:51-65) uses DisallowUnknownFields (175-184); a scopes key must be added to the struct (yoke release, then consumer pins). No features/levels/audiences/scopes exist today.
- Audience grammar to reuse: website template audience.go:15-52 (Circles, Groups, Emails); the template verifies stamps itself (identity.go:49-97, no coopauth).
- Member browser route: requests through outpost carry the member stamp; the site MCP is proxied at <mount>/mcp (outpost internal/agent/site_mcp.go:34-51). There is no member shaping UI today: the template's shape link is owner-only (main.go:195,203,236), and console pairing (yoke webconsole/pair_cmd.go) is an owner-device LAN ticket with operator authority, not a member route.

## Split 2026-11-24 after code inspection (operator: e2e in the sandbox with fakes is the sprint acceptance)

This story is now R5a, the yoke core (the A/O/C case and the scope model above still hold):
- appserver.Manifest gains `scopes` ({edit|shape: {circles, groups, emails}}), validated; unknown scope names refused (DisallowUnknownFields stays).
- A candidate whose Principal is a scoped member activates on the owner's line (ActivationPrincipal = the owner) with Principal/RepresentedUser = the member as author; per-person versions are unchanged for everyone else.
- An out-of-scope wish files a request on the OWNER's queue (fileRequest today writes to the wisher's own dir).
- Approve's ErrConflict names the active and base revisions.
- Baseline first (ex-R8): yoke pkg/shape/..., pkg/src/..., webconsole shaped tests green on current heads, recorded.
Acceptance: unit tests in yoke on the gate host. Siblings: R5b cb70d339abff (site MCP + owner verb), R5c aad949e099ef (panel wish box), R10 3b89e914ed66, e2e R11 135b09cbd685.
