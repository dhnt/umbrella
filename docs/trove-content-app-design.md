# Trove: a shaped content space, one tree for agents and humans, presented on the fly

Design of record for Sprint 639 (epic software-shaping). Status: **planning
only**, filed 2026-11-14. The sprint card and its stories are authoritative;
this document records the review, the model and the decisions behind them.

## Goal

An owner keeps a **trove**: a private collection of the content that matters
to them, wherever it lives (local drives, the owner's other hosts behind
outpost, git and GitHub repositories, Google Drive, later mail and calendar)
together with everything agents produce over time (reports, notes, drafts,
evidence). The trove presents that collection the same way to agents (small
`--json` verbs with rich metadata, the analogue of `cd`, `ls`, `find`, `cat`)
and to humans (an explorer web page). Any entry can be **presented on the
fly** in another form (a summary, a note, another language, a poster, audio,
video), served canned when the producer prepared it and generated when they
did not. Members and agents **contribute** into it under the owner's grants, so the
trove grows over time rather than mirroring one source. That last part is
what software shaping adds: a producer can never prepare every form for every
reader, so the reader's agent makes the one they need, and the recipe that
makes it is itself shapeable. The app, too, takes any form: how the tree is
shown, how entries are presented and which sources exist are all shaping
hooks, so each user ends with their own trove app.

The trove is a general app for every bashy user, owner or member. The two
scenarios at the end of this document are **test cases** of the general
verbs, needed within weeks; they are not the audience and no product
decision is taken from them alone.

## Why "trove"

"Workspace" is already a weave clone, a Codespaces or Gitpod session, Google
Workspace and the Go `go.work` tree; "space" is `bashy graph space`; desk,
vault, drive, stash, cache and keep are taken. The operator chose **trove**
(2026-11-14): a private collection of important things, one syllable, no
collision. Verb `bashy trove`, reference scheme `trove:<mount>/<path>`,
example directory `bashy/examples/trove/`.

## What exists today (reviewed 2026-11-14)

| Area | Fact | Where |
|---|---|---|
| Shaping | wish → candidate → verify → preview → approve (per principal for web apps) → undo/restore → promote; the "Shapeable with Bashy" checklist | `bashy/docs/software-shaping.md`, `shape-contract.md`, `yoke/pkg/shape` |
| Shaped app pattern | `examples/<job>/<job>.bsh` skill-script + app tree `contract.bsh`, `checks/`, `shaped.json` (`server.main` built with `go build` only, `genie.examples`, `properties`), registered `bashy app add --type shaped` | `bashy/examples/notes`, `yoke/pkg/fleet/apps.go` |
| Rules | custom command never core; fork or build; permissive licence; no phone-home; `--json`, `--dry-run` on writes; small verbs composed in Bash#; name the shaping hook; example → optional → core | `docs/shapeable-apps-worker-brief.md`, kb page `extend-bashy-small-verbs-…` |
| Shaping levels | owner / member / public are design only (Sprint 638 S6) | `docs/website-shaping-integration.md` |
| `files` app | outpost's in-process File Browser: one `scope` directory per host, host-only `allow_write`, no CLI (parity via `outpost connect\|ssh\|scp`) | `outpost/cmd/outpost/capability_files.go`, `docs/files-fbembed-quantum-port.md` |
| Desk kit | two front doors (`POST /api/action`, `GET /api/state\|export`), stable id + URL, local-first JSON, no secrets, `publish-outpost`, conformance test on colours and fonts; `viewer` renders data through shapable templates (goldmark + bluemonday) | `bashy/examples/desk/kit`, `desk/viewer` |
| Identity through outpost | `X-Forwarded-Prefix`; `Remote-User` / `Remote-Groups` stamped only through the matrix tunnel | `outpost/docs/cooperative-web-apps.md` |
| Read-only tree seam | `Provider{List, Stat, Open, Edges}` over `ref.Locator`; node schema `bashy-node-v1` (ref, path, name, kind, type, size, mode, mtime, rev, children, attrs); schemes `dir:`, `dir:<path>@<host>` (outpost sftp), `git:REV:PATH`, archive `!/`, pdf, md, proc, net, …; CLI `bashy lens -t listing\|graph LOC`, `bashy tree --json` | `yoke/pkg/lens/provider`, `yoke/pkg/ref/locator.go`, `yoke/cmds/lens/hostscope.go` |
| Recipe admission | `RegisterRecipe` admits only `oci` and `k8s`; a Recipe is an in-process Go callback. A new scheme in `lens` is therefore a core change; `ref.ParseLocatorWithSchemes(extra)` is the hook | `yoke/pkg/lens/provider/recipe.go` |
| Google | `google.bsh` over gws (bring-your-own-project): drive, gmail, calendar, tasks; credentials per account under the bashy config dir; rods `email.read`, `drive.read`, `email.send` (needs `--yes`) | `bashy/examples/google` |
| Other reach | `bashy gh`, pure-Go git, `bashy rclone` (pinned, MIT), `bashy fetch URL --md`, `lens` html/pdf/docx/xlsx → md | `yoke/external/*`, `yoke/pkg/lens` |
| Generation | service roles `text`, `translate`, `narrate`, `transcribe`, `image.generate\|edit`, `animate`, `song`, `pdf.read`, `video.understand`, `search`; routes oss / browser / api / vendor; `spend` and `send` need `--yes`; OSS rods; `media.bsh`; film's draft → lock → final | `bashy/docs/service-rod-contract.md`, `examples/service-door`, `examples/oss-rods`, `examples/media`, `examples/film` |
| Grants | outpost `GrantCopy{Owner, Members[{Email, Circle}], Apps[app][]GrantRule}` per **app**; `outpost apps share APP --email\|--circle`; shape boundary `@reads/@writes` for shaped apps; agent-permission policy not built; no per-resource grant anywhere | `outpost/internal/agent/grants.go`, `yoke/pkg/shape/boundary`, `docs/bashy-agent-permissions.md` |
| App item refs | `app:<command>/<id>` | `yoke/pkg/ref/app.go` |
| Probe | `bashy fetch --md` on the AP CSP redesign page returns the full article as markdown | run on the dev box |

Nothing in the repository covers a content viewer over several sources, a
virtual tree with grants, an artifact store, or the review of submissions.

## The model

A **trove** is the owner's named set of **mounts**, recorded in `trove.json`
(owner-owned; a protected path for every other principal).

```json
{"schema_version": "bashy-trove-v1",
 "mounts": [
   {"name": "club",   "locator": "dir:/srv/club/submissions@studio-host",
    "grants": [{"who": "circle:staff", "mode": "read"},
               {"who": "circle:students", "mode": "read", "only": "self"}]},
   {"name": "drive",  "locator": "drive:", "account": "owner@example.com",
    "grants": [{"who": "owner", "mode": "write"}]},
   {"name": "artifacts", "locator": "app:", "grants": [{"who": "owner", "mode": "read"}]}
 ]}
```

An **entry** is a `bashy-node-v1` node plus trove attributes:

| attr | meaning |
|---|---|
| `mount`, `owner` | which mount, whose trove |
| `grant` | the caller's resolved mode (`read`, `write`, or absent) |
| `provenance` | `producer: human\|agent`, the `app:<command>/<id>` ref, the run or story that made it |
| `renders[]` | presentations already available (canned by the producer or cached) |

Reference form: `trove:<mount>/<path>`. Agents walk the tree with
`trove ls|find|stat|cat --json` and get the same rows `bashy lens -t listing`
prints; humans see the same tree in the explorer page.

## Sources

Slice 1 emits node rows from Bash# over verbs that already exist; no engine
change is needed to start:

| scheme | over | writes |
|---|---|---|
| `dir:` and `dir:<path>@<host>` | `bashy lens -t listing` (local; outpost peer over sftp) | `trove put` to a local or `allow_write` host mount with a write grant |
| `git:` | `bashy lens` git provider | none |
| `drive:` | `bashy google drive-list\|drive-search\|drive-get` (account named on the mount) | `trove put` with a write grant |
| `gh:` | `bashy gh api` (repo tree, issues as entries) | none |
| `app:` | viewer books, notepad items, kb pages, film drafts, run evidence through their own `--json` verbs | none (apps own their items) |
| `mail:`, `cal:` (p2) | `gmail-list\|gmail-get`, `calendar-list` | none |

**Contributing.** `trove add SRC --to MOUNT` is a first-class operation for
the owner, a member or an agent acting as a principal: `SRC` is a URL (through
`bashy fetch --md`), a local file, stdin or an `app:<command>/<id>` artifact;
`trove put` copies an entry's bytes to another writable mount. Every
contribution records provenance (principal, agent tool and model if any, time,
source ref, digest) on the entry. Every write verb takes `--dry-run` and
refuses without a write grant, with the same result on the CLI and over HTTP.

**Optional core seam (S10).** External recipe admission in `yoke/cmds/lens`: a
`recipes.json` under the bashy home maps a scheme to an argv that prints
`bashy-node-v1` / `bashy-edge-v1` JSONL, loaded through
`ref.ParseLocatorWithSchemes`. It replaces the hard-coded oci/k8s list so
`bashy lens -t listing trove:…` and `bashy tree` work for trove and for every
later example. Small, separately committed, and the conductor may defer it.

## Grants

The smallest model consistent with cloudbox membership:

- `who` is `owner`, `member:<email>` or `circle:<name>`; `mode` is `read`
  (see and present) or `write` (contribute). Membership and circles come from
  the cloudbox grant copy outpost already holds; the trove never redefines
  them. Per-entry visibility rules are not part of the product model: when a
  trove needs one, its owner adds it as a shaped grant rule for that trove,
  and it is generalized only when a second case appears.
- The caller is `Remote-User` / `Remote-Groups` on the web (stamped only
  through the tunnel) and `--principal` / `BASHY_PRINCIPAL` on the CLI, as
  `bashy shape` does. The owner is always admitted. A denied entry is the same
  not-found or no-access result on the CLI and over HTTP.
- `trove share MOUNT --member|--circle --mode` shells to
  `outpost apps share trove …`, so app admission and mount grants never
  diverge.
- **No agent principal.** Agents act as the owner's principal and are capped
  by effects and by `--yes` for `send` and `spend`, which is how every other
  bashy verb treats them.

The vocabulary matches the shaping levels (owner, member, public) so the two
converge when the levels land.

## Presentation on the fly

```
trove present REF --as summary|note|md|pdf|lang:XX|audio|poster|video
                  [--for AUDIENCE] [--route oss|browser|api] [--yes] [--dry-run]
```

1. **Canned.** If the entry or its mount carries a render the producer
   prepared for that form and audience, serve it. No model runs.
2. **Generated.** Otherwise the presenter calls the service doors: `text` for
   summary and note, `translate` for `lang:`, `narrate` plus `media` for
   audio, `image.generate` for a poster, `media cards` or `video` for video,
   `pdf.read` and `lens` for md and pdf. The oss route is tried first; a paid
   route runs only with `--yes`.
3. **Cached.** The result is stored under the owner's trove render cache
   (`<bashy home>/trove/renders/<sha256(ref, form, presenter)>/`) with a
   `provenance.json` naming the role, provider, route, input digests, cost
   class and run. Sources are never written. The next reader gets it canned.

`--dry-run` prints the plan (which rod, which route, which cost class) and
runs nothing. Media presenters require a claimed GPU gate resource; on the dev
box they print the plan and exit 3.

**The shaping hook.** Presenters are Bash# skill-scripts
`presenters/<form>.bsh` (one file is the verb and its skill) plus
`presenters.json` (audience variants, language, length, rubric), exposed as
`shaped.json` properties. A member who wishes "summaries for parents: three
bullets, in Spanish" gets their own verified version of the presenter, and
everyone else keeps theirs.

## Rod, not fish

The rule that governs every bashy app governs the trove: the product is a set
of small verbs (`mount`, `ls`, `find`, `stat`, `cat`, `add`, `put`, `present`,
`share`), each with `--json`, `--dry-run` where it writes, and meaningful exit
codes (0 done, 3 pending or refused by venue, 1 error). No finished flow is
built in. A flow such as "turn this page into a note and mail it" or "review
the submissions and show each reader their view" is a short Bash# skill-script
that composes those verbs, and the script is itself shapeable. The two test
cases below are written exactly that way, so passing them proves the rods,
not a canned feature.

## The app in any form: the shaping hooks

The trove ships as a **starter** that each user shapes into their own app.
Three hooks, each a file or a verb and never Go:

| hook | declares | example wish |
|---|---|---|
| `views.json` | how the tree is shown: list, gallery, cards, timeline; columns, sort, grouping; the default view per mount | "show the photos mount as a gallery, newest first" |
| `presenters/<form>.bsh` + `presenters.json` | how an entry is presented: forms, audience variants, language, length, scoring guides | "summaries for the family: three bullets, in Spanish" |
| source adapters (recipes) | which sources exist: a scheme mapped to an argv that prints `bashy-node-v1` rows | "add my podcast feed as a source" |

All three are `shaped.json` properties, so the Genie and `bashy shape` know
them, and `contract.bsh` and `checks/` keep the engine-facing parts out of
reach. A member's shaped view, presenter or adapter is theirs alone, verified
before activation and one step from undo; the owner's trove is unchanged.

## The explorer page

A small Go server on the desk kit, registered `--type shaped` with
`shaped.json` (`server.main`, `genie.examples`, `properties`), `contract.bsh`
and `checks/smoke.bsh`. Layout, rendered from `views.json`: mounts tree, entries in the chosen
view, preview pane (`lens` → markdown → the kit renderer; `<video>`,
`<audio>` and `<img>` for media), a **Present as…** menu, a **Contribute**
action and a provenance strip. Every page action posts
to `/api/action` and runs the same trove verb (parity rows in
`bashy/docs/ui-cli-parity.md`); identity comes from the tunnel only;
`publish-outpost` puts the page behind the owner's door. Editing in the
browser links out to notepad and to the `files` app; the trove builds no
second editor, and the File Browser stays as it is.

## Test cases (needed within weeks; not the product)

Both exercise only the general verbs. They are filed as stories T1 and T2 at
p2, after the product lane.

**T1, a web page becomes a note for someone.** `trove add <public page URL>
--to inbox`, `trove present trove:inbox/<entry> --as note --for <audience>`
(oss route, dry-run first), `bashy email --role email.send` as a draft, the
operator reviews, one send with `--yes`. First instance: the AP Computer
Science Principles redesign page summarized for a teacher. Zero spend; the
recipient is named by role in the public record.

**T2, members contribute project submissions and each consumer sees their
view.** Members contribute **synthetic** submissions (short clips and a
blurb; committed fixtures, no personal data) into the owner's `projects`
mount. The owner shapes a `review` presenter (`transcribe`,
`video.understand`, `text` against the group's own scoring guide in
`presenters.json`) whose output per submission is a summary and scores
labelled as presenter output, never a grade of record. Grants give staff
everything and the public showcase only the entries the owner marked; if
contributors must see only their own entries, the owner adds a shaped grant
rule for this trove. Media stages run on the claimed GPU gate host; the text
path on the dev box. First instance: a film-making club.

## Risks

- gws bring-your-own-project credentials cannot run in tests; S4 and S12 use
  hermetic fakes and the operator records one live smoke.
- A per-trove visibility rule (T2) must stay a shaped rule, not a product
  feature, until a second case appears.
- The kit server must build inside the verifier's scrubbed environment; the
  contract follows `desk/viewer` (`read,write,exec,net`).
- The S10 seam touches the locator scheme set; it is optional and separate.
- Presenter output that scores or ranks content is model output; it is
  labelled as presenter output wherever it appears and never leaves the host
  without `--yes`.

## Follow-ups, noted not planned

Per-path access lists; writes to mail, calendar or GitHub; a FUSE mount; a
second text editor; replacing the `files` app; a core permission policy
(`docs/bashy-agent-permissions.md`); per-entry visibility rules in the
product model; wish-log replay; index or embedding search over the trove;
real personal data in fixtures; paid finals without `--yes`; agent
principals.
