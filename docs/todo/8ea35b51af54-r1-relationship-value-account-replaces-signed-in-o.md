---
id: 8ea35b51af54
kind: feature
title: R1 Relationship value account replaces signed-in on the outpost stamp, with a one-release alias and a shared conformance fixture
seq: 708
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:07.917533Z
assignee: agy-gemini4-neon
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T21:53:02.799Z
closed_by: claude-opus5.5
---

Spec: docs/access-tiers.md (operator decisions 2026-11-24: 'user' is the OS user; the logged-in cloudbox account holder is 'account'). Public modules: outpost internal/agent/grants.go RelSignedIn -> RelAccount with wire value account; apps.go stamp; outpost/docs/cooperative-web-apps.md; yoke pkg/coopauth accepts account and signed-in (alias, logged) for one release window; bashy internal/agentos/mcp_site.go tier consts; examples/shaping/website/template identity.go and audience.go (the signed_in audience keeps working as an alias of account); examples/desk/kit/identity.go. One fixture of signed v2 stamps (owner, member, account, anonymous, forged, stale) run by the outpost, yoke and bashy tests so all consumers derive the same relationship. Document that Remote-Groups: admin|user and X-Periscope-Role are OS elevation, never the relationship. The cloudbox stamp producer is a private ticket by id (recorded here when filed). Acceptance: unit tests per repo on the gate host; no behavior change for owner, member or anonymous; alias path covered by a test.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

No cloudbox ticket: the outpost derives the stamp itself from its held grant copies (outpost internal/agent/grants.go Relationship; apps.go), so cloudbox never carries the word. The cross-repo shared conformance fixture is dropped; per-repo tests including the alias path suffice. Two ordered steps: R1a consumers accept account and keep signed-in as a logged alias (yoke pkg/coopauth, bashy internal/agentos/mcp_site.go, website template identity/audience with the signed_in audience aliasing account, desk kit identity); consumer pins bump; then R1b the outpost produces account (RelSignedIn -> RelAccount) plus the wire doc and the OS-elevation note. The alias is removed no earlier than one release after R1b ships.

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- Producer: outpost grants.go:196 (RelSignedIn), :218/:248, apps.go:665 and wire at :703/:724; HMAC covers the kind string (coopauth.go:281, apps.go:262-264) but whatever is sent is signed, so only the consumers' allow-lists matter.
- Consumers: yoke coopauth.go:261 (allow-list); bashy mcp_site.go:38/108/111; the website template and the desk kit do NOT use coopauth (template identity.go:18/85-93, audience.go:19/121 signed_in key; kit identity.go:91-93) so each changes directly; shaping.js:119 tierText; site.json:20 and website.bsh:47/195 (also the adapterembed copy) for the signed_in audience key (a config spelling, aliased separately).
- Pins: outpost yoke v0.0.0-20261124123053-25ec97b56fde; bashy yoke v0.0.0-20261124150948-f6139e6f1237; template has no yoke dep; desk notepad/page pin kit v0.3.0 (a new kit tag is needed).
- Old consumers drop an unknown kind to anonymous (coopauth.go:261; template identity.go:90; kit identity.go:91), so R1b ships only after every consumer carries the alias.
- Tests to update: outpost relationship_test.go:31/39/135; coopauth_test.go:121; mcp_site_test.go:224/227; template main_test.go:26/66/115/180; kit revision_test.go:262/288; notepad revision_test.go:76/129.
