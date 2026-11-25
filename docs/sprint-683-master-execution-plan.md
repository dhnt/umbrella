# Sprint 683: owner publishing for a shapeable page and its components (plan)

Rescoped 2026-11-24 at the operator's review. The card and its stories are
authoritative; this page is the map. Planning only until assigned.

**Held (operator, 2026-11-24)** until Sprint 705 S3 settles the model below.
Then re-review O1 and O2 against it. Sprint 701 decided no-go on the UI SDK
(operator, 2026-11-24; bashy avoids Vercel products and dependencies), so 683
no longer waits on it. O0 moved to Sprint 703 (2026-11-24) to proceed with D4; neither depends on the UI.

## Direction: one shapeable page, equally shapeable components

Operator, 2026-11-24: the target for any website is one shapeable page whose
embedded components are each equally shapeable. `bashy/examples/desk/page`
already composes live blocks (`poll form book note board chart timer here
hands embed`) over HTTP from engines it does not merge, and renders most of
them itself. Shaping the page therefore covers layout, block rendering and new
block kinds in one place, with one release to offer.

What shaping the page does not cover, and S3 must settle:

1. **Component behavior.** Form field kinds, conditional questions,
   validation and brainstorm phases live in the component; the component is
   shaped for those.
2. **iframe embeds.** Page shaping never reaches inside a framed app;
   whiteboard, table, klatch and demo-queue refuse framing (link-out cards).
3. **Version coupling.** A released or offered page must pin the component
   versions and API contracts it was verified with (`contract.bsh` exists;
   pinning does not).
4. **Three overlapping surfaces.** `desk/page` (live group page),
   `shaping/site` (public content module) and `shaping/website` (layer over
   a static site) converge or get explicit roles.

Proposed model: components are headless services (data, API, agent CLI) with
their own shaped UI blocks; the page is the shaped composition shell; block
kinds are the extension point and stay server-rendered (Go `html/template`,
no build step); client-side behaviour is optional and added per control. No
outside UI framework or SDK supplies the blocks (Sprint 701 no-go). The same
input is on the Sprint 705 card for S3.

When the hold lifts, the O1 rows become one page carrying form/poll, viewer
book and brainstorm blocks (plus the website face), and the owner release
pins the component versions it was verified with.

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
| O0 `b23982703c71` confirm the console builds the desk-family apps from the module proxy; close `d35e0de8`. **Moved to Sprint 703** | p0 | 703 F11 `d246ca4e` (gate host bashy current) |
| O1 owner publish e2e skill-script on one page: form/poll, then viewer book, then brainstorm blocks | p1 | 703 O0 `b23982703c71`; 703 D4 `90f03f54`; the 706 R5 `5c1b07e994f1` step-0 shaping baseline (R8 `d8b7f10afa31` was folded into it, wontfix); pinned page release (open decision 3) |
| O2 kb runbook "Publish a shaped version to members" | p2 | O1 |

O1 flow, on one `desk/page` carrying form/poll, viewer book and brainstorm
blocks (plus the website face), one block at a time in that order: the owner
wishes a change to the block (a `genie.examples` line), verifies, approves;
`release` names a page release that pins the component versions it was
verified with; `offer --to MEMBER`; the member `adopt --preview`, then
`adopt`; the change is visible to that member only; the member `undo`es; the
owner `submit`s the approved revision. The worker writes and dry-runs the
script; the conductor runs it live. A model-backed live run is one paid run
and needs the operator's go.

## Relation to Sprints 703 and 706

- 703 D4 (offer refuses a released version) blocks O1: root cause first.
- 703 brainstorm-as-shaped gates the brainstorm block; 703 F9 (viewer CLI
  discovery) affects the viewer block; 703 F4 (kit handler lift) touches the
  form/viewer kit, so land it before O1 freezes a candidate.
- The unit-level baseline of the same verbs is the step-0 evidence record of
  706 R5 `5c1b07e994f1` (R8 `d8b7f10afa31` was folded into it and closed
  wontfix); O1 is its live counterpart on a real page. R5's own scope (a
  member shapes the owner's app) and 706 R6 (public wish list) are not
  repeated here.

## Not doing

Idle-start and remote or other-principal runtime discovery (682 C1b
leftovers): not filed until a need appears (operator, 2026-11-24, KISS).

Website tiers (shipped; 706 R6 covers public wishes); member shaping of the
owner's app (706 R5); offer/adopt for CLI-kind apps; any release.

## Open decisions for the operator

1. Offer and adopt in the web console (today CLI only): needed for members
   who never use the CLI?
2. Raise 703 `cb9b4b80` (brainstorm as shaped) from p3, given use? It
   gates O1's brainstorm block.
3. Who builds the pinned page release? Today `shape release APP REV` names a
   release for one app only (`--repair`, `--contract` for approved contract
   removals); nothing releases a page and its components as one pinned set.
   O1 is a test and cannot be its owner. Options: a 705 S3 outcome, a new
   683 story, or O1 releases the page alone and pinning waits.
