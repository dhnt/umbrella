---
id: 7c1ad004f53d
kind: test
title: R2 A logged-in stranger reaches a satellite's public apps as account (pseudonymous, never a member)
seq: 709
status: blocked
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:08.250631Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md invariant 4. Today the satellite admits mutual members only, so a logged-in non-member is anonymous on the engine face and the account tier cannot be shown (Sprint 615 S14 open step; Sprint 665 bc71a4d7a34a, retired). Depends on the cloudbox admission rung (owner-chosen, public wire contract only; private ticket id recorded here when filed; carried out of Sprint 669 M1). Public side already exists: outpost pseudonym stamp (615 S10), yoke verify (615 S15), site MCP refuses non-owner shape by tier (697 A3). Acceptance (live, operator-held, hosts by role): a logged-in stranger is admitted to a require_login=false app on a satellite-attached outpost as a pseudonym, sees the account audience views only, acquires no member grant, no email appears in any log or header; bashy mcp serve --tools site --outpost agrees on the tier; 'an account does not become a member' test green. Never quote hosted internals.

Dependency recorded 2026-11-24: cloudbox ticket bc9c36080649 (satellite admission rung), carried out of Sprint 669 M1.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Stays on the card as blocked: cannot start until cloudbox ticket bc9c36080649 lands. Not part of the active MVP.
