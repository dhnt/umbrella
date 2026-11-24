# Access tiers: anonymous, account, owner

Design of record (operator decisions 2026-11-24) for who a caller is across
the cloudbox and bashy stacks, what they may change, where their shaping runs,
and how the three software-shaping workflows map onto it. Companion to
`docs/sprint-706-master-execution-plan.md`, which files the gaps. Supersedes
by reference the "four visitor tiers" wording in
`docs/shaping-enable-a-website.md` and `docs/sprint-615-master-execution-plan.md`,
the CMS table in `docs/sprint-641-feature-matrix.md`, and the tier table in
`docs/sprint-691-master-execution-plan.md`.

## Decisions

1. **Three levels, for simplicity: anonymous, account, owner.** An owner is an
   account holder who has their own host paired with the cloudbox master. A
   satellite is another kind of outpost (routing functions plus a local
   outpost; a satellite also runs an outpost), today on the cloud. A local
   outpost could serve the same role with limits (peer-to-peer only). There is
   no separate "plane owner" level.
2. **Anonymous visitors configure, they do not shape.** A public visitor
   changes the features the owner already declared, through the same wish
   workflow; nothing is kept server-side and code never changes. Code changes
   are the owner's.
3. **The relationship stamp keeps four values; `signed-in` becomes
   `account`.** "user" is reserved for the OS user (`Remote-Groups:
   admin|user`, `X-Periscope-Role`, host elevation). A logged-in cloudbox
   account holder is an `account`; an owner is an account; a member is an
   account on another account's member list. Rejected words: `user` (OS user),
   `guest` (a member circle), `visitor` (means anonymous in the 641 matrix),
   `signed-in` (clumsy, and a hyphen in a wire value).
4. **Authorization is always cloudbox's.** One authority for identity and
   membership. A satellite or outpost learns who a member is only from
   cloudbox, never from a third-party auth. Public modules consume stamps and
   grants; they never decide identity.

## Level: what a person has with cloudbox

| Level | Who | Where bashy runs for them | Gateway route |
|---|---|---|---|
| **anonymous** | no cloudbox login | nowhere kept: an in-browser taste that is not saved | none |
| **account** | logged-in cloudbox account, no live paired host | the hosted plane: desktop property shaping, the hosted runner (Sprint 691), the trove, pooled wishes with a stated allowance | `hosted` |
| **owner** | account with at least one host paired with the master (an outpost, or a satellite) | their own host; their own model lifts the ceiling; may share apps, define circles, run a front door | `sync` while a host is live; `hosted` for a call while every host is offline; owner-host-bound verbs `pull` |

The routing rule is the Sprint 691 H3 rule in `docs/vendor-chat-gateway-mvp.md`.

## Relationship: a caller to a host owner (the stamp)

`anonymous` (no stamp) < `account` (logged in, not on this owner's member
list; a per-app pseudonym, never the email) < `member` (active mutual member;
circle and groups) < `owner`. Any bad or stale stamp fails closed to the lower
value.

Produced from cloudbox identity by outpost (`X-Outpost-Relationship`, v2 HMAC;
`outpost/internal/agent/grants.go`, `outpost/internal/agent/apps.go`; wire
contract `outpost/docs/cooperative-web-apps.md`), verified by yoke
`pkg/coopauth`, consumed unchanged by every app, CLI and MCP surface
(`bashy/internal/agentos/mcp_site.go`, the shaped-website template
`examples/shaping/website/template/{identity,audience}.go`, the desk kit
`examples/desk/kit/identity.go`). The wire value today is `signed-in`; it
becomes `account`, with `signed-in` accepted as an alias for one release window
(Sprint 706 R1).

Kept apart: `Remote-Groups: admin|user` and `X-Periscope-Role` say how the OS
user elevated on the host (cleared the OS password as admin or user). Apps read
the relationship header for audience decisions and the elevation header for
host admin rights. "user" means the OS user everywhere in dhnt.

## App role: what a caller may do in one app (owner-defined)

Default mapping from the relationship, redefinable by the owner through
`shaped.json` features and audiences:

| Relationship | Default |
|---|---|
| anonymous | read; configure declared properties; nothing kept server-side |
| account | read; personalize their own view (pseudonymous); see `account` audiences (today spelled `signed_in`) |
| member | what the circle audiences admit; contribute under moderation |
| owner, or a named maintainer | shape code; manage the app and its shares |
| staff | by release only, never by a wish |

Group apps use the relationship as the participant kind; anonymous guests join
by name at the owner's discretion (Page's join code). A "buyer administrator"
is a party-scoped app role, not a relationship. Agents act with exactly the
identity of the person who assigned them (Sprint 684 rule); a Web Bot Auth key
with no person behind it is anonymous with provenance.

## Invariants

1. Level never implies relationship: an owner is `account` on another owner's
   host. Relationship never implies level: a member with no live host routes
   `hosted`.
2. Identity is mandatory for any kept change. Anonymous configuration is the
   same workflow, but it is not stored server-side and never changes code.
3. Code shaping needs the relationship owner or maintainer on that app and the
   owner's own host as the venue. On a public surface a non-owner changes
   declared configuration only, refused at manifest parse time (Sprint 641
   rule).
4. A logged-in stranger is admissible to `require_login=false` apps on a
   satellite as `account`, without becoming a member. Today the satellite
   admits mutual members only, so the relationship collapses to anonymous:
   the open gap, owned by cloudbox (Sprint 706 R2). **Shelved 2026-11-24
   (operator)** over privacy concerns: a rogue satellite owner could track or
   correlate logged-in visitors; needs a privacy design review first.
5. One authority (cloudbox), one vocabulary. Every surface (UI, CLI, API, MCP,
   hosted runner) derives level and relationship from the same stamps and
   grants. No second permissions engine in any public module.
6. Refusals demote, never dead-end; a demotion records words, never effects.

## Coverage

| Case | Level | Relationship on that host | Result |
|---|---|---|---|
| dhnt.io landing, not logged in | anonymous | n/a | read; configure declared properties; nothing kept |
| desktop, logged in, no host | account | owner of their own desktop | property shaping, hosted runner, allowance |
| own outpost live | owner | owner | `sync`, no ceiling |
| own outpost offline | owner | owner | `hosted` for the call |
| class satellite: the teacher owns the satellite, each student owns an outpost | both owner | student is a member of the teacher's circle | students shape their own apps on their own hosts; the teacher shares by circle |
| logged-in stranger visits a shaped site through a satellite | account or owner | account | public apps as a pseudonym (gap: invariant 4) |
| member of circle `recruiter` | any | member | circle audiences |
| owner shapes through `bashy mcp serve --tools site --outpost` | owner | owner | shape tools |
| agent assigned by a member | the member's | member | exactly the member's rights |
| bashy agent signed with Web Bot Auth, no person | anonymous | anonymous | read tools if the owner allows |
| hosted runner call from an agentic tool for an account | account | the caller as principal | `hosted`; approvals settle on the master |
| Page guest via join code | anonymous | anonymous | guest by name, the owner's switches |
| HostShare sharee (`outpost connect` on a shared host) | any | a share grant from cloudbox | the existing share path |
| OS user elevating on a host (`Remote-Groups`) | orthogonal | orthogonal | host admin rights, not a tier |
| staff | out of band | out of band | by release only |

## Shaping workflows

The wish, candidate, verify, preview, approve process is the same in all
three. What differs is who may change what, whose resources run it, where the
version line lives, and whether contributions are live or merged later.

| Workflow | Who shapes | What may change | Whose resources | Version line | Sync |
|---|---|---|---|---|---|
| **1. Anonymous** | anonymous | declared configuration only; never features or code | the site's declared properties; nothing kept server-side; no kept model call | none: a browser-local layer | n/a |
| **2. Group shaping** | the owner, plus the members (and anonymous guests, at the owner's discretion) the owner has granted `shape` or `edit` on that app | content and, where granted, code of ONE app on the owner's host | the owner's: their LLM allowance and their outpost or satellite. A member shaping is the same as the owner shaping remotely from another device; only the revision author differs | one shared line on the owner's host; every change is a revision with its author (Sprint 684 kit store) | live and sequential on one host; conflicts are refused with both revisions returned, never merged silently |
| **3. Team shaping** | several owners contributing to a primary owner's app; each is a `member` of the primary owner | the same app on the primary owner's line | the primary owner's host and line; a contributor who owns a host may build and verify a candidate on their own resources first | one shared line on the primary owner's host, as in workflow 2 | asynchronous: candidates stay per requester, are rebased onto the current line and re-verified before approval; the primary owner or a named maintainer approves |

Team shaping is workflow 2 with owners as members (operator, 2026-11-24).
There is no separate team scope: one grant model (the Sprint 641 feature
audience grammar), one revision model (Sprint 684), one approver rule (owner
plus named maintainers), no driver lease. A member's wish beyond their grant
demotes to a request on the owner's queue. One owner on many devices needs no
per-device line: the line lives on the app's host and a second device shapes
it remotely through the gateway or the site MCP, the same path as a member.

## What exists, what is a gap

| Piece | State |
|---|---|
| Workflow 1 on sites and the desktop | done (Sprint 641 M4/M6, 693, 697 A3) |
| Workflow 2 for content on Page, Session, Notepad | done (Sprints 684, 685) |
| Workflow 2 and 3 on shape routes (a granted member shapes with the owner's LLM on the owner's host) | gap: `allowShape` is owner-only; Sprint 706 R5 |
| The `account` relationship through a satellite | shelved (privacy review first); R2 `7c1ad004f53d` |
| The path from `account` to `member` inside the product | shelved with R2; Sprint 706 R7 |
| A member pulls and pushes from their own machine (their own tools) | Sprint 709: the member's account token, exchanged on the satellite, proves identity only; the share and scopes stay per app |
| The stamp word `account` | Sprint 706 R1 |

## Retired by this model (2026-11-24)

Sprints 639 (trove content space: the account tier is served by Sprint 691
H6/H6b), 640 (team shaping: the primary-owner workflow replaces a team scope),
667 (provable relays: the group model carries provenance for shaping), 669
(software shaping MVP: replaced by this model; the admission rung and the
consented access request are carried), 679 (One Agent hub: routing is covered
by the group model), 689 (shaping sync across one owner's devices: the single
venue makes it unnecessary). Their bugs moved to Sprint 703; their kept
stories to Sprint 706.
