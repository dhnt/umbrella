# Shaping offers: who an offer reaches, and a page released with its components

Design record, 2026-11-24. **Proposed; operator review pending.** No code
changes until the review; implementation becomes Sprint 683 stories after it.
Input to Sprint 705 S3 (the page-plus-components model). Answers Sprint 683
open decisions 3 and 4 (`docs/sprint-683-master-execution-plan.md`) and covers
bug `33807374`.

Access model it builds on (`docs/access-tiers.md`, Sprint 710): a satellite
admits members, who join only through the owner's invite. Anyone else, anonymous
or a logged-in non-member, gets only what the owner publishes publicly, as
anonymous. Owners share apps, singly or as a suite, by grant rules that name
circles, groups or emails.

## Code inspected (umbrella main, 2026-11-24)

- `yoke/pkg/src/offer.go`: `Offering{To []string, All bool}`. `Offer` pushes
  a notice to each eligible principal at offer time: `--to` names them; `--all`
  is `allKnownPrincipals`, meaning every principal with a version line or a
  `shape/<app>` directory on this host. `isVisible(offer, "")` returns
  `offer.All`, so an empty principal sees every `--all` offer (`33807374`).
- `bashy/internal/agentos/mcp_site.go`: the site MCP resolves the caller from
  the verified outpost relationship stamp. It sets `Principal` (email,
  `visitor:<pseudonym>` or `anonymous`), `Tier`, `Circle` and `Groups`.
- `yoke/pkg/shape/appserver/manifest.go`: `Audience{Circles, Groups, Emails}`
  with `AdmitsMember(circle, groups, email)`: circles AND (groups OR emails),
  where an empty audience admits nobody. This is the grammar of cloudbox grant
  rules, already used for the Sprint 706 `bashy shape scope` (edit/shape scopes
  in `shaped.json`).
- `yoke/pkg/src/release.go`: a release is a semver tag on one app's src repo.
  Without `ReleaseOptions.Shared` the tag is principal-private
  (`vX.Y.Z-<principal slug>`), and `visibleRelease` hides it from every other
  principal. bashy's `shape release` (`shape_local.go`) never sets `Shared`.
  `Offer` resolves the version as the empty principal
  (`versionOf(r, rev, "")`), so it can see only shared tags. **Hypothesis
  for D4 `90f03f54`** ("offer refuses a released version"): the release is
  private to the releaser, so the offer cannot see it. It must be reproduced
  and recorded on D4 before any fix.
- `bashy/examples/desk/page`: blocks reach sibling engines by address
  (`VIEWER_ADDR`, `NOTEPAD_ADDR`, `BRAINSTORM_ADDR`, `PAGE_BRAINSTORM_URL`).
  `contract.bsh` is only an effects cap. No version of a component is pinned
  anywhere. `state.Feature.Requires` is a dependency between features of the
  same app, not between apps.

## (a) Who an offer reaches

### The gap

An offer's audience is a list of host-local principal names. It is unrelated
to who the app is shared with, so an offer can reach someone who has no access
to the app (a stale principal, a visitor pseudonym, `anonymous`), or miss a
member of the circle the app is shared with. `--all` means "every principal
this host has seen", not "my members". The empty principal sees `--all`
offers.

### Alternatives

1. **Keep `--to`; check each offer against the share.** The host does not
   hold the share rules (cloudbox does). A check would need a cloudbox call
   for every listing, and could not work offline. Rejected.
2. **Offer audience = the grant-rule audience, checked at request time.**
   Store an `Audience` on the offering and check it against the caller's
   verified member stamp (circle, groups, email) whenever offers are listed or
   adopted. It is the same grammar as sharing and as `shape scope`, and the
   same flags as `outpost apps share` (Sprint 710 H1). It is members-only by
   construction, because only a `member` (or the owner) stamp is ever matched.
   **Recommended.**
3. **Offer to a suite.** The stamp carries circle and groups, not suite grants.
   The host cannot resolve "whoever this suite is shared with" without
   cloudbox. The owner gets the same effect by naming the circle the suite is
   shared with. Deferred; not needed for the MVP.

### Proposal

- `shape offer APP REV --circle C --group G --email E` (repeatable) stores
  `Audience` on the `Offering`. `--to PRINCIPAL` is kept for exact principals
  (the owner's other devices, a named member) and is also members-only.
- **`--all` means every member of this owner**: relationship `member` in any
  circle, plus the owner. It never includes `anonymous`, `account` or
  `visitor:*`. That fixes `33807374`: `isVisible` returns false for an empty
  principal and for any non-member relationship, before it looks at `All`.
- **Notices are pulled, not pushed, for audience offers.** The host cannot
  list a circle's members offline, so `ListOffers` and `Notices` check the
  audience for the calling member at request time. `--to` keeps the existing
  push notice.
- Visibility is checked where the stamp is known: the site MCP (the member's
  own machine, Sprint 709), the shaped app's web surface, and the CLI on the
  host (the owner). A member who leaves the circle stops seeing the offer at
  once. Their app access goes with the share anyway (Sprint 710 H6 records the
  bound for revocation to take effect).
- Only the owner (or a named maintainer) creates and withdraws offers;
  `Offer` already takes the creator, and the story verifies that it is
  enforced.
- **Offers publish shared releases only.** An owner's `shape release` is
  app-wide (`Shared`) by default. A member's self-repair stays
  principal-private. This aligns with the D4 root cause once it is confirmed.

### Compatibility

Existing offering JSON (`to`, `all`) still reads. `audience` is a new optional
field. `--all` is narrowed from "every known principal" to "every member". It
changes behaviour only for anonymous, visitor and stale principals, which is
the bug. The `To`-based push notices are unchanged.

## (b) A page and its components released as one pinned set

### The gap

`shape release APP REV` releases one app. A page embeds form, viewer and
brainstorm blocks served by other apps, and nothing records which versions of
them a page release was verified with. A member who adopts the page can end
up with a component version the page never ran against.

### Alternatives

1. **The suite is the version unit.** Suites live on cloudbox, which holds
   relationship data only (strings, no app state), and a suite may span hosts.
   Versions live in each app's src repo on its host. A suite is an access
   unit. Rejected.
2. **The page release pins its components.** At release time the page records
   the shared release of each component it embeds on the same host (for
   example `requires-app: form@v1.2.0`, as tag trailers next to `Kind`). It
   verifies against exactly those versions and carries the pins into its
   offer. **Recommended.**
3. **No pins; tolerate versions through the contract at run time.** Simplest,
   but it does not meet 683's acceptance ("the page release pins the
   component versions it was verified with"). Rejected for 683; this stays the
   behaviour for components on other hosts (below).

### Proposal

- `shape release page REV --with form,viewer,brainstorm` resolves each
  component to its latest **shared** release on this host. It refuses if a
  component has none, naming the release command to run first. It writes the
  pins as tag trailers and runs the page's checks against those component
  versions.
- `shape offer page` carries the pins. `shape adopt page --preview` lists the
  member's active version of each pinned component. `adopt` refuses while a
  component is older than its pin, and names the component offers to adopt
  first. Auto-adopting components is a later step, not the MVP.
- **Suite and pin by convention, not by check.** The owner shares the page and
  its pinned components as one suite with a circle (Sprint 710) and offers the
  page to that circle. The host cannot see suites, so release does not check
  suite membership. The kb runbook (683 O2) teaches the pairing.
- **Same host only.** A component on another host is referenced through its
  contract, not pinned. Recorded as a limit.

### Compatibility

These are new optional tag trailers. A page release without `--with` behaves
as today. Other apps are unaffected.

## Non-goals

Offer and adopt in the web console (683 decision 1, separate). Offers across
owners. Suites as version units. Pinning across hosts. Auto-adopting
components. Any cloudbox change: none is needed, because the stamp already
carries circle, groups and email.

## Stories after the review (all Sprint 683)

| Story | Scope | Depends on |
|---|---|---|
| D4 `90f03f54` | reproduce, record the root cause (hypothesis above), fix in its own commit | none |
| `33807374` | reproduce, then the members-only `isVisible` (part of O3, or first if O3 waits) | none |
| O3 offer audience | `Offering.Audience`, `--circle/--group/--email`, `--all` = members, pulled notices, site MCP and CLI parity; yoke `pkg/src` and bashy | D4 |
| O4 page release pins | `--with`, tag trailers, verify against the pins, adopt refusal; yoke `pkg/src` and the bashy page | D4, O3 |
| O1 (existing) | the e2e then shares the page suite with a circle and offers to that circle | O3, O4, Sprint 710 H6 |

Each story closes on its own unit tests on the gate host. No release.

## Decisions for the operator

1. Offer audience by grant-rule audience (alternative 2), with `--all` meaning
   every member?
2. Page release pins components on the same host (alternative 2), with suite
   pairing by convention?
3. An owner's `shape release` is app-wide (shared) by default, once D4's root
   cause confirms the hypothesis?
