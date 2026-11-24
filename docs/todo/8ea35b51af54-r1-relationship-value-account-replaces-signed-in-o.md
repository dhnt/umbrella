---
id: 8ea35b51af54
kind: feature
title: R1 Relationship value account replaces signed-in on the outpost stamp, with a one-release alias and a shared conformance fixture
seq: 708
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:07.917533Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md (operator decisions 2026-11-24: 'user' is the OS user; the logged-in cloudbox account holder is 'account'). Public modules: outpost internal/agent/grants.go RelSignedIn -> RelAccount with wire value account; apps.go stamp; outpost/docs/cooperative-web-apps.md; yoke pkg/coopauth accepts account and signed-in (alias, logged) for one release window; bashy internal/agentos/mcp_site.go tier consts; examples/shaping/website/template identity.go and audience.go (the signed_in audience keeps working as an alias of account); examples/desk/kit/identity.go. One fixture of signed v2 stamps (owner, member, account, anonymous, forged, stale) run by the outpost, yoke and bashy tests so all consumers derive the same relationship. Document that Remote-Groups: admin|user and X-Periscope-Role are OS elevation, never the relationship. The cloudbox stamp producer is a private ticket by id (recorded here when filed). Acceptance: unit tests per repo on the gate host; no behavior change for owner, member or anonymous; alias path covered by a test.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

No cloudbox ticket: the outpost derives the stamp itself from its held grant copies (outpost internal/agent/grants.go Relationship; apps.go), so cloudbox never carries the word. The cross-repo shared conformance fixture is dropped; per-repo tests including the alias path suffice. Two ordered steps: R1a consumers accept account and keep signed-in as a logged alias (yoke pkg/coopauth, bashy internal/agentos/mcp_site.go, website template identity/audience with the signed_in audience aliasing account, desk kit identity); consumer pins bump; then R1b the outpost produces account (RelSignedIn -> RelAccount) plus the wire doc and the OS-elevation note. The alias is removed no earlier than one release after R1b ships.
