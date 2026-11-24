# Sprint 683: owner/producer shaping of the example apps (plan)

Rescoped 2026-11-24 at the operator's review. The card and its stories are
authoritative; this page is the map. Planning only until assigned.

## Finding: the owner side is platform, not per-app work

The owner/producer verbs already exist for every app registered
`--type shaped`, with no app-specific wiring:

- `bashy shape release | offer [--to|--all] | adopt [--preview] | submit`
  (`bashy/internal/agentos/shape.go`), backed by `yoke/pkg/src/release.go`,
  `offer.go` (with tests) and `yoke/pkg/shape/submit.go`.
- Sixteen example apps carry `shaped.json` and a shaped registration
  (desk form, notepad, viewer, chart, page; session, calendar, clip,
  demo-queue, notes, site/chat, board, whiteboard, table; the shaping site and
  website templates).
- The website tiers are shipped (`docs/shaping-enable-a-website.md`,
  `bashy/examples/shaping/website/`).
- The Sprint 682 build blocker (todo `d35e0de8`, sibling `replace` lines) is
  fixed on bashy main by `56b5b1a1` (kit and chart are published modules) and
  `6a10293f`/`9a24fd30` (module proxy for fork homes); the todo is still open.

What is missing is evidence: no example app has run release → offer → member
adopt → undo, and one known defect blocks it (703 D4, offer refuses a
released version).

## Priority apps (operator, 2026-11-24)

From the operator's own use: **form/poll** first, then **viewer/website**,
then **brainstorm**.

- **Form.** A new definition per collection is data the agent writes
  (`form add --def`, `--poll`); that needs no shaping. Shaping pays where the
  engine itself falls short for one owner: a field kind, conditional
  questions, result rendering, layout. The owner shapes it once, releases it
  and offers it to the members who run collections.
- **Viewer.** Content is trivial for an agent; shaping shows only for
  presentation the owner wants to keep and hand on (a report layout, a block
  kind). Second row.
- **Brainstorm.** Not shaped yet: 703 story `cb9b4b80` (register as shaped).
  Third row once that lands.

## Stories

| Story | Prio | Depends on |
|---|---|---|
| O0 confirm the console builds the desk-family apps as member instances from the module proxy; close `d35e0de8` with that evidence | p0 | 703 F11 `d246ca4e` (gate host bashy current) |
| O1 owner publish e2e skill-script: form, then viewer, then brainstorm rows | p1 | O0; 703 D4 `90f03f54`; 706 R8 `d8b7f10afa31` |
| O2 kb runbook "Publish a shaped version to members" | p2 | O1 |

O1 flow per row: the owner wishes (a `genie.examples` line), verifies,
approves; `release` names it; `offer --to MEMBER`; the member
`adopt --preview`, then `adopt`; the change is visible to that member only;
the member `undo`es; the owner `submit`s the approved revision. The worker
writes and dry-runs the script; the conductor runs it live. A model-backed
live run is one paid run and needs the operator's go.

## Relation to Sprints 703 and 706

- 703 D4 (offer refuses a released version) blocks O1: root cause first.
- 703 brainstorm-as-shaped gates the brainstorm row; 703 F9 (viewer CLI
  discovery) affects the viewer row; 703 F4 (kit handler lift) touches the
  form/viewer kit, so land it before O1 freezes a candidate.
- 706 R8 is the unit-level baseline of the same verbs; O1 is its live
  counterpart on real apps. 706 R5 (a member shapes the owner's app) and
  R6 (public wish list) are not repeated here.

## Not doing

Website tiers (shipped; 706 R6 covers public wishes); member shaping of the
owner's app (706 R5); offer/adopt for CLI-kind apps; any release.

## Open decisions for the operator

1. Offer and adopt in the web console (today CLI only): needed for members
   who never use the CLI?
2. C1b leftovers from 682 (idle-start, remote and other-principal runtime
   discovery): file as todos, or drop?
3. Raise 703 `cb9b4b80` (brainstorm as shaped) from p3, given use?
