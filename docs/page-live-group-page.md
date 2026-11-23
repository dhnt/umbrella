# Page: one fixed, live page for a group, shaped on demand

Design of record for the `page` desk app, filed 2026-11-23 as a planning-only
sprint in the software-shaping epic. The sprint card and its stories in
`docs/todo/` are authoritative for delivery order and acceptance. No code is
authorized by this page alone.

## Goal

A facilitator runs a meeting, a class or a workshop and needs, on demand and
while the group is present: one page everyone opens once, forms that collect
information, votes on decisions, a shared table, a timer, chat and demo
links, and a durable record afterwards. Today that is five bashy tools with
five URLs (a viewer export handed out as a file, a brainstorm LAN link plus a
private facilitator link, a Klatch client, a demo-queue binary, a
whiteboard), two identity models (cookie participants and console
principals), and a record typed by hand after the session.

The operator's framing: bashy must support this better, and this is what
software shaping was created for. `page` is one small app that composes the
engines bashy already has into one fixed page, reachable by the group on the
LAN and through the satellite, live, and shaped on demand by the facilitator.

## What exists (verified 2026-11-23)

Desk kit `bashy/examples/desk/kit` (stdlib Go, consumed by `replace`): stable
item id and `?id=` URL, owner key (`X-Facilitator-Key`), HttpOnly participant
cookie, atomic JSON store under `$BASHY_HOME/desk/<tool>/`, `POST /api/action`
/ `GET /api/state` / `GET /api/export`, the seven CLI verbs (`add open show
set list share close`), one server-side Markdown renderer with fences
(`render/`), the family look (`ui.go`, `kit.css`, `kit.js`), `outpost.bsh`
(`publish-outpost` → `outpost apps add NAME --url … --require-login` →
`<cloudbox>/matrix/h/<host>/app/NAME/`), `shaped.json` per app, loopback bind
enforced by `kit.CheckLoopback`, CSP `frame-ancestors 'none'`.

| App | Engine | Live transport | Audience |
|---|---|---|---|
| viewer | kit, read-only books, templates, HTML/PDF export | none | invite/join members |
| notepad | kit, Markdown notes, export pdf/png | none; revision counter only | invite codes |
| form | kit; fields, questionnaire rounds, `respondents: many` polls (`--poll`, `--results-visible`, `--close-at`, `--anonymous`), `wait` | none; CLI `wait` | owner key + `#invite`, `share` link |
| chart | kit, SVG charts | timed re-fetch | share/revoke |
| brainstorm | own Go server, LAN bind (recorded exception), cards, votes, rounds | 2 s polling | facilitator key, participant cookie |
| whiteboard | Excalidraw fork + Go collab service | Socket.IO long-poll, own merge | `#room` link behind the paired console |
| table | Grist fork + adapter (Linux only) | Grist's own | console pairing |
| klatch | external Databag server | its own | roster from `share who HOST/APP` |
| demo-queue | native Go over the outpost mesh | SSE | per-presenter invite |
| session | Bash#/Python + Go display | 3 s polling | owner/participant token links |
| meet (yoke) | rooms, poll, ask | SSE with `Last-Event-ID` resume (`yoke/pkg/meet/events_sse.go`) | invite/kick |
| website | Go proxy verifying the signed `X-Outpost-Relationship/-Circle/-Groups/-Visitor` stamp (`shaping/website/template/identity.go`) | HTTP | anonymous / signed-in / circle / owner |

Reach and identity today:

- **A fixed URL with identity exists only at the satellite door**
  `<cloudbox>/matrix/h/<host>/app/<name>/…` (outpost `cmd/outpost/apps.go`,
  grants in `outpost/internal/agent/grants.go`: a rule is circles AND (group
  OR email), pulled every 30 s). The path is stable even when the console
  picks the app's port. The signed identity stamp is applied only to tunnel
  requests.
- **The LAN has no identity and no app discovery.** mDNS advertises hosts,
  not apps; Neighborhood lists hosts only; `bashy app serve --bind` with QR
  device pairing is plain HTTP. Brainstorm and whiteboard keep a LAN default
  as a recorded exception.
- **No shared live layer.** Each app polls or has its own hub (demo-queue,
  kb-ui, meet). Nothing in the kit.
- **Sprint 684 G3 revisions are not started**: every desk app has only an
  integer `Revision++`.
- Nothing composes items from several apps; nothing exports a live session
  into a Markdown record.

Related planning, reused not duplicated: Sprint 682 consumer shaping of the
example apps (the `--type shaped` registration pattern); Sprint 684 the
group-shaping rod (desk-kit revisions, share with a role, Notepad proof);
Sprint 685 coverage (brainstorm round, poll roles, whiteboard co-edit);
Sprint 639 Trove (present-on-the-fly, explorer page); Sprint 689 shaping
sync; Sprint 677 independence rule (no command depends on another command;
sharing a library is fine).

## The model

### One page app, composed of the engines we have

The engines are not merged. `page` is one small desk app whose item is a
**fixed page**: Markdown written by the facilitator plus **blocks**, each a
live view over an item that an existing app owns. The page is the one URL,
one audience, one look and one record; form, brainstorm, viewer, notepad,
whiteboard, table, Klatch and demo-queue stay where they are with their own
CLIs, shaping and tests. Composition is over HTTP at run time; there is no Go
import between commands.

```
page item = markdown + ```block fences + audience + participants + revisions
block     = kind:ref   (poll:form-9f3a  form:form-…  book:sprint-537/p3
                         note:…  board:main  timer:t1  here  hands
                         embed:/whiteboard/?room=…  embed:/table/…  embed:<url>)
render    = kit renderer; block fences swapped for live block HTML
live      = one SSE stream per page: {item, block, revision}; the browser
            re-fetches only the block that changed; revisions, never merges
record    = page export --to md|html|pdf with every block's final state inline
```

Two block flavours:

- **native**, for desk-contract apps (form and poll, viewer book page,
  notepad note, brainstorm board, chart): the page server renders the block
  from the sibling's JSON API and forwards participant writes (submit an
  answer, cast a vote) with a per-participant cookie jar towards the sibling,
  so each page participant is one distinct respondent or voter there. One
  adapter pattern, because the apps share one action contract. Deeply
  shapeable: a wish restyles a block or adds a kind.
- **embed**, for engines with their own realtime (whiteboard, table, Klatch,
  the demo-queue projector, any URL): an iframe under the same console
  origin. Works on day one; needs `frame-ancestors 'self'` as a kit option.

Blocks that exist in no app today and are cheap in the page: `timer`
(facilitator start, stop, reset; visible to all), `here` (presence), `hands`
(a speaking queue, lighter than demo-queue), `table` lite (one row per
participant; the Grist table stays an embed for real spreadsheets), `follow`
(projector mode: participants' view follows the facilitator's section).

### Doors: satellite and LAN, both first class

| Reach | URL | How |
|---|---|---|
| same satellite or circle | `<cloudbox>/matrix/h/<host>/app/page/<code>` | `page publish-outpost` (kit `outpost.bsh`), `outpost apps share page --circle <group>`; members are known by the signed stamp; works in the room and from home |
| same LAN | `http://<host>.local:<port>/<code>` | `page serve --lan` with a fixed port: an explicit, logged guard with an escape hatch; anonymous participants join with a handle (below); the mDNS name replaces the address |
| this host | `http://127.0.0.1:<port>/<code>` | default |

Both doors serve the same item and the same SSE stream; a participant on
either door is one respondent. Full LAN identity (a mesh-to-HTTP bridge with
a caller stamp, app discovery over mDNS) is a separate outpost sprint.

### Join code: a short URL participants can type

Every page has a **join code**: short, lowercase, easy to say and type, two
dictionary words or four to six characters (`blue-fox`, `k7m2`), unique per
host, chosen by the author or generated. The code is the page's path on every
door; the long `?id=` form keeps working. `page open` prints both links, a QR
for each, and the code alone, so the facilitator can write one code on the
board and say "the class page, code blue-fox". The page root (`/`) is a join
screen: type the code, land on the page. A hosted short redirector would need
the hosted plane; it is a follow-up with the public wire contract only.

### Participants: who is this

On first visit the page detects the principal.

| Case | Handle | Identity key |
|---|---|---|
| **authenticated**: console principal, or the signed outpost relationship stamp on the satellite door | member name or email from the stamp; no prompt | the principal; address and client fingerprint are still recorded for OTel, logs and traces |
| **anonymous**: LAN door, or a non-member | the join screen asks for a handle: a name, an email, or a one-click random identifier | `<handle>@<client address>` for the session, corroborated by the kit participant cookie and a client fingerprint (user agent and accept-language hash) |

Rules fixed here, mechanics left to the implementation:

- The handle is **bound to the client address for the session**: the same
  handle from a different address is refused (or suffixed; the facilitator
  chooses in `shaped.json`); the same address with a lost cookie reclaims its
  handle, so a browser refresh never yields a second vote.
- The client address is the TCP peer on the LAN door, and the forwarded
  client address only when the request arrives through the trusted tunnel
  (outpost stamps it); otherwise every satellite participant would share the
  tunnel's address.
- One participant record per page: `{handle, principal?, address,
  fingerprint, cookie, auth: member|signed-in|anonymous, joined_at,
  last_seen}`. The `here` block shows handle and auth badge to everyone,
  address and fingerprint to the facilitator only. `page export` writes
  handles and auth status, never addresses, into the record; the facilitator
  log keeps the full rows.
- Facilitator escape hatches, each explicit and logged: rename, merge two
  records, kick, and `--open` (accept duplicate handles for a demo).
- OTel: `participant.handle`, `participant.auth` and `participant.address`
  as span attributes on every page action, emitted only when the owner's
  OTel is configured, as the other apps do.

**The participant identity is the respondent key for every tally and
collection.** The page passes it to the native blocks as the respondent: a
form answer is stored once per identity (a resubmit replaces, never
duplicates); poll and brainstorm votes are counted once per identity against
the vote budget; the facilitator's results view lists `handle → answer` and
`option → votes (handles)`. The kit cookie alone is never the key; it only
corroborates the identity. `--anonymous` on a block (form already has it)
keeps the tally per identity but hides handles from everyone, including the
export. `page export` writes per-handle answers for collections (sign-ups,
team names, consent status) and tallies with handles for votes, so the record
shows who voted and who answered.

### Roles and views: the organizer sees both faces (operator, 2026-11-23)

Several engines have two different views: brainstorm's facilitator panel and
participant board, demo-queue's organizer, presenter and projector pages,
form's owner results and respondent page, session's owner, participant and
display pages. The page has three roles, **organizer** (the page owner, holds
the owner key), **participant** and **viewer**, and every block renders for a
role:

- A block kind declares which faces it has (`organizer`, `participant`,
  `display`). For a native block the adapter knows both the owner-keyed API
  (results, open/close, phase, assign turn) and the participant path; for an
  embed block the two faces are two URLs, the private one with the engine's
  own facilitator fragment or key.
- **The organizer sees both faces of a dual-view block**: side by side when
  the screen is wide, tabs ("Organizer", "Participant", "Display") when it is
  not, with the organizer face first. Participants and viewers get only their
  face; the organizer face, its controls and the sibling's facilitator key are
  never in their HTML, state or export.
- **View as participant** is a page-level toggle for the organizer that
  renders the whole page exactly as a participant sees it (same identity
  rules, a throwaway participant identity), so the facilitator can check what
  the room sees before saying "open your pages". A `display` face (projector)
  is the page opened with `?view=display`: the organizer's choice of blocks,
  large type, no controls; it is what demo-queue's projector and session's
  display page already are, and the organizer may put either in an embed.
- Owner keys of embedded items are held by the page server in the page's
  store under the organizer's key (the desk no-secrets rule applies: they are
  item keys, not credentials, and never appear in `show` or export).

### Two speeds of "on demand": where software shaping comes in

| Need during a meeting | Speed | Mechanism |
|---|---|---|
| "add a poll with these three options", "collect team name and lead per team", "put the agenda section here", "start a five-minute timer" | seconds; data, not code | `page block add poll --options …` (which calls `form add --poll`), `page set`, `timer start`. The facilitator types it or says it to their agent, which runs the verbs as the facilitator's hands. No build, no verify step. |
| "show the vote as a bar chart", "hide results until voting closes", "one row per student for consent-form status", "a block that pulls the open pull requests from the class repository" | minutes; code | `bashy shape wish` on `page`: the agent writes the block kind or template, bashy verifies and previews, the facilitator approves. The page is the facilitator's app, so the approved version is what the audience sees; a participant may still shape their own view (consumer shaping, Sprint 682). |

The first row is what makes a meeting work; the second row is the showcase,
rehearsed before the meeting and used live when it is safe. A block kind is
one small renderer (`blocks/<kind>.go` or `.bsh`) plus a template, so the
shaping surface is narrow and verifiable. Meeting formats live in
`templates/*.md` (agenda, meeting, retro, workshop), as viewer and session
already ship templates.

### Rejected alternatives

- One merged codebase of all engines: duplicates the Excalidraw, Grist and
  Databag concerns, breaks per-app shaping and the Sprint 677 independence
  rule.
- Iframes only: no shared identity, shallow shaping, no record export.
- Re-implementing form, poll and table inside the page: reuse first; the
  natives keep form's questionnaire rounds, brainstorm's rounds and meet's
  ballots for free.

## Sprint

Title: "Page: one fixed, live page for a group, composed of the desk apps and
shaped on demand". Epic software-shaping, backlog, planning only, no manager.
The MVP (p0) targets a weekly class on Sunday 2026-11-29 as its UAT (the
class is a test case, never the product; wording in bashy docs stays
general). If the dress rehearsal fails, the class runs on today's tools.

| Story | Priority | Content |
|---|---|---|
| kit: SSE hub, embeddable CSP, LAN guard | p0 | `kit.Events`: `GET /api/events?id=` per item, frames `{item, block, revision}`, `Last-Event-ID` resume, stdlib, pattern from meet and demo-queue; CSP option `frame-ancestors 'self'`; `kit.CheckLoopback` gains the explicit, logged `--lan` override. Contract-test rows for all three. |
| page skeleton | p0 | `bashy/examples/desk/page`: the desk seven verbs; item = Markdown + blocks + audience + revision counter (G3 revisions reused when they land); `add -f`, `set`, `open` (id, URL, status only), `share`, `export --to md|html`; `register.sh` (`app add --type shaped`), `shaped.json`, `dag.md`, `publish-outpost` via `kit/outpost.bsh`; contract test green. |
| join: short code and handle | p0 | Join code as the page path on every door (`?id=` kept), generator and per-host uniqueness, fixed LAN port, `page open` prints both links, QR codes and the code; join screen with principal detection, handle prompt for anonymous participants, the `<handle>@<address>` binding and reclaim rules, facilitator rename/merge/kick, OTel attributes. Tests: a refresh keeps one vote; the same handle from a second address is refused; satellite participants get distinct forwarded addresses; the export has no addresses. |
| blocks: poll and form (native) | p0 | Adapter over form's API; `page block add poll|form`; the participant identity is the respondent key, carried to form through the per-participant cookie jar; one answer and one vote budget per identity, resubmit replaces; facilitator open, close and results visibility from the page; results view `handle → answer` and `option → votes (handles)`; `--anonymous` hides handles; tallies over SSE. Proof: a three-votes-per-participant ballot with distinct fake identities, one refreshing and re-voting, counted once. |
| blocks: text and book, embed, timer | p0 | Viewer page and notepad note inline; `embed:` iframe for whiteboard, table and Klatch; a timer with facilitator controls and SSE ticks. |
| roles and views: organizer sees both faces | p0 | Block kinds declare their faces (organizer, participant, display); native adapters carry both the owner-keyed API and the participant path, embeds carry two URLs; the organizer sees dual-view blocks side by side or in tabs, participants only their face, the organizer face and the sibling facilitator key never in participant HTML, state or export; page-level "view as participant" toggle; `?view=display` projector face. Proof on brainstorm (facilitator panel + board) and demo-queue (organizer + projector) as embeds, and on form (results + respondent) as a native. |
| export to the record | p1 | `page export --to md` with block states inline, in the shape of a session record; `--to pdf` through viewer's headless-Chrome path. |
| brainstorm block (native, read and vote) | p1 | Cards and voting from the page; phase controls stay in brainstorm (link out). |
| presence and hands | p1 | `here` and `hands` blocks on the SSE stream. |
| templates, genie examples, runbook | p2 | `templates/agenda.md`, `meeting.md`, `retro.md` (reuse `examples/session/formats/*`); genie examples in `shaped.json` for the second-speed wishes; kb runbook "Run a class or meeting on one page" with the two speeds. |
| UAT: the Sunday class | p2 | Dress rehearsal on the gate host with fake identities on both doors, then the live class through the satellite door; outcome recorded in the class repository only. |

Rules: build and tests on the gate hosts, never the dev box; no Chrome tests
on the dev box; unit tests per story, one integration run before the class;
root cause before any fix; no cloudbox or outpost change; no release.
Dependencies: none hard. Sprint 684 G3 revisions and G2 item share are reused
when they land, not waited for. Sprint 682 supplies the shaped registration
pattern.

Non-goals: live merge or CRDT; replacing the whiteboard, table or Klatch
engines; agent principals; LAN identity; any release.

Follow-ups filed, not built: `table` lite and `follow` blocks; publishing a
page through the `shaping/website` tiers (public read); the page as a Trove
presenter target; brainstorm and session dropping polling for the kit hub;
LAN identity and app discovery (an outpost sprint); a hosted short redirector
for join codes (hosted-plane ticket, public wire contract only).

## Decisions (operator, 2026-11-23)

- Architecture: a page of live blocks over the existing apps, not a merged
  app and not a page that re-implements the simple blocks.
- Doors: satellite and LAN both first class from day one.
- UAT: the Sunday 2026-11-29 class.
- Name: `page`.
- A short, typeable URL and path for participants.
- The organizer sees both views of a block whose app has an admin view and a
  user view (brainstorm, demo-queue, form, session); participants never do.
- Anonymous participants join with a handle bound to their address for the
  session; authenticated participants are known from the stamp; the identity
  is the respondent key for tallies and form collection.
