# Sprint 641: the feature × audience matrix

> **Updated 2026-11-14 (operator).** Two changes run through everything below.
> **(1) Identity is mandatory**: every person who shapes anything signs in with
> their email through OAuth2, so the "public / guest" column is now a
> *read-only visitor* and every allowance keys to an account, not a browser.
> **(2) The hosted surfaces are rung 1 of the journey**, not out of scope: the
> periscope desktop and the cloudbox console are shaped through a **declared
> cosmetic schema and a per-person property document**, not through code
> candidates — see `docs/dhnt-journey-design.md`, which supersedes Surface C
> below. Surfaces A and B remain the rung-3 and rung-4 picture.

Companion to `docs/sprint-641-master-execution-plan.md`. It answers one
question per cell: **what may this audience change here, and what is the
app's contract.** The matrix is the content of story M4 (`928fb2c3584e`),
expressed in `shaped.json` `features`, and of the invitation's wording in M5.

## Refusals demote; they never dead-end (operator, 2026-11-14)

When a wish needs more privilege than the person has, the answer is **not a
bare refusal**. The wish is **demoted** into something that can still travel:
a request to whoever may act on it, or feedback to the people who make the
product. The person's words are never thrown away, and nothing pretends to
have succeeded.

This is already the house rule elsewhere: the message bus states it as
**DEMOTE, NEVER DROP** — an unauthorized, rate-limited or undeliverable
interrupt becomes a queued notification with a recorded reason, because a
dropped message leaves an agent acting on stale assumptions. The same reasoning
applies to a person: a dead-ended wish leaves them believing the system cannot
do something, when the truth is only that *they* cannot do it here.

| What was asked | What it demotes to | Who receives it |
|---|---|---|
| beyond this person's level on this app | a **request** carrying their words, the page and element, and who asked | the owner, or a named maintainer |
| configuration-only surface asked for a code change | a **request** | the owner |
| beyond the **owner's** reach — the invariant floor, the chrome laws, the wire | **product feedback** | staff, and only with the person's explicit consent, because it leaves their plane |
| allowance exhausted | a queued request, or a stated wait with the time | themselves |

Five guardrails, because a demotion is a privilege boundary and not a courtesy:

1. **A demotion performs no part of the privileged action.** It records words,
   never effects. This is what keeps it from becoming a bypass.
2. **The request carries its requester**, and when an owner or an agent later
   acts on it, the text is **untrusted data** — the prompt-injection discipline
   from the voice research applies unchanged.
3. **Requests have a ceiling too.** Asking for the impossible must not be a
   free spam channel; the same per-person allowance applies, even when no model
   was called.
4. **Identical wishes aggregate** rather than arriving fifty times — the queue
   with upvotes that Sprint 640 designs, not fifty rows.
5. **Nothing leaves the person's plane without consent.** A request to their own
   owner stays inside it; product feedback to staff is an explicit act with a
   visible destination.

The person always learns three things: what happened, where it went, and how to
see what became of it.

## Roles are the CMS roles (operator, 2026-11-14)

Nothing here invents a role model. A content management system solved this
twenty years ago, and the classical separations are the ones we need: **content
is not configuration is not code**, *writing* is separated from *publishing*,
core files are not edited in production, and every change is a revision you can
roll back. Shaping changes who does the editing — an agent, from a sentence —
not what may be edited by whom.

So the defaults are the familiar names, and they are **bundles of capabilities**
rather than a fixed ladder, so an owner can redefine them the way they already
define their own circles:

| CMS role | here | capabilities |
|---|---|---|
| anonymous | **visitor** | read |
| subscriber | **signed-in user** | read · personalize their own view |
| contributor | **member (contributor)** | propose content; cannot publish → a request |
| author | **member (author)** | create and publish their *own* content |
| editor | **maintainer** | publish and manage everyone's content |
| administrator | **owner** | configuration — appearance, settings, the feature list — and content |
| super admin | **staff** | code, releases, the invariant floor |

What we inherit, deliberately and by name:

1. **Content / configuration / code separation** — exactly the three tiers of
   the public-facing rule below. A CMS lets an editor change pages and a
   builder change settings, and keeps plugin and theme code out of both.
2. **Separation of duties** — a contributor writes, someone else publishes. Our
   candidate is their *unpublished revision*, and `approve` is *publish*.
3. **Don't edit core in production** — a CMS disables the file editor on a live
   site; our equivalent is the protected rows and the release path, and it
   binds staff too.
4. **Revisions with rollback and an audit trail** — we already have numbered
   revisions, `undo`, and the room timeline as the log of who changed what.
5. **Appearance permissions are their own thing** — a CMS separates theme
   settings from content rights, which is why "personalize" is a mode and not a
   weaker kind of shaping.

Where we differ is only in *how* a change is authored and proven: the editor is
an agent working from a sentence, and the gate is a verifier rather than a
human reviewer's taste. The permission model is the boring, proven one.

## The public-facing rule (operator, 2026-11-14)

**On a public-facing surface, a principal who is not the owner or a named
maintainer may change declared configuration only.** Not as a convention — as a
declaration the engine refuses to violate.

| Who | May change | How |
|---|---|---|
| anyone else (visitor, guest, member) | **declared configuration** | a property patch validated against the schema; it cannot change code, routes or behaviour |
| a member contributing **content** | content, under moderation | a contribution path, never a code candidate |
| owner / named maintainer | **code** | the ordinary candidate → verify → approve → release path |

A wish beyond configuration is never refused into a void: it becomes a
**request** for the owner (law 5 of `docs/dhnt-journey-design.md` — no dead
ends).

Why it is a rule and not a preference:

1. a public page is the one surface where a broken candidate is seen by
   strangers and by search engines;
2. a visitor's wish is untrusted text, and configuration-only means the worst
   case is an invalid patch rather than agent-authored code — the 2026 CVEs
   behind this concern were injected text hijacking coding agents;
3. no per-visitor build, so cost and latency stay bounded however many people
   try it;
4. legal copy, accessibility obligations and regulated claims stay invariant by
   construction, not by vigilance;
5. "only what the owner declared" is **checkable against a schema**, whereas
   "they may shape, but we deny the dangerous paths" is a policy that has to be
   right every time.

**Enforcement point.** `shaped.json` carries a `public: true` marker, and the
manifest parser **refuses a policy that grants a non-owner `shape` mode on a
public-facing app**. Fail closed at declaration time — in review, when someone
edits the manifest — rather than at wish time in production. It sits beside the
validations that already refuse unknown keys and bad placements.

**The twin obligation.** Configuration-only shaping is exactly as expressive as
the schema. A public-facing app that declares three properties makes a hollow
invitation, so "has this app declared enough to make *try it* honest?" is a
review question for every public surface.

## The four modes

The vocabulary is the one 638·S6 already defines, plus one word that is not
shaping at all.

| Mode | What happens | Cost |
|---|---|---|
| `personalize` | the viewer changes **declared properties only** — theme, density, type scale, order, which panels show. Stored per viewer, applied through `data-*` attributes and CSS variables. **No candidate, no agent call, no source change.** | free |
| `shape` | the full ladder: wish → candidate → verify (Red then Green) → preview → approve. The result is **that principal's own version**; everyone else keeps the base. | an agent call |
| `request` | the wish is recorded for the owner and **nothing is built**. | free |
| `off` | refused, with the feature named. | — |
| `manage` | not shaping: add, remove, share or retire an **app**, through existing CLI verbs. | free |

## Where the source lives decides what is possible

| Surface | What it is | Shapeable? |
|---|---|---|
| **A — the showcase site** (ai.dhnt.io) | a shaped app, source in its own repo, built by the verifier per principal | **yes** — this is the MVP's home |
| **B — apps on the owner's own host** behind outpost | registered shaped apps on that person's console | **yes**, and app membership is `manage` |
| **C — the hosted SPAs**: periscope launcher (`/periscope/`), cloudbox console (`/cloudbox/`) | prebuilt bundles embedded in the private hub binary (`hub/web/dist/ui`, `hub/internal/server/routes_spa.go`); the namespace is locked in `hub/internal/reserved/reserved.go` | **no, not in this MVP.** No source tree here, no per-viewer preference store and no tile-layout entity exist in the hub today |

That third row is the load-bearing finding. "Personalize the periscope tile
layout" cannot be a shaping candidate: there is nothing for the engine to build.
It is **data** — a preference document the SPA reads — and adding it is a
cloudbox change behind the public wire contract, not engine work. Filed
separately so it can land in parallel; the MVP does not wait on it.

## Surface A — the showcase site

| # | Feature (`covers`) | public / guest | member | satellite owner | dhnt staff |
|---|---|---|---|---|---|
| A1 | **the exercise target** — the small component each lesson is about (`public/exercise/**`) | `shape` · practice, quota'd, resettable | `shape` | `shape` | `shape` |
| A2 | **look of the page** — theme, density, type scale, panel order (declared properties) | `personalize` | `personalize` + `shape` | `shape` | `shape` |
| A3 | **lesson content** — copy, examples, the training path (`public/lessons/**`) | `off` | `shape` | `shape` | `shape` |
| A4 | **site chrome** — header, footer, nav, brand marks | `off` (theme only, via A2) | `request` | `shape` | `shape` |
| A5 | **the invitation flow** — the Shape link contract, `?page=`/`?element=` prefill, the routes behind it | `off` · **invariant** | `off` · **invariant** | `shape` | `shape` |
| A6 | **the app's contract** — `api/*.md` units, routes, flags, args, declared properties | `off` · **invariant** | `off` · **invariant** | `shape` (re-verifies the whole surface) | `shape` |
| A7 | **the policy itself** — `shaped.json` (features and levels), `checks/`, `contract.bsh` | `off` | `off` | `shape` | `shape` |

A1 and A2 are the demo. A5 and A6 are why a stranger can be trusted with it:
they are declared `invariant`, so the existing surface verifier
(`pkg/shape/verify/surface.go`) refuses a candidate that removes, renames or
re-routes them — and with M4 the refusal names the feature instead of the glob.
**"No API contract change" is literally A6 being invariant for guests and
members**, not a convention anyone has to remember.

## Surface B — apps on the owner's own host

| # | Feature | public / guest | member | satellite owner | dhnt staff |
|---|---|---|---|---|---|
| B1 | **app membership** — register, add, remove, retire an app (`bashy app add\|new\|rm\|set`) | `off` | `off` | `manage` | `manage` |
| B2 | **a shared app's look** — declared properties on an app the owner shared | `personalize`, only where the owner flagged it | `personalize` | `shape` | `shape` |
| B3 | **who may reach an app** — grants and circles (`outpost apps share\|shares\|unshare`) | `off` | `off` | `manage` | `manage` |

B1 and B3 need no new code for the MVP; the verbs exist. B3 carries a known
defect: `outpost apps share` still posts the pre-S619 body, tracked as Sprint
639 `S14` (`ef2ce499a64a`). Fix it there, not here.

## Surface C — the hosted SPAs (periscope, cloudbox)

| # | Feature | public / guest | member | satellite owner | dhnt staff |
|---|---|---|---|---|---|
| C1 | **periscope tile layout** — which tiles, order, size, labels | `personalize` ⟂ | `personalize` ⟂ | `personalize` + sets the satellite's default ⟂ | sets the product default, by release |
| C2 | **suite theme** — palette, font, density, inside the shared chrome laws | `personalize` ⟂ | `personalize` ⟂ | `personalize` + default ⟂ | by release |
| C3 | **cloudbox page content** — copy on the console and landing pages | `off` | `off` | `request` ⟂ | by release |
| C4 | **the suite chrome laws and the wire contract** — header/footer/icon/responsive rules, every `/api/` and `/v1/` shape | `off` · **invariant** | `off` · **invariant** | `off` · **invariant** | by release only, never by a candidate |

⟂ = **needs the hosted-plane change that does not exist yet**: a per-viewer
preference document plus a satellite default, exposed over the public wire
contract. Out of this MVP; filed as a cloudbox ticket so it can land in
parallel. Until it does, the honest answer on periscope and the cloudbox
console is "not yet", not a disabled button.

## The invariant floor — identical for every audience, staff included

Nothing in any cell can cross these, and a candidate that tries is refused:

1. the engine's own protected rows — the Genie component, the Shape page,
   sign-in, pairing, accounts, the terminal;
2. the declared surface — units, routes, flags, args, properties
   (`verify/surface.go`);
3. the effect cap the app declared in `contract.bsh`;
4. per-principal activation — one person's approved version never becomes
   another's;
5. the cloudbox wire contract (C4).

Staff change 1–5 by **release**, with the ordinary gates. Not by a wish. That
distinction is what keeps "staff can change everything" from meaning "staff can
shape past the verifier".

## The MVP cut, recommended

**In:** A1, A2, A3, A7, the invariant declarations A5/A6, and B1/B3 with the
verbs that already exist. That is the whole demo: a visitor practises on the
exercise and the look, a member improves a lesson, the owner runs the site and
its app catalog, and every contract refuses by name.

**Out, deliberately:** A4 `request` for members (needs a moderation queue — the
team-shaping queue on Sprint 640), B2 beyond what an owner flags by hand, and
all of Surface C's personalization until the hosted preference document exists.

**Not negotiable before the showcase is public:** the standalone p1
`d871ac00b808` — while `operatorSession` treats any non-device principal as an
operator, the guest and member columns of this matrix are not enforceable.
