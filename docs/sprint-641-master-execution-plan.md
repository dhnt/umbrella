# Sprint 641: MVP phase A — voice input + dhnt.io cosmetic

Sprint UUID: `d8aa925c-ba20-5705-ba28-33bc35700909`. Epic: software-shaping.
Status: **planning, filed and rescoped 2026-11-14**; backlog, unclaimed.
Design of record: **`docs/dhnt-journey-design.md`** — the rungs, the eight
laws, and the rung-1 detail. Boundary table: `docs/sprint-641-feature-matrix.md`.

## What this card is

**Phase A of the MVP: voice input + dhnt.io cosmetic.** The MVP is the journey
itself, delivered in phases — **A** voice + cosmetic, **B** outpost, **C** app,
**D** satellite — each shipping end to end before the next begins
(`docs/dhnt-journey-design.md`). This card is phase A, and nothing else: **a person arrives at dhnt.io,
signs in with their email, and shapes their own desktop** — layout, tiles,
look, settings — by hand or by asking in words, with undo, inside a boundary
the schema declares and a free allowance that is stated. Once they have
actually done it, they are invited to attach their own machine, which is where
the journey continues.

No machine, no install, no repository and no deploy is required from the
person. That constraint is the point: it is what makes dhnt.io a desktop rather
than a download page.

The design is deliberately small and **not meant to be final** — it is meant to
be flexible where later rungs touch it. Every extension point is a declared
file, an ordered list or a data table, so widening it is an edit, not a
redesign.

## Stories

| Story | What it delivers |
|---|---|
| `fd88e341de41` **J0** badge on dhnt.io | the entry: the page says it can be shaped, and offers a taste that is not kept (638 S2's design) |
| `badd3f9c73de` **J1** voice in the desktop's wish box | the one voice module (624 V2, `window.bashyVoice`) vendored into the hosted SPA, so the desktop can be **spoken** to, not only typed at |
| `9d7adcb33d61` **J2** schema + property document | the half with no AI in it: five or six typed properties, a document per account, two resolver layers, an ordinary control and a `--json` setter for every property, numbered revisions, undo, history |
| `f89b5f3095bb` **J3** wish → validated patch | the thin AI layer: a sentence becomes a patch, the schema validates it, a bad patch is refused with its reason, a good one becomes a revision |
| `c7b35d798b12` **J4** CLI parity | `bashy desktop schema\|get\|set\|wish\|undo\|history --json`, and the flow as a skill-script |
| `928fb2c3584e` **M4** the boundary | which schema sections each audience may change — the disclosure behind the badge |
| `ccab603b5e2e` **M6** the free allowance | bounded pooled wishes, visible, refusing rather than degrading |
| `3db3e946cb84` **J5** journey state | a few competence events and the invitation table as data; one invitation (rung 2) implemented, shown only after a first shape and a first undo |
| `7c7b5501492f` **J6** the record | the whole walk, by a new person, with the ids and the refusal texts |

Nine stories. Phase A carries voice because a desktop you can only type at is
not the demonstration — and it is affordable here because tiers 0 and 1 (the
operating system's dictation, and the browser recognizing speech on the device)
need nothing installed. Tier 2, the person's **own machine** transcribing, is
phase B's reward for attaching it — Sprint 624 V3, V4 and V7.

The hosted half of J2 and J3 — the document store and one
additive endpoint — is cloudbox work, tracked privately as `fada4758`; the
public half is the schema format, the verbs, the wire contract and the journey
table.

## Order

```
J2 ──► J3 ──► J4 ──► J6
 │       ▲      ▲      ▲
 └─ M4 ──┘      │      │
 J0, J1 (independent of the data model, any time) ──┘
 M6 before J3 is reachable by anyone but us
 J5 after J2 (it stores its events in the same document)
```

J2 first and alone: a desktop whose settings work by hand is already worth
shipping, and it is the only story the rest cannot be built without. J3 is
thin on top of it. M6 gates letting anyone else in.

## What is deliberately not here — it is a later phase

- **code-level shaping, candidates, Red → Green** — phase C; back on Sprints 621
  and 638, where the stories already live;
- **the trove space and its GitHub mount** — phase B/C, Sprint 639 (`S1`,
  `S4b`, `S15`): someone with no machine has nothing to mount;
- **host transcription of a spoken wish** — phase B, Sprint 624 (`V3`, `V4`,
  `V7`): it is the reward for attaching a machine;
- **the member queue and approvals** — phase C/D, Sprint 640;
- **the upstream promotion ladder** — Sprint 617 (`P4b`);
- **a second demo app** — the desktop is the demo, and "hello world" exists.

## The blocker this card does not own

**`d871ac00b808` (p1, standalone): `operatorSession` treats any non-device
principal as an operator.** Every shaping person at rung 1 is a signed-in cloud
principal, which is exactly the mishandled case, so this went from should-fix
to **hard blocker** the moment identity became mandatory. It must be
root-caused and fixed before anyone outside the team reaches the desktop.

## Gates and venues

- Per story: its own acceptance plus the relevant regression; `--json` parity
  rows for every new verb; the scrub gate always.
- J2 must pass with the pooled route unreachable — that is its point.
- Dev box: unit tests, headless Chrome, the verifier, the oss routes. No hosted
  CI. No release authorized by this card.

## Closure

J6 recorded by a person who is not the operator, on an account that owns no
machine: badge seen, signed in, a wish **spoken** on a browser that recognizes
speech locally and typed on one that does not, properties set by hand and by CLI, a wish
applied and undone, a wish outside the schema refused in the schema's terms,
the allowance decremented and visible, the change surviving a reload, a second
account unaffected, the pool-down path showing settings still work, and the
rung-2 invitation appearing only after the first shape and undo. Plus the
`operatorSession` fix, or the desktop kept inside the team until it lands.

## Decisions reserved for the operator

1. **The free allowance's number**, and whether it resets daily or is a
   one-time first-session grant.
2. **Which rung-2 gain leads the invitation**: own apps as tiles (most
   tangible), own files, or no wish ceiling (most honest).
3. **How much of the desktop's chrome is in the schema** — only the tile field,
   or the header and navigation too. More is a better demonstration and a
   larger invariant surface to defend.

## Active delivery override — operator instruction 2026-11-15

The operator explicitly directed this session to take Sprint 641 and deliver
Outpost and Bashy app UI refactoring first. Cloudbox and satellite UI work is
on hold until the operator gives the next instruction. The earlier hosted
journey scope above is preserved as deferred context, not acceptance for this
bounded delivery. No hosted deployment or public release is authorized.

Deliver a private page/server action contract for the two local surfaces:
- Reusable framework-independent browser registration and websocket action
  transport, with explicit handler input validation and asynchronous outcomes.
- Authenticated, principal-isolated live page discovery and commands; bounded
  queues, expiry, disconnect failure, no automatic replay or arbitrary script.
- Bashy integration using existing console principal authorization and existing
  Shape workflow, plus CLI parity for added live-page operations.
- Outpost integration reusing admincore, existing session/bearer authentication,
  and existing CLI/API mutations. Presentation actions must not turn an admin
  browser into a privilege escalation path for a narrower credential.
- Shape-only toggle and named form/field handlers for representative settings
  flows; UI and agents invoke the same functions. Keep Shape reachable and
  protected sign-in/pairing/approval behavior intact.

Acceptance: focused unit/HTTP/browser tests prove action validation, shared
handler use, CLI parity, principal isolation, reconnect/unmount behavior and
proxied mount paths on both surfaces. Inventory existing CLI equivalents rather
than recreating business logic. Preserve unrelated edits. Verify integrated
producer/consumer sources with temporary local module wiring if publication is
not authorized. Report exact delivered scope and residual limits; do not label
all historical Sprint 641 stories done.

### Local source delivery — 2026-11-15

The three refactoring stories are accepted for the bounded source delivery:

| Story | Source commit | Delivered behavior |
| --- | --- | --- |
| R1 `46d76276772e` | yoke `2b74a473` | Named-action registry, authenticated page transport, isolated discovery/results, bounded expiry and no replay |
| R2 `0b1b0346e78e` | yoke `47f221c3`, bashy `15fa90c0` | Shared Shape handlers, reversible Shape-only, operator/session gates, page CLI |
| R3 `96be6ef5a8a5` | outpost `bdd2faa9` | Networking draft/get/submit, five-tab navigation, Shape-only and page CLI |

The approved Flow master is bashy `c6d6db1b`; its embedded copy is included in
the R2 yoke commit. Assessment and icon stories were also accepted. Internal
collaboration workers implemented the three slices; the interactive manager
reviewed changes and independently ran each acceptance gate.

Independent `bashy gate` results all passed:

- yoke: `GOWORK=off go test -race ./pkg/pagecontrol` and
  `node --test pkg/pagecontrol/page_test.cjs`.
- yoke: `GOWORK=off go test -tags verifydom ./pkg/webconsole -run
  'Test(DOMPageActions|DOMGenieButton|DOMGenieEditSession|PageControl)' -count=1`.
- bashy: `go test ./internal/agentos -run TestShapePage -count=1`, with temporary
  module wiring to the delivered yoke source and `GOWORK=off`.
- outpost: `go test -tags fb_archives ./internal/agent/adminui ./cmd/outpost
  -run 'Test(Page|IndexCarries|NoRootRelative)' -count=1`, using the same local
  producer wiring; Node handler fixture and actual Chrome DOM fixture also pass.

Review corrected inert handling for custom controls, prompt cookie revocation,
and CLI redirect replay. An interim Bashy Pick regression was traced to an
extra form row; preserving the original row layout restored the existing test.
The separately reproduced baseline `TestDOMGenieReviewBar` missing-link failure
remains open; it is not counted as passing. No broad full-suite claim is made.

Usage and exact parity inventories live in yoke `docs/page-actions.md` and
outpost `docs/page-shaping.md`. Outpost supports Host-preserving proxy prefixes;
rewritten-Host proxies need an authenticated proxy contract. Outpost has a
dictation hint, not newly implemented speech recognition; Bashy retains its
existing capability-detected voice input. Legacy forms are not all migrated.

Publication, consumer dependency pins and umbrella gitlinks remain unchanged.
These are local source commits, validated together with temporary module files;
standalone consumer builds still need the new yoke version published and pinned.
No new refactoring binaries were installed. Other UI surfaces remain on hold
for the operator's next instruction. Historical sprint scope remains open.
