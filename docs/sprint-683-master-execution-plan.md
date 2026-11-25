# Sprint 683: owner publishing for a shapeable page and its components (plan)

Rescoped 2026-11-24 at the operator's review. The card and its stories are
authoritative; this page is the map. Planning only until assigned.

**Held (operator, 2026-11-24)** until Sprint 705 S3 settles the model below.
Then re-review O1 and O2 against it. Sprint 701 decided no-go on the UI SDK
(operator, 2026-11-24; bashy avoids Vercel products and dependencies), so 683
no longer waits on it. Sprint 703 closed on 2026-11-24 (umbrella 10497e9ad);
its stories that 683 needs (O0, F11, D4, brainstorm as shaped, the
`offer --all` bug) moved back here. O0, F11 and D4 do not depend on the UI
and may proceed before the hold lifts, with the operator's go.

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
adopt → undo, and one known defect blocks it (D4, offer refuses a
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
- **Brainstorm.** Not shaped yet: story `cb9b4b80` (register as shaped).
  Third row once that lands.

## Stories

| Story | Prio | Depends on |
|---|---|---|
| F11 `d246ca4e518e` gate host: the installed bashy predates the local module proxy (from 703) | p0 | none |
| O0 `b23982703c71` confirm the console builds the desk-family apps from the module proxy; close `d35e0de8` (from 703) | p0 | F11 |
| D4 `90f03f54c150` root-cause: offer refuses a released version (from 703) | p1 | none; root cause first |
| `338073746e28` `shape offer --all` is visible to anonymous (from 703) | p3 | reproduce first; fix shape follows open decision 4 |
| `cb9b4b80a88d` register brainstorm as a shaped app (from 703) | p3 | none; gates O1's brainstorm block (open decision 2) |
| O1 owner publish e2e skill-script on one page shared as a suite with a circle: form/poll, then viewer book, then brainstorm blocks | p1 | O0; D4; the 706 R5 `5c1b07e994f1` step-0 shaping baseline (R8 `d8b7f10afa31` was folded into it, wontfix); 710 H6 `14bb7d2b5eab` (H1 `ef2ce499a64a` / H5 `f095ebc76350` by share path); pinned page release (open decision 3); offer audience (open decision 4) |
| O2 kb runbook "Publish a shaped version to members" | p2 | O1 |

O1 flow, on one `desk/page` carrying form/poll, viewer book and brainstorm
blocks (plus the website face), shared as a suite with an owner-named circle
(Sprint 710), one block at a time in that order: the owner wishes a change to
the block (a `genie.examples` line), verifies, approves;
`release` names a page release that pins the component versions it was
verified with; `offer` to the circle's members (form per open decision 4);
a member in the circle `adopt --preview`s, then `adopt`s; the change is
visible to that member only; a member outside the circle sees no offer; a
logged-in non-member and an anonymous visitor get only the public face; the
member `undo`es; the owner `submit`s the approved revision. The worker writes and dry-runs the
script; the conductor runs it live. A model-backed live run is one paid run
and needs the operator's go.

## Relation to Sprint 706, and what 703 left

- D4 (offer refuses a released version) blocks O1: root cause first.
- Brainstorm-as-shaped gates the brainstorm block. 703 F9 `6fb0e96d8fcf`
  (viewer CLI discovery) and F4 `60b4624b22f9` (kit handler lift) closed
  won't-do with 703; if the viewer block hits F9's gap, O1 records it.
- The unit-level baseline of the same verbs is the step-0 evidence record of
  706 R5 `5c1b07e994f1` (R8 `d8b7f10afa31` was folded into it and closed
  wontfix); O1 is its live counterpart on a real page. R5's own scope (a
  member shapes the owner's app) and 706 R6 (public wish list) are not
  repeated here.

## Relation to Sprint 710 (owner sharing)

Sprint 710 (2026-11-24) settles who reaches an owner's apps: a satellite
admits members, only through the owner's invite; anyone else, anonymous or a
logged-in non-member, gets only what the owner publishes publicly, as
anonymous. Owners share apps, singly or as a suite, by grant rules naming
owner-named circles, groups or emails; master shares project to satellites
(H5). What this means for 683:

1. **Offers and shares use different audiences.** `shape offer --to|--all`
   (`yoke/pkg/src/offer.go`) targets host-local principals: `--to` names
   them, `--all` is every principal the app's repo has seen. It knows no
   circles, groups or suites, so an offer can reach someone without access,
   or miss a circle the page is shared with. Open decision 4.
2. **`offer --all` is visible to anonymous.** `isVisible` returns
   `offer.All` for an empty principal. Adopting still needs a principal;
   offers should be member-only. Filed as bug `33807374` (now a 683 story).
3. **The page and its components are a suite.** The page plus the form,
   viewer and brainstorm components it embeds is the unit 710 shares; the
   pinned page release (open decision 3) is the matching unit for versions.
4. **The website face is the public publish.** It is served to everyone who
   is not a member as anonymous, and never shows a member's adopted version.

O1 therefore shares the page as a suite with a circle and offers to that
circle, and waits for 710 H6 (suite-to-circle sharing proven on a real
satellite); H1 if the script shares from the CLI, H5 if from the master.

## Not doing

Idle-start and remote or other-principal runtime discovery (682 C1b
leftovers): not filed until a need appears (operator, 2026-11-24, KISS).

Website tiers (shipped; 706 R6 covers public wishes); member shaping of the
owner's app (706 R5); offer/adopt for CLI-kind apps; any release.

## Open decisions for the operator

1. Offer and adopt in the web console (today CLI only): needed for members
   who never use the CLI?
2. Raise `cb9b4b80` (brainstorm as shaped) from p3, given use? It
   gates O1's brainstorm block.
3. Who builds the pinned page release? Today `shape release APP REV` names a
   release for one app only (`--repair`, `--contract` for approved contract
   removals); nothing releases a page and its components as one pinned set.
   O1 is a test and cannot be its owner. Options: a 705 S3 outcome, a new
   683 story, or O1 releases the page alone and pinning waits. With
   Sprint 710 the page and its components are a suite; tie the pinned
   release to the suite or record why not.
4. Offer audience: should `shape offer` take `--circle`/`--group` (or a
   suite) and resolve them through the same grant rules as sharing, or keep
   `--to` principals and check each offer against the share? Product
   decision; input for 705 S3.

Decisions 3 and 4: a design record (no code) is being written by another
session (umbrella-15, 2026-11-24) as 705 S3 input and reviewed with the
operator before any story; implementation then lands as 683 stories.
