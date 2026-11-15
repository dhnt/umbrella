# Sprint 639: Trove, a shaped content space, one tree for agents and humans, presented on the fly

Sprint UUID: `59409a5a-4d63-513c-af53-8f97cf8be185`. Epic: software-shaping.
Status: **planning only**, filed 2026-11-14 and reworked the same day on the
operator's framing; no implementation started, no manager appointed. Design
of record: `trove-content-app-design.md`. The sprint card and its stories are
authoritative.

## Operator framing (2026-11-14)

The trove is a **general app for every bashy user**: own an agent-friendly
content space, let members and agents contribute content into it, and shape
the app into any form. The two scenarios (a web page becomes a note for
someone; members contribute project submissions and each consumer sees their
view) are **test cases**, needed within weeks, not the product; no story is
derived from them alone. Rod, not fish, and software shaping apply to the
trove as to every bashy app: small `--json` verbs, flows as short Bash#
skill-scripts, every surface a shaping hook.

## Primary goal

Every bashy user owns a trove: they mount the content they have access to
(local directories, hosts behind outpost, git and GitHub, Google Drive, the
artifacts agents produced), members and agents contribute into it under
grants, agents walk it with `trove ls|find|stat|cat --json` and humans with
the explorer page, any entry is presented on the fly in the form a reader
needs, and the app itself takes any shape through its views, presenters and
source adapters.

## What the code showed (2026-11-14)

- A shaped app is a `.bsh` skill-script in `bashy/examples/<job>/` with an
  app tree (`contract.bsh`, `checks/`, `shaped.json`, `public/`) registered
  through `bashy app add --type shaped`; the console serves it per principal
  and `go build`s `server.main` itself.
- The `files` catalog app is outpost's embedded File Browser: one scope
  directory per host, host-only writes, no CLI. A single-host browser, not a
  tree over many sources, and nothing in it lets a member contribute.
- A read-only tree seam exists: `yoke/pkg/lens/provider` (`List/Stat/Open/
  Edges` over `ref.Locator`, node schema `bashy-node-v1`) with `dir:`,
  `dir:<path>@<host>` over outpost sftp, `git:`, archives and more;
  `bashy lens -t listing` and `bashy tree --json` print it. Its recipe
  registry admits only `oci` and `k8s`, so a new scheme inside `lens` is a
  core change; `ref.ParseLocatorWithSchemes` is the hook.
- Content verbs exist for every requested source: `google.bsh` (drive,
  gmail, calendar over gws bring-your-own-project) with `email.read`,
  `drive.read` and `email.send` rods, `bashy gh`, pure-Go git,
  `bashy fetch URL --md`, `lens` document conversions.
- Generation runs through the service doors (`text`, `translate`, `narrate`,
  `transcribe`, `image.generate`, `video.understand`, `pdf.read`, …) with
  oss, browser and api routes; `spend` and `send` need `--yes`.
- Grants exist per app (outpost pulls `{host, owner, revision, members[{email,
  circle}], groups{}, apps{app: [rule]}}`; rule = circles AND (group OR
  email); owner always passes; no rule = owner only) and per shaped app
  (`@reads/@writes`); no per-resource grant exists. Agents act as a
  principal capped by effects.
- Circles: one owner-chosen slug per member per owner (defaults family,
  friend, team, guest; `public` and `owner` reserved), groups many-to-many,
  membership mutual, the label private to the owner. An app behind outpost
  receives only the email and `admin|user`: no header carries the circle or
  groups. `outpost apps share` still posts the pre-S619 `{app, circle}` body.
- Shaping levels (owner, member, public) are design only (Sprint 638 S6).

## Stories

Tags: example (bashy/examples custom command), core (yoke change, small and
separate), test case, docs. Vendor is the planned assignment by strength;
the conductor may reassign. Every verb: `--json`, `--dry-run` where it
writes, exit 0/3/1; every flow a Bash# skill-script.

| # | Story | Tag | Vendor | Acceptance |
|---|---|---|---|---|
| S1 `804b7d9720e0` | `trove.bsh`: `trove.json` mounts; `mount add\|ls\|rm` for `dir:`, `dir:@host`, `git:`; `ls\|find\|stat\|cat` emitting `bashy-node-v1` rows with trove attrs; `register.sh`, `contract.bsh`, `checks/`, synthetic fixtures | example | codex | rows pass the `bashy-node-v1` validation of `provider/recipe_test.go`; `trove cat` of a peer-host file equals `lens` output; unknown mount is not-found; checks green under `bashy shape verify trove` |
| S2 `cfd94ff64758` | `trove present --as FORM [--for AUDIENCE]`: presenters hook (`presenters/*.bsh`, `presenters.json` as shaped property), render cache with provenance, oss route first, `--yes` for paid, `--dry-run` plan | example | glm | dry-run names rod, route and cost class; second call is a cache hit; a `presenters.json` override changes the output; a canned render serves with no model call |
| S3 `0123321b5e80` | contribute: `trove add SRC --to MOUNT` (URL, file, stdin, `app:` artifact) and `trove put` by the owner, a member or an agent with a write grant; provenance on every contribution | example | claude | a member's contribution shows the member's provenance; an agent's carries `producer: agent`; a URL ingests as markdown; no write without a grant; `--dry-run` writes nothing |
| S4 `8b68afbe2486` | `drive:` and `gh:` mounts (read-only) over `google.bsh` and `bashy gh` or pure-Go git; account bound per mount; hermetic fakes | example | glm | `trove ls trove:drive/` and `trove:repo/` list and `cat`; tests need no live account; one live smoke recorded by the operator |
| S5 `a5386752ad57` | `app:` artifacts mount: viewer books, notepad items, kb pages, film drafts, run evidence with `producer: agent` provenance and `app:<command>/<id>` refs | example | claude | each kind lists; every ref resolves through `bashy <cmd> show`; read-only |
| S6 `c68cc7fee4df` | circle-protected mounts: per-mount rules in cloudbox's grammar `{mode, circles[], groups[], emails[]}` evaluated by trove from the caller's stamped relationship (web) or `outpost grants lookup` (CLI); `trove share\|who`; `anonymous: true` flag; owner-defined circle picker; label never shown to members | example | codex | matrix owner, member in circle, in group, by email, not matching, anonymous × read, write identical on CLI and HTTP; a member in a listed group but outside every listed circle is refused; `--circle '*'` admits every mutual member and is sent as the empty list; a rule naming no circle is refused as ambiguous; a circle rename changes access on the next request; refusals name mount and rule |
| S7 `a8114a7882e8` | explorer page: kit-based Go server registered `--type shaped`, rendered from `views.json`; mounts tree, entries, preview, **Present as…**, **Contribute**, provenance strip; parity rows; `publish-outpost` | example | glm | kit contract test and browser test pass; every page action has a parity row; `bashy shape verify trove` green; a member sees only granted mounts |
| S8 `c0753c515485` | shapeable in all forms: `views.json` (list, gallery, cards, timeline), presenters and source adapters as shaping hooks exposed in `shaped.json` with Genie examples; wish, verify, preview, approve, undo walkthrough as a member | example | claude + glm | the Shapeable-with-Bashy checklist holds; three shaped variants (view, presenter, adapter) verified and undone with evidence; every hook is a file or verb, never Go |
| S9 `4e7c4e50d3f4` | media presenters `--as audio\|poster\|video` via narrate, image and media rods; gate-host-only, the dev box prints the plan and exits 3 | example | glm | the gate host produces artifacts with provenance; the dev box refuses by name |
| S10 `9482e3dad022` | core seam: external recipe admission in `yoke/cmds/lens` (`recipes.json` scheme → argv, `ParseLocatorWithSchemes`); oci and k8s unchanged | core, small, optional | codex | `bashy lens -t listing trove:local/` and `tree` work through the recipe; unregistered scheme still exit 3; lens tests green |
| S11 `184437ad9827` | docs: README with embedded skill, kb runbook (owner and member wording), parity rows, catalog row, index entries | docs | muse | reviewed; scrub gate clean |
| S12 `bc61abf0372b` | `mail:` and `cal:` mounts (p2): Gmail threads and Calendar events as read-only entries | example | glm | `trove ls trove:mail/` and `trove:cal/` list; `cat` returns markdown; hermetic fakes |
| S13 `0eaeb7a534e6` | outpost stamps the caller's relationship (`X-Outpost-Circle`, `X-Outpost-Groups`, `X-Outpost-Owner`) for trust-identity apps on tunnel requests from the grant copy, signed (versioned payload), inbound copies stripped; `outpost grants lookup EMAIL --json`; `coopauth.Identity` gains Circle, Groups, IsOwner; cooperative-web-apps doc | core (outpost + yoke), small, separate commits | codex | stamp/strip/sign/verify and lookup unit tests; through the fake tunnel a member sees the three headers and the owner `X-Outpost-Owner: true`; LAN requests carry none; `Remote-Groups` unchanged |
| S14 `ef2ce499a64a` | outpost bug: `apps share\|unshare\|shares` on the post-S619 grant-rule body `{app, circles[], groups[], emails[]}`, repeatable `--circle\|--group\|--email`, unshare by id; root cause recorded (S619 changed the wire, the consumer was not updated) | bug (outpost), small | codex | fake-server test red then green; `share APP --circle family` creates a rule row and `who` lists the circle's members |
| T1 `b6f470b97515` | test case i (p2, within weeks): one skill-script composes `add`, `present --as note`, and the email door as a draft, then one send with `--yes`; first instance the AP CSP redesign page for a teacher | test case | claude | reproducible from the one script using only S1–S3 verbs; no send without `--yes`; zero spend; ids recorded, recipient by role |
| T2 `4501a612cf71` | test case ii (p2, within weeks): members contribute synthetic submissions; the owner shapes a `review` presenter (transcribe, video.understand, text against the group's scoring guide); grants give staff, contributors, the public their views; first instance a film-making club | test case | claude + glm | four principals see the expected subsets on CLI and explorer; scores labelled as presenter output; the presenter shaped, verified and undone through `bashy shape`; media evidence from the gate host |

## Lanes and dependencies

- Lane A (smallest delivering slice): S1 → S2 → S3.
- Lane B (after S1): S4, S5 in parallel; S12 after S4.
- Lane O (outpost, independent, early): S14 → S13; S6 after S13 and S14.
- Lane C: S7 after S2, S3 and S6; S8 after S7.
- Lane D: S9 after S2.
- Lane E: S10 independent of every other lane (core, optional).
- Test cases: T1 after S3; T2 after S6, S8 and S9. Both p2, needed within
  weeks of the product lane.
- S11 trails every lane.

## Gates and venues

Per story: its own acceptance plus `bashy shape verify trove` (checks run in
the scrubbed verifier), `GOWORK=off go build ./...` in bashy for Go pieces,
the kit contract test for S7, hermetic tests for S4 and S12, `go test -short
./...` in outpost and `go test ./pkg/coopauth ./pkg/fleet/...` in yoke for
S13 and S14 (the fake tunnel and the cloudbox fake), and the scrub gate
always. Venues: unit tests, headless Chrome and the oss text and
translate routes (ollama) on the dev box; heavy media (S9, T2 media stages)
only on the claimed GPU gate host through `bashy claim`, never the dev box,
never the shared release host, no hosted CI. Fixtures are synthetic and
public; no personal data enters the repository.

Close: S1–S8, S13 and S14 accepted; T1 and T2 pass as acceptance tests of the general
verbs; parity rows merged; the yoke pin bumped only if S10 lands.

## Verification

1. **Product.** As the owner: mount a local directory and a peer host, list
   and `cat` through `trove`, contribute a URL and a file, present an entry as
   a summary and in another language (dry-run, then oss route), share a
   mount with a member; as that member: see only the granted mount,
   contribute, present; move that member to another circle on the member
   list and watch access change on the next request; as a member outside
   every rule and as anonymous: not-found. Then shape a view, a
   presenter and an adapter as the member; verify, approve, undo; the owner's
   trove unchanged. Record on S1–S8.
2. **Test case i** (T1) and **test case ii** (T2) as written on their
   stories, each from its one skill-script.

## Decisions

Taken by the operator on 2026-11-14: the name is **trove**; the trove is a
general app and the scenarios are test cases filed at p2; S10 is included as
an optional, separately committed core story; `mail:` and `cal:` are a p2
story in this sprint; per-entry visibility rules stay out of the product
model (a shaped grant rule per trove when a test case needs one). "Mount" is
the working word for a source until a reason appears to change it.

Recommended on 2026-11-14 after the circle study, for the operator to
confirm: content is protected by circle with **one rule grammar** (cloudbox's
`{circles[], groups[], emails[]}` plus `mode`), **two enforcement points**
(edge and outpost admit the app; the trove evaluates mount rules) and the
**relationship stamped by outpost** (S13) with an on-host lookup for the
CLI. Alternatives weighed in the design of record: one outpost app per
mount, per-resource grants in cloudbox, the trove reading the member list
itself, reusing `Remote-Groups`.

Operator note 2026-11-14, recorded as an invariant: **the circle is the
hard boundary**. Groups and emails narrow access within a circle and never
widen it across one; a member in a listed group but outside every listed
circle is refused; `family` content is never reachable from `company` and the
reverse. The wire's empty `circles` list is the special circle "every
member", the opposite pole of owner-only; bashy spells it explicitly as `*`
(`--circle '*'`, shown as "every circle (all members)", sent as the empty
list) and refuses a rule that names no circle as ambiguous. Ladder: no rule
(owner only) → named circles → `*` → `anonymous: true`. The same explicit
spelling for `bashy share add` and `bashy suite share` is a family-wide
follow-up outside this sprint.

## Not doing

Per-path access lists; writes to mail, calendar or GitHub; a FUSE mount; a
second text editor; replacing the `files` app; a core permission policy;
per-entry visibility rules in the product; per-resource grants in the hosted
plane; wish-log replay; index or
embedding search; real personal data; paid finals without `--yes`; agent
principals. Each is listed as a follow-up in the design of record.
