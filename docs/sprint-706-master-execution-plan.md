# Sprint 706: access tiers across cloudbox and bashy

Sprint UUID: `626dbf6e-b665-5fbc-818b-54aa5c972a8c`. Epic: software-shaping.
Status: **backlog, planning only**, filed 2026-11-24 from the access-tier
review with the operator. Review with the operator before any assignment.
The model itself is `docs/access-tiers.md`; this page lists the stories, their
dependencies and venues, and the sprints closed with the filing.

## Why

The three support levels (visitor, cloudbox account, owner with a host) were
stated once, in the Sprint 691 plan, while the stacks used several ladders:
journey rungs, "four visitor tiers" (615), CMS roles (641), and the four-value
outpost stamp. The operator settled one model on 2026-11-24 (three levels,
four relationships, `account` for the logged-in stranger, `user` for the OS
user, cloudbox as the only authority, team shaping as group shaping with
owners as members). This sprint files the gaps that model exposes and
consolidates the stories kept from the sprints it retires.

## Stories

| # | Story | Kind / prio | Repos | Depends on |
|---|---|---|---|---|
| R1 `8ea35b51af54` | stamp value `account` replaces `signed-in`, one-release alias, shared conformance fixture | feature p1 | outpost, yoke, bashy; cloudbox producer by ticket (not yet filed) | — |
| R2 `7c1ad004f53d` | a logged-in stranger reaches a satellite's public apps as `account` | test p1 | cloudbox (private), outpost, bashy | cloudbox ticket `bc9c36080649` (admission rung) |
| R3 `d346682b1f23` | vocabulary sweep: docs and kb; "user" only for the OS user | doc p2 | umbrella, bashy kb defaults | R1 |
| R4 `665cf4339efd` | stale Status lines on plan docs 615, 638, 641, 691, 697 | chore p3 | umbrella | — |
| R5 `5c1b07e994f1` | group and team shaping on shape routes: a granted member shapes the owner's app on the owner's host with the owner's LLM, attributed, budgeted, approver-gated | feature p1 | bashy, yoke, outpost | R1, R8; cloudbox grants and admission as they exist; Sprint 703 S14 for CLI grants |
| R6 `e36a293f92ca` | common personalization wishes for public visitors (from 615 S21) | feature p1 | bashy | — |
| R7 `c354035db89e` | consented access request: the path from `account` to `member` (from 665 / 669) | feature p2 | bashy template; cloudbox by ticket (not yet filed) | R2 |
| R8 `d8b7f10afa31` | shaping evidence baseline on current heads before R5 (from 689 D6) | test p2 | yoke, bashy | — |

Order: R8 and R1 first (baseline, then the word), R4 and R6 any time, R3 after
R1, R5 after R1 and R8, R2 when the cloudbox ticket lands, R7 after R2.

## R5 defaults (operator to confirm at review)

1. The owner grants shape per app feature through the Sprint 641 `features`
   audience grammar; no per-member role table.
2. Approvers are the owner plus named maintainers, for members and
   contributing owners alike.
3. No driver lease: sequential revisions, conflicts refused with both
   revisions returned (Sprint 684 rule); a candidate is rebased and
   re-verified before approval (the Sprint 640 T8 rule).

## Venues

Unit tests per repo on the gate host, never the dev box (R1, R5, R6, R8). R2's
live step on a satellite-attached outpost is operator-held; hosts by role.
Integration runs are not this sprint's; they are filed as release-train
stories when the time comes. No release.

## Closed with this filing (operator decisions 2026-11-24)

| Sprint | Why | What was kept |
|---|---|---|
| 639 trove content space | the account tier is served by Sprint 691 H6/H6b | S14 share-wire bug to Sprint 703 |
| 640 team shaping | team shaping is the primary-owner workflow; no team scope | T1 and T8 designs as R5 acceptance lines |
| 667 provable relays | the group model carries provenance for shaping | nothing; agent governance refiled if wanted |
| 669 software shaping MVP (private) | replaced by the model | admission rung as cloudbox ticket `bc9c36080649`; consented access request as R7 |
| 679 One Agent hub | routing is covered by the group model as implemented | nothing |
| 689 shaping sync across devices | one owner shapes the app's host remotely; no per-device line | D4/D5 bugs to Sprint 703; D6 as R8; D2's rebase rule in R5 |

Sprints 615, 638, 641 and 665 were already done; R3 and R4 fix their plan
headers. Sprint 691 is ended; R5 closes what its framing left open.

## Not doing

A fourth "plane owner" level; anonymous quota'd code shaping; any
authorization logic in a public module; a `team` scope or a driver lease; the
hosted route live test (Sprint 699 T1); identity assurance levels (design
todo `0d657f972c91`).

## Open items

The cloudbox stamp-producer ticket for R1 and the cloudbox half of R7 are not
filed yet; record their ids on the stories when they are.
