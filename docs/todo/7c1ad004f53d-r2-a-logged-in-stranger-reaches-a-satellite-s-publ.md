---
id: 7c1ad004f53d
kind: test
title: R2 A logged-in stranger reaches a satellite's public apps as account (pseudonymous, never a member)
seq: 709
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:08.250631Z
---

Spec: docs/access-tiers.md invariant 4. Today the satellite admits mutual members only, so a logged-in non-member is anonymous on the engine face and the account tier cannot be shown (Sprint 615 S14 open step; Sprint 665 bc71a4d7a34a, retired). Depends on the cloudbox admission rung (owner-chosen, public wire contract only; private ticket id recorded here when filed; carried out of Sprint 669 M1). Public side already exists: outpost pseudonym stamp (615 S10), yoke verify (615 S15), site MCP refuses non-owner shape by tier (697 A3). Acceptance (live, operator-held, hosts by role): a logged-in stranger is admitted to a require_login=false app on a satellite-attached outpost as a pseudonym, sees the account audience views only, acquires no member grant, no email appears in any log or header; bashy mcp serve --tools site --outpost agrees on the tier; 'an account does not become a member' test green. Never quote hosted internals.

Dependency recorded 2026-11-24: cloudbox ticket bc9c36080649 (satellite admission rung), carried out of Sprint 669 M1.

## Rescoped 2026-11-24 (KISS/MVP review, operator-approved plan)

Stays on the card as blocked: cannot start until cloudbox ticket bc9c36080649 lands. Not part of the active MVP.

## Moved to the backlog at the close of Sprint 706 (2026-11-24)

Still blocked on cloudbox ticket bc9c36080649 (satellite admission rung). Sprint 706 closed on its A/O/C acceptance; this story is not done and is not reported as done. Re-plan when the ticket lands.

## Shelved 2026-11-24 (operator)

Shelved for now over privacy concerns: admitting a logged-in non-member through a satellite means cloudbox vouches for a stranger to a satellite operator it does not control. The per-app pseudonym keeps the email from the app owner, but a rogue satellite owner would still see all traffic through the satellite and could recognize, track or correlate logged-in visitors across apps without their choosing that relationship. Needs a privacy design review (what a satellite may learn, retention, consent) before any work; not blocked on code. Cloudbox ticket bc9c36080649 is unaffected.
