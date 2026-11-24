# Handoff for Sprints 706 (access tiers) and 703 (group shaping follow-ups)

Written 2026-11-24 by the agent that ran the access-tier review with the
operator, for whoever conducts either sprint next, from any vendor. Everything
needed is in this repository and on the sprint cards; no private memory is
required. The sprint cards and stories are authoritative; this page is the
map.

## Start here

1. `bashy sprint show 706` and `bashy sprint show 703`: cards, stories, goal
   checklists, threads. Both are **backlog, planning only, unclaimed**.
2. `docs/access-tiers.md`: the model every 706 story implements. Read it
   first; it is short and it settles the vocabulary.
3. `docs/sprint-706-master-execution-plan.md`: stories R1-R8, order,
   dependencies, venues, the R5 defaults, the six sprints closed with the
   filing.
4. `docs/handoff-sprint-684-685.md` and
   `docs/sprint-684-685-master-execution-plan.md`: the origin of 703's
   stories and the pin checks that gate any release cut.
5. **Review with the operator before assigning anything** on either card.
   Neither sprint is authorized to start by this page.

## Sprint 706 in one screen

| Item | Value |
|---|---|
| Title | Access tiers: anonymous, account, owner across cloudbox and bashy |
| UUID | `626dbf6e-b665-5fbc-818b-54aa5c972a8c` |
| Epic | software-shaping |
| Spec | `docs/access-tiers.md` |
| State | backlog, 0 of 8, unclaimed; eight goal items, one per story |

Vocabulary, fixed by the operator on 2026-11-24 (details and reasons in the
spec): three **levels** `anonymous`, `account` (a logged-in cloudbox account
without a live paired host; served by the hosted plane), `owner` (an account
with a host paired with the master; a satellite is a kind of outpost). Four
**relationships** on the outpost stamp `anonymous < account < member <
owner`; the wire value `signed-in` becomes `account`. The word **user** means
the OS user only (`Remote-Groups: admin|user`, elevation). Authorization is
always cloudbox's; public modules consume stamps and grants. Anonymous
visitors configure declared features through the same wish workflow and never
change code. Team shaping is group shaping with contributing owners as members
of the primary owner: one line on the owner's host, the owner's LLM, no team
scope, no driver lease.

| Story | Id | Prio | Depends on |
|---|---|---|---|
| R1 stamp value `account`, one-release alias, shared conformance fixture (outpost, yoke, bashy) | `8ea35b51af54` | p1 | the cloudbox stamp-producer ticket (not filed yet) |
| R2 a logged-in stranger reaches a satellite's public apps as `account` (live, operator-held) | `7c1ad004f53d` | p1 | cloudbox ticket `bc9c36080649` (admission rung) |
| R3 vocabulary sweep across docs and kb | `d346682b1f23` | p2 | R1 |
| R4 stale Status lines on plan docs 615, 638, 641, 691, 697 | `665cf4339efd` | p3 | none |
| R5 group and team shaping on shape routes: a granted member shapes the owner's app on the owner's host with the owner's LLM | `5c1b07e994f1` | p1 | R1, R8; 703 S14 for CLI grants |
| R6 common personalization wishes for public visitors in `website.bsh enable` | `e36a293f92ca` | p1 | none |
| R7 consented access request: the path from `account` to `member` | `c354035db89e` | p2 | R2; a cloudbox ticket (not filed yet) |
| R8 shaping evidence baseline on current heads, before R5 | `d8b7f10afa31` | p2 | none |

Suggested order: R8 and R1, then R4 and R6 any time, R3 after R1, R5 after R1
and R8, R2 when the cloudbox ticket lands, R7 after R2.

**Decisions the operator still has to confirm (on the card thread, before R5
is assigned):** grant per app feature by audience with no per-member role
table; approvers are the owner plus named maintainers; no driver lease
(sequential revisions, conflicts refused with both revisions, rebase and
re-verify before approval).

**Open items:** the cloudbox tickets for R1's stamp producer and R7's hosted
half are not filed; record their ids on the stories when they exist. Cloudbox
is private: name tickets by id, never quote their contents here.

## Sprint 703 in one screen

| Item | Value |
|---|---|
| Title | Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps |
| UUID | `21bfcc03-ecb2-50e9-84ae-d33c01f54b40` |
| Epic | Software shaping for group participation |
| Spec | `docs/sprint-684-685-master-execution-plan.md` |
| State | backlog, 0 of 21, unclaimed; the stories are not yet covered by goal items |

It is the collecting card for every bug or issue still to resolve (operator
rule, 2026-11-24). Stories by priority:

| Prio | Id | Story |
|---|---|---|
| p0 | `c901b0309f31` | F0 pins at heads: clear the stale pins left when 684/685 closed. **Gates the release train**; do it first and alone |
| p1 | `08ee6df70b5d` | pass the adapter cache location to the ycode knowledge-base command. **Needs an operator ruling on what the kb command may receive before any code** |
| p1 | `60b4624b22f9` | F4 lift the revision wiring into the desk kit's shared handler |
| p1 | `90f03f54c150` | D4 root-cause: offer refuses a released version (from 689) |
| p1 | `ef2ce499a64a` | S14 outpost `apps share|unshare|shares` still send the pre-Sprint-619 body (from 639); **706 R5 depends on it** |
| p2 | `32b3fdc1bcea` | D5 root-cause: flaky shaping draft DOM tests (from 689) |
| p2 | `d246ca4e518e` | F11 gate host: the installed bashy predates the local module proxy |
| p2 | `5469f847be3f` | F5 three ycode timing and terminal tests fail when the gate host is busy |
| p2 | `de2aa2298503` | F6 the board must publish story status and assignee to origin |
| p2 | `255b1585220c` | F7 the fleet probe reports an agent usable when its vendor quota is exhausted |
| p2 | `6fb0e96d8fcf` | F9 viewer: CLI cannot find a standalone server; close-out template cannot read the card |
| p2 | `790d4c29d660` | Session demo fixtures must reap descendants when a readiness assertion fails |
| p2 | `bf5c8c71f65e` | bashy/yoke/fetch TestStandaloneHelpAndDeps fails on the gate host (pre-existing) |
| p2 | `5771d343ce2a` | weave start --resume spins without spawning the worker |
| p3 | `9218c88aaf16`, `794b3caebb10`, `ee6d78c062f0`, `cb9b4b80a88d`, `ba8f2b5cb347`, `2f6d27f53940`, `78bc2bb3f32b` | F10 sprint comment author, F12 bashy ps columns, F8 shared agent name, brainstorm as shaped app, storyboards without history, table Linux-only exception, whiteboard write gate |

Rules carried from 684/685: each story closes on its own unit tests on the
gate host with a recorded root cause where it fixes a failure; no judge pass;
no integration runs (Sprint 699 owns those); no release. Root cause before any
fix (`CLAUDE.md`, "Root cause before any fix").

## What was closed on 2026-11-24, and where its pieces went

| Sprint | Disposition | Carried to |
|---|---|---|
| 639 trove content space | won't do: the account tier is served by Sprint 691 H6/H6b | S14 bug to 703 |
| 640 team shaping (stories in the private dhnt-docs store) | superseded by 706: team shaping is the primary-owner workflow | T1/T8 designs as 706 R5 acceptance |
| 667 provable relays | won't do: the group model carries provenance for shaping | nothing; agent governance refiled if wanted |
| 669 software shaping MVP (private cloudbox store) | won't do: replaced by the model | admission rung as cloudbox ticket `bc9c36080649`; consented access request as 706 R7 |
| 679 One Agent hub | won't do: routing is covered by the group model as implemented | nothing |
| 689 shaping sync across devices | won't do: one owner shapes the app's host remotely | D4/D5 to 703; D6 as 706 R8 |

Sprint 691 (hosted bashy) had framed member-level use of invited apps and
deferred it; 706 R5 closes that framing.

## Mechanics worth knowing

- Commits in this repo carry provenance trailers; the hook is fail-closed.
  Delivery: `Sprint: #N` + `Story:` + `Story-ID:`. Planning or housekeeping:
  one block `Adhoc: <reason>` and `Agent: <registered name>` as the last
  lines. Stage by pathspec; other agents share the checkout.
- Closing a backlog sprint (the recipe used above): set each story to
  `wontfix` with an appended dated reason, commit, `bashy sprint goal rm N
  <item> --override --reason`, `bashy sprint edit N --title "Won't do: ..."
  --override --reason`, `bashy sprint move N done --override --reason`. The
  move refuses while story edits are uncommitted.
- `bashy todo` has no `--plain`. `bashy sprint goal add N --id X --text "..."
  --story ID` covers a story in one step. `bashy todo edit ID --title`
  renames the file: stage the old path too.
- Heavy tests run on the gate host, never the dev box
  (`docs/handoff-sprint-684-685.md`, gate venue). Hosts by role only; this
  repository is public.
