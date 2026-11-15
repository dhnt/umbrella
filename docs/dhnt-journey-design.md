# The dhnt journey: one desktop that grows, taught by shaping

Design of record for how a person meets the dhnt ecosystem — the hosted plane
(cloudbox), their own machines (outpost), their own front door (satellite) —
and is carried from "I changed the colour of a tile" to "I run my own plane and
share with partners", **without ever being handed a manual**. The teacher is
software shaping itself: you learn the system by asking it for things.

Companion to `docs/sprint-641-master-execution-plan.md` (the MVP) and
`docs/sprint-641-feature-matrix.md` (who may change what).

## The thesis

In traditional computing everyone starts at a **desktop**. dhnt.io is that
desktop, free, in a browser, before anything is installed — and as the person
attaches their own machines, **those machines become its backend**. The hosted
plane starts as everything and ends as a thin relay, which is the stated
vision reached by one continuous path instead of a pitch deck.

The code already routes this way: unauthenticated `/` is the landing, and a
signed-in person lands at the portal root where the launcher renders their
tiles, "Shared with me" included (`hub/internal/auth/auth_member.go:70-78`,
`hub/internal/reserved/reserved.go:35`). What is missing is that **the desktop
is shapeable** and that **its tiles can be the person's own machines**.

## The eight laws

These bind every rung. They are what keep a journey from becoming a wizard.

1. **One subject, growing.** There is never a new app per rung. The desktop the
   person shaped on day one is the same desktop that later fronts their own
   hardware. Nothing is migrated, re-learned or re-named.
2. **Invitations are earned, never pushed.** The next rung appears only after
   the current one has been *used* — after a first shape and a first undo, not
   on arrival. An invitation that arrives before competence is a nag.
3. **Nothing is lost at a boundary.** Cosmetics made at rung 1 survive
   attaching a machine at rung 2. A satellite default never overwrites a
   person's own choices; it only fills what they never set.
4. **Every rung is reversible, and says so before it is taken.** Detach the
   machine, stop the satellite, undo the shape — the desktop degrades to the
   previous rung with no data loss and an explicit statement of what changed.
5. **No dead ends and no silent degradation.** When a rung needs something — a
   machine, HTTPS to a phone, a model, a grant — the desktop names exactly what
   is missing and offers the one action that fixes it. Never a greyed-out
   control, never a quiet fallback.
6. **The invariant floor is identical at every rung.** The declared schema, the
   suite's chrome laws, every route and API shape, per-principal activation and
   the declared effect caps are outside the shaping ladder for everyone,
   including staff — staff change them by **release**, never by a wish.
7. **Economics is a rung property, not a paywall.** The free desktop gets a
   bounded number of pooled wishes. Attaching your own machine or model lifts
   the ceiling, because the compute is then yours. Receivers never pay.
8. **Everything the UI offers has a CLI path, and every flow is a
   skill-script.** The guide can therefore always answer "…and this is the
   command", and an agent can walk the same rung unattended. Rod, not fish.

## The rungs

Each rung states: what the person **sees**, what they **do**, what they
**learn**, and what it **unlocks**. The "learn" line is the point — a rung that
teaches nothing is a feature, not a rung.

### Rung 0 — Arrive (not signed in)

- **Sees:** dhnt.io, wearing the **Shape badge**. The page says, in its own
  words, that it can be changed by asking — and offers a taste that runs
  entirely in the browser and is not kept.
- **Does:** tries the taste, then signs in with Google or GitHub.
- **Learns:** software shaping is a thing you *do*, in seconds, not a concept.
- **Unlocks:** an identity. Shaping requires one: a change belongs to someone
  and must be undoable by them, so **email plus OAuth2 is mandatory from the
  first real shape** — `google` and `github` exist today
  (`hub/internal/auth/auth_user.go:124`).

### Rung 1 — Shape your desktop (free, nothing installed)

- **Sees:** their desktop — the launcher, with whatever tiles their account
  already reaches — and a wish box on it.
- **Does:** *"put my notes tile first and make this darker"*. It happens. They
  undo it. They do it again differently.
- **Learns:** the four words the whole system runs on — **wish, change, mine,
  undo**. Mine matters most: their desktop changed and nobody else's did.
- **Unlocks:** the next invitation, once they have shaped and undone at least
  once: *"I can only rearrange what I can see. Let me see your machine."*
- **Mechanism:** a versioned **declared cosmetic schema** in the SPA (tile
  order, membership, size, labels, grouping, palette, font, density,
  presentation settings — typed, with enums, ranges and known ids), a
  **property document per person** plus a satellite default, and a wish path
  that resolves the sentence into a **patch validated against the schema**
  server-side. Validation is the verifier at this rung: wrong type, unknown
  tile, out of range → refused with the reason, nothing partial applied. Each
  applied patch is a numbered revision carrying its wish text, so undo,
  history and reset mean what they mean everywhere else. No code candidate, no
  build, no source tree.
- **Ceiling:** a bounded number of pooled wishes per day (law 7), stated up
  front, with the remaining allowance visible.

### Rung 2 — Attach your machine (outpost)

- **Sees:** *"Your desktop is running on our computers. Want it running on
  yours?"* — with what that gains, in their terms: their own apps as tiles,
  their own files, their own model, no wish ceiling.
- **Does:** one pairing — a command or a QR code — using the same account.
  Pairing happens **once per machine** and the machine then attaches to
  whatever it needs.
- **Learns:** the mesh. Their computer is not a client of the desktop; it is
  the desktop's backend.
- **Unlocks:** tiles from that host, their files in reach, their own model able
  to serve wishes (which lifts the ceiling), and the next invitation:
  *"Now make something of your own."*

### Rung 3 — Make something of your own (apps with source)

- **Sees:** an invitation to start something real — a blog, a page, a tool —
  from an empty page, not from a template gallery.
- **Does:** `bashy app new` (which exists: *"create a blank app to shape from
  an empty page"*), then shapes it by asking. Here the ladder graduates from
  property patches to **real candidates**: verify, preview, approve, undo.
- **Learns:** that a change can be *proven* before it is live — the candidate,
  the check that failed before it passed, the version they can roll back. They
  learn it **after** rung 1 taught the vocabulary, so nothing is new except
  rigour.
- **Unlocks:** something worth showing to someone, and therefore rung 4.

### Rung 4 — Share locally (family, teammates)

- **Sees:** *"Who is this for?"* — their own circles, their own words.
- **Does:** shares the app with mutual members by circle or group; decides,
  from a **feature list they declare**, what those people may change: look and
  layout yes, the contract no.
- **Learns:** the boundary — that sharing is not all-or-nothing, that a
  refusal names the feature rather than a file, and that a member's change is
  a member's own until it is approved.
- **Unlocks:** other people's wishes arriving on their app, and therefore the
  need for a queue and an approver (Sprint 640's team shaping).

### Rung 5 — Run your own front door (satellite)

- **Sees:** *"You are sharing through our address. Want your own?"*
- **Does:** provisions their own satellite — their own front door, their own
  pooled models, their own invitations to partners and the public.
- **Learns:** that the hosted plane was always replaceable, and that nothing
  they built has to move for them to own the plane.
- **Unlocks:** the world: public pages, partners, their own members, their own
  economics.

## Rung 1 in detail — the part everything else stands on

Rung 1 is the MVP, and the MVP is a foundation, not a demo — but a foundation
is not a cathedral. The design below is deliberately small, and it does not
have to be right forever: **it has to be flexible in the places that later
rungs touch.** Every extension point here is a declared file, an ordered list
or a data table — a rod, not a fish — so widening it is an edit, not a
redesign, and the design itself can be shaped gradually like everything else.

### 1. The document is a layer stack, not a blob

What a person "shaped" is never stored as the finished appearance. It is stored
as **their own layer**, resolved over a default:

```
default  <  the person's own
```

Two layers now, and the resolver takes an **ordered list**, so a satellite
default or a host-local layer later is a new entry in that list, not a
redesign. Resolution is deterministic, and the interface can always say where a
value came from — *"this spacing is your satellite's default; your own choice would
replace it"*. Law 3 then holds for free: a satellite default never overwrites a
person's expressed choice, it only fills what they never set, and attaching a
machine adds a layer rather than migrating anything.

### 2. The document is keyed to the account, and portable from day one

Keyed to the **email identity**, never to a browser, a device or a satellite.
Its format is declared and versioned (schema id, schema version, the person's
layer, and each revision's wish text and provenance), so the same document can
later be served from the person's own host at rung 2 without a conversion. A
document that cannot move is a rung-1 feature that becomes a rung-2 migration,
which law 1 forbids.

### 3. The first schema is small, and grows by being shaped

Five or six properties, not a design-token system: theme, density, tile order,
which tiles show, their labels. The schema is a **declared file**, so widening
it later is an edit to that file plus the controls it implies — the ordinary way
everything here changes. The flexibility is in *where things are declared*, not
in generality built ahead of need.

### 4. A person's intent is never destroyed by a schema change

Schema evolution is additive by default. A key the current schema does not
understand is **kept in the document and ignored at render**, surfaced in
`--json` as unhonoured, never deleted — so a later schema version can honour it
and an older client cannot silently discard what someone asked for. A rename
ships with a migration map; a removal is a product decision that says, in
words, what was dropped.

### 5. Every property is settable without a model

The wish box is a **convenience over a deterministic surface**, not the only
door. Each declared property has an ordinary control in the interface and a
`--json` CLI setter, and the natural-language path resolves to exactly the same
patch. Three things follow, all of them load-bearing: the rung is fully
testable with no model call, the pool being down degrades the rung to plain
settings instead of to nothing (law 5), and nobody is ever charged a wish for
something a switch could do.

### 6. The nouns and verbs are the ones rung 3 uses

Rung 1 must not invent its own vocabulary:

| | rung 1 (properties) | rung 3 (source) |
|---|---|---|
| ask | `wish` | `wish` |
| what comes back | a **patch** | a **candidate** |
| how it is judged | validated against the schema | verified by the checks |
| look before it is live | — (apply and `undo`) | `preview` |
| make it so | `apply` | `approve` |
| take it back | `undo` | `undo` |
| what it leaves behind | a numbered revision with its wish text | a numbered revision with its wish text |

Same verbs, same per-principal activation, same undo semantics. Rung 3 then
teaches only one genuinely new idea — that a change can be *proven* — instead
of a second product.

### 7. No separate preview at rung 1

Tempting, because rung 3 depends on the habit — but a cosmetic change applies
instantly and `undo` is right there, so apply-and-undo *is* the preview, and a
second mode would be machinery nobody needs yet. The word stays reserved for
rung 3, where a candidate genuinely cannot be shown any other way.

### 8. The journey state records competence, not traffic

A handful of named events in the same document — this person **shaped
something and undid it**, an invitation was shown, taken or dismissed — and the
invitation rules as a **small data table**, itself shapeable. Not a subsystem.
Page views are not competence. Law 2 is only implementable on top of events like these, and they
are also the only honest measure of whether the MVP worked.

### The badge is the door to the boundary

The Shape badge is a promise that this surface **declares what may be shaped**.
Clicking it shows that declaration — the feature list of
`docs/sprint-641-feature-matrix.md` in the person's own terms, with what they
may change here, what is the app's contract, and what their allowance is. The
badge is therefore not decoration and not a logo: it is the disclosure.

## How the guide works

Not a tour, not a chatbot, not a checklist nagging in the corner. Three parts,
and the first two already have homes:

1. **The invitation card on the desktop.** One at a time, earned (law 2),
   written in terms of what the person just did. It names the capability, the
   single action, and what it costs or risks. Dismissible, and dismissal is
   remembered.
2. **The wish box as the help system.** "How do I share this with my wife?"
   is a wish. The answer is either the thing done, or the one command shown —
   never a documentation link as the primary answer.
3. **The journey state**, which is the one genuinely new component: a small
   per-person record of which rungs are reached, which invitations were shown,
   taken or dismissed, and what the next one is — **data plus a rule table,
   not code per rung**, with `--json` verbs so an agent reads the same state,
   and shapeable like everything else (a person may reorder or silence their
   own invitations).

The guide is therefore subject to the thing it teaches, which is the most
honest demonstration available.

## The MVP is the journey, delivered in phases

The rungs are not a roadmap that follows the MVP — they **are** the MVP, taken
one phase at a time, each shipping end to end before the next starts.

| Phase | Subject | Exits when |
|---|---|---|
| **A** | **voice input + dhnt.io cosmetic** | a signed-in person shapes their own desktop — layout, tiles, look, settings — by hand, **by speaking**, or by typing, with undo and a stated allowance |
| **B** | **outpost** | that person attaches one machine and sees its apps as tiles and its files in reach; **their** machine then transcribes their voice and serves their wishes, so the allowance stops mattering |
| **C** | **app** | they make something of their own — a blog, a page — shape it through the real candidate ladder, and share it with family or teammates who may change what the feature list allows |
| **D** | **satellite** | they stand up their own front door, move their desktop behind it, invite a partner and publish to the world, and **nothing they built has to move** |

Phase A carries voice because a desktop you can only type at is not the
demonstration: *asking* is the point. It is affordable there precisely because
the free tiers of voice are the ones that need nothing installed.

### Voice is not a side quest: its tiers are the rungs

This is the alignment that makes voice cheap in phase A and meaningful in phase B:

| Voice tier | Who recognizes the speech | Arrives at |
|---|---|---|
| 0 — the operating system's own dictation into the wish box | the person's device, free, no install | **phase A** (works today) |
| 1 — the browser, on-device (`processLocally`) | the person's browser, free, desktop only | **phase A** (built: Sprint 624 V2, to vendor into the desktop) |
| 2 — **their own host transcribes** | the machine they just attached | **phase B** — Sprint 624 V3, V4, V7 |
| 2b/3 — a mesh GPU node, or a hosted provider by explicit opt-in | their own satellite or a provider they chose | phase D — Sprint 624 V5 |

So the free desktop can already be spoken to, and attaching a machine is what
makes voice *better* — the same sentence, now recognized on hardware the person
owns. The journey teaches the architecture by making each rung pay.

## When the desktop itself becomes code-shapeable

Phase A shapes the desktop through a **declared schema and a property
document** because that needs no source tree and no per-person build. That is a
scoping choice, not a law.

**Operator direction (2026-11-14): the dhnt.io / periscope UI stays
proprietary, and its source is made available to users of dhnt.io only** — not
open source, and not a public repository. If the shaping engine can read it
*for that user*, the desktop stops being property-shaped and becomes an
ordinary shaped app: candidates, verification, preview, approval, per-principal
versions, the lot.

What that costs, stated plainly, because it is the reason it is not phase A:

- a candidate is **built per principal**. For a browser bundle that means an
  `npm`-class build per person per candidate, where the hosted plane today
  serves one embedded bundle to everyone. That is a build farm, not a feature
  flag.
- the engine must have the source **where it builds**. Since the source is
  user-only and proprietary, it is delivered through the person's own
  authenticated plane — the registry and catalog machinery that already serves
  apps — and built there. Which is exactly what phase D gives them.
- the licence has to say what a user may do with it: read and shape **for their
  own use**, no redistribution, no fork-and-compete. That is a legal drafting
  task, not a design one, and it gates the phase rather than this card.

So the sequence writes itself, and it is better than the shortcut:

| | who shapes the desktop | how | needs |
|---|---|---|---|
| phase A | anyone signed in | property patch against a declared schema | nothing new from the person |
| phase B/C | the same person, on their own machine | still properties, now served from their host | an attached machine |
| **phase D+** | a **dhnt.io user** on **their own plane** | **real candidates against the UI's source** | the proprietary source delivered to their plane, their own build, and a licence that permits personal shaping |

Three consequences worth holding on to:

1. **This is a licensing decision before it is an architectural one.** What
   shaping needs is that the *engine* can read the source for that user.
   Proprietary-and-user-only satisfies that, keeps competitive distance, and
   means the source ships through the authenticated plane rather than a public
   remote — so a phase-D mount for it is a members-only store, never a public
   GitHub repository.
2. **It makes phase D's "nothing moves" guarantee literal.** A person running
   their own satellite can serve their own desktop build, which is the vision's
   end state rather than a slogan.
3. **Public builds must never require private source**, and this UI is private
   by decision — so it lives outside the public workspace, nothing in the
   public repositories may depend on it, and the property path (phase A) must
   remain a complete experience on its own, for everyone, forever.

The recommendation is therefore to keep phase A as designed, and to treat
opening the UI source as the enabler of a later phase rather than a change to
this one.

## What exists, and what is new

Mostly assembly, which is why this is credible:

| Rung | Already exists | New work |
|---|---|---|
| 0 | the landing, OAuth2 (`google`, `github`), the badge design (Sprint 638 S2) | the badge on dhnt.io, the in-browser taste |
| 1 | the launcher and its tiles, the pooled `/v1/` gateway, per-principal semantics in the engine | the cosmetic schema, the property document, wish → validated patch, the CLI verbs, the ceiling |
| 2 | outpost pairing (once per machine), tunnels, grants, host tiles | the invitation, the ceiling lift when the person's own model serves |
| 3 | `bashy app new`, the whole candidate ladder, `website.bsh` (638 S3), promotion remote (638 S5) | the invitation, and the hand-off from property shaping to code shaping |
| 4 | circles and groups, app shares, the feature list (641 M4) | the member queue and approver (Sprint 640), one known share-wire defect (639 S14) |
| 5 | satellite provisioning, pooled models, invitations | the invitation, and the "nothing moves" guarantee |

Three things are genuinely new: **the cosmetic schema and its document**, **the
journey state**, and **the continuity guarantees** between rungs (laws 1, 3
and 4). Everything else is already in the repositories.

## What each phase pulls in

The MVP spans all four phases. Only the current phase's stories are filed; the
later ones keep their designs on their home cards until their turn, which is the KISS half of this plan — a
board with thirty speculative stories is a plan nobody reads.

| Phase | Filed where | Already exists | Still to build |
|---|---|---|---|
| **A** voice + cosmetic | **Sprint 641 (now)**, with Sprint 624 V2 landed | the launcher and its tiles, OAuth2, the pooled `/v1/` route, per-principal semantics, and V2's voice module (`window.bashyVoice`, one dependency-free file in yoke's injected component) | the voice module **vendored into the desktop's own wish box**, the cosmetic schema, the property document, wish → validated patch, the verbs, the allowance, the journey state |
| B outpost | 624 (`V3`, `V4`, `V7`), 639 (`S1`, `S4b`, `S15`) | pairing once per machine, tunnels, grants, host tiles, `bashy transcribe` | the invitation, tiles from the attached host, the ceiling lift, host transcription admitted |
| C app | 638 (`S1`, `S3`, `S5`, `S6`, `S9`), 621 (`T1`, `T4`), 617 (`P4b`), 641 `M4` | `bashy app new`, the whole candidate ladder, circles and shares | the hand-off from property shaping to code shaping, the feature list, the upstream ladder |
| D satellite | 639/640 and a card of its own when its turn comes | satellite provisioning, pooled models, invitations, member attachment | the invitation, the "nothing moves" guarantee, mesh/hosted voice (624 `V5`) |

Two rules hold across the boundaries, and they are the ones to defend in
review: **nothing a person made in an earlier phase is lost or migrated in a
later one** (law 3), and **each phase ships end to end** — a half-rung is
worse than no rung, because the invitation at its end would be a promise the
product does not keep.

## Open decisions

Settled by the detail above: the document lives in the hosted plane at rung 1
and is portable by format (decision 1); a satellite owner sets the **default
layer only**, never the schema (decision 2); and a rung-0 taste persists if the
person signs in afterwards, because law 3 requires it (decision 5).

Left for the operator:

1. **The free ceiling's number**, and whether it resets daily or is a one-time
   allowance for the first session. A refused patch still consumed a model call,
   so it counts — and the refusal must say so.
2. **Which rung-2 gain leads the invitation**: own apps as tiles, own files in
   reach, or no wish ceiling. The last is the most honest and the least
   inspiring; the first is the most tangible.
3. **How much of the desktop's own chrome is in the schema** — only the tile
   field, or the header and navigation too. More is a better demonstration and
   a larger invariant surface to defend.
