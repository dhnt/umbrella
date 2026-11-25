# Sprint 683: owner publishing of a shaped version (plan)

**Parked (won't do), operator 2026-11-24.** A/O/C is the business
workflow supported now (docs/access-tiers.md; Sprints 706 and 709). It serves
one version on the owner's line, so it uses no offer, adopt or owner release,
and rollback is the owner's undo and history. The 709 conductor and the
author of docs/design-shape-offer-audience.md agreed. O1 and O2 are won't
do; D4 `90f03f54c150` is a backlog bug. The A/O/C work on `desk/page` stays
with the A/O/C sprint. Reopen from this plan only if publishing to
per-person copies becomes a real need. The MVP below is kept as the record.

Rescoped to the MVP at the operator's KISS review, 2026-11-24. The card and
its stories are authoritative; this page is the map. Planning only until
assigned.

## Rod, not fish

Software shaping exists so that owners and members add the features they
need when they need them. This sprint therefore delivers the rod only: one
path by which an owner publishes a shaped version of an app to a member, and
the member previews, adopts and undoes it. It does not build features ahead
of need; those are fish, and shaping makes them later.

The verbs already exist for every app registered `--type shaped`, with no
app-specific wiring: `bashy shape release | offer --to | adopt [--preview] |
undo | submit` (`bashy/internal/agentos/shape.go`, backed by
`yoke/pkg/src/release.go`, `offer.go` and `yoke/pkg/shape/submit.go`). What
is missing is one composition that runs them end to end, the evidence that it
works, and a runbook that teaches it. One known defect blocks it: D4, offer
refuses a released version.

## Stories

| Story | Prio | Depends on |
|---|---|---|
| D4 `90f03f54c150` root-cause: offer refuses a released version | p1 | none; root cause first |
| O1 `121a44e332bc` owner publish skill-script: takes APP and MEMBER, composes the existing verbs; proven once on the form/poll block of `bashy/examples/desk/page` | p1 | D4 |
| O2 `5568fef88494` kb runbook "Publish a shaped version to members": teaches the verbs and the script, with the form/poll run as the worked example | p2 | O1 |

O1 flow: owner wish (the app's `genie.examples` line), verify, approve;
`release`; `offer --to MEMBER`; the member `adopt --preview`, then `adopt`;
the change is visible to that member only; the member `undo`es; the owner
`submit`s the approved revision. Its first step on the gate host confirms
the console builds the app as a member instance. The worker writes and
dry-runs the script; the conductor runs it live. A model-backed live run is
one paid run and needs the operator's go.

Composition note: the skill-script is a thin Bash# composition of the verbs
above, no new Go. Anyone runs it with another APP; that is the shaping hook.

## Not in the MVP (filed only when a need appears)

- Runs on other blocks or apps (viewer, brainstorm, ...): the same script
  with another APP.
- A pinned release of a page together with its components, and offering to
  circles or suites (Sprint 710's sharing model). Design note, proposed,
  Sprint 705 S3 input: `docs/design-shape-offer-audience.md`. It files no
  683 stories and does not block this sprint.
- Public-face and non-member checks: Sprint 710 H6 covers them.
- Moved to the backlog at this review (no sprint): F11 `d246ca4e518e` and
  O0 `b23982703c71` (O1's first step re-checks the build; if it fails they
  come back with a recorded root cause), `338073746e28` (`offer --all`
  visible to anonymous; visibility only), `cb9b4b80a88d` (brainstorm as a
  shaped app).
- Offer and adopt in the web console; offer/adopt for CLI-kind apps; any
  release; idle-start and remote runtime discovery (682 C1b leftovers).

## History

Earlier scopes (per-app rows; a page with three blocks, suites and pinned
releases) are in this file's git history and on the card thread.
