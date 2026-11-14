# Sprint 639: Trove, a shaped content space, one tree for agents and humans, presented on the fly

Sprint UUID: `59409a5a-4d63-513c-af53-8f97cf8be185`. Epic: software-shaping.
Status: **planning only**, filed 2026-11-14; no implementation started, no
manager appointed. Design of record: `trove-content-app-design.md`. The
sprint card and its stories are authoritative.

## Primary goal

An owner mounts the content they care about (local directories, their hosts
behind outpost, git and GitHub, Google Drive, the artifacts agents produced)
into one **trove**; agents walk it with `trove ls|find|stat|cat --json` and
humans with the explorer page; any entry is presented on the fly as a
summary, a note, another language, audio, a poster or a video, canned when
the producer prepared it and generated under the owner's grants when not;
the presenters that do this are the shaping hook, so a member gets their own
verified version and everyone else keeps theirs.

## What the code showed (2026-11-14)

- A shaped app is a `.bsh` skill-script in `bashy/examples/<job>/` with an
  app tree (`contract.bsh`, `checks/`, `shaped.json`, `public/`) registered
  through `bashy app add --type shaped`; the console serves it per principal
  and `go build`s `server.main` itself.
- The `files` catalog app is outpost's embedded File Browser: one scope
  directory per host, host-only writes, no CLI. It is a single-host browser,
  not a tree over many sources.
- A read-only tree seam already exists: `yoke/pkg/lens/provider`
  (`List/Stat/Open/Edges` over `ref.Locator`, node schema `bashy-node-v1`),
  with `dir:`, `dir:<path>@<host>` over outpost sftp, `git:`, archives and
  more; `bashy lens -t listing` and `bashy tree --json` print it. Its recipe
  registry admits only `oci` and `k8s`, so a new scheme inside `lens` is a
  core change; `ref.ParseLocatorWithSchemes` is the hook.
- Content verbs exist for every requested source: `google.bsh` (drive,
  gmail, calendar over gws bring-your-own-project) with `email.read`,
  `drive.read` and `email.send` rods, `bashy gh`, pure-Go git,
  `bashy fetch URL --md`, `lens` document conversions.
- Generation runs through the service doors (`text`, `translate`, `narrate`,
  `transcribe`, `image.generate`, `video.understand`, `pdf.read`, …) with
  oss, browser and api routes; `spend` and `send` need `--yes`.
- Grants exist per app (outpost `GrantCopy`, `outpost apps share`) and per
  shaped app (`@reads/@writes`); no per-resource grant exists. Agents act as
  the owner's principal capped by effects.
- Shaping levels (owner, member, public) are design only (Sprint 638 S6).
- `bashy fetch --md` on the AP CSP redesign page returns the full article.

## Stories

Tags: example (bashy/examples custom command), core (yoke change, small and
separate), verification, docs. Vendor is the planned assignment by strength;
the conductor may reassign.

| # | Story | Tag | Vendor | Acceptance |
|---|---|---|---|---|
| S1 `804b7d9720e0` | `trove.bsh`: `trove.json` mounts; `mount add\|ls\|rm` for `dir:`, `dir:@host`, `git:`; `ls\|find\|stat\|cat` emitting `bashy-node-v1` rows with trove attrs; `--json --fields --dry-run`; `register.sh`, `contract.bsh`, `checks/`, synthetic fixtures | example | codex | rows pass the `bashy-node-v1` validation of `provider/recipe_test.go`; `trove cat` of a peer-host file equals `lens` output; unknown mount is not-found; checks green under `bashy shape verify trove` |
| S2 `cfd94ff64758` | `trove present --as summary\|note\|md\|pdf\|lang:XX`: presenters hook (`presenters/*.bsh`, `presenters.json` as shaped property), render cache with provenance, oss route first, `--yes` for paid, `--dry-run` plan | example | glm | dry-run names rod, route and cost class; second call is a cache hit; a `presenters.json` override changes the output; a canned render serves with no model call |
| S3 `0123321b5e80` | `trove add URL\|FILE --to MOUNT` (`fetch --md`) and **scenario i**: the AP CSP redesign page becomes a note, a Gmail draft, one send with `--yes` | example, verification | claude | reproducible from one `.bsh` run; no send without `--yes`; zero spend; note and envelope ids recorded, recipient by role |
| S4 `8b68afbe2486` | `drive:` and `gh:` mounts (read-only) over `google.bsh` and `bashy gh` or pure-Go git; account bound per mount; hermetic fakes | example | glm | `trove ls trove:drive/` and `trove:repo/` list and `cat`; tests need no live account; one live smoke recorded by the operator |
| S5 `a5386752ad57` | `app:` artifacts mount: viewer books, notepad items, kb pages, film drafts, run evidence with `producer: agent` provenance and `app:<command>/<id>` refs | example | claude | each kind lists; every ref resolves through `bashy <cmd> show`; read-only |
| S6 `c68cc7fee4df` | grants: per-mount `{who, mode}` with `owner`, `member:<email>`, `circle:<name>` and `only: self`; caller from trusted headers or `--principal`; `trove share` shells to `outpost apps share` | example | codex | matrix owner, member, circle, anonymous × read, write; refusals name mount and rule; CLI and HTTP give the same denied result |
| S7 `a8114a7882e8` | explorer page: kit-based Go server registered `--type shaped`, mounts tree, list, preview, **Present as…**, provenance strip; parity rows; `publish-outpost` | example | glm | kit contract test and browser test pass; every page action has a parity row; `bashy shape verify trove` green; a member sees only granted mounts |
| S8 `c0753c515485` | review presenter and **scenario ii**: synthetic club submissions become per-submission summaries and advisory rubric scores; four consumer views through grants; showcase marks | example, verification | claude + glm | four principals see four correct subsets; every rating carries `advisory: true`; media evidence from the GPU gate host; nothing leaves the host without `--yes` |
| S9 `4e7c4e50d3f4` | media presenters `--as audio\|poster\|video` via narrate, image and media rods; gate-host-only, the dev box prints the plan and exits 3 | example | glm | the gate host produces artifacts with provenance; the dev box refuses by name |
| S10 `9482e3dad022` | core seam: external recipe admission in `yoke/cmds/lens` (`recipes.json` scheme → argv, `ParseLocatorWithSchemes`); oci and k8s unchanged | core, small, optional | codex | `bashy lens -t listing trove:local/` and `tree` work through the recipe; unregistered scheme still exit 3; lens tests green |
| S11 `184437ad9827` | docs: README with embedded skill, kb runbook (owner and member wording; the club is acceptance only), parity rows, catalog row, index entries | docs | muse | reviewed; scrub gate clean |
| S12 `bc61abf0372b` | `mail:` and `cal:` mounts (p2): Gmail threads and Calendar events as read-only entries | example | glm | `trove ls trove:mail/` and `trove:cal/` list; `cat` returns markdown; hermetic fakes |

## Lanes and dependencies

- Lane A (smallest delivering slice): S1 → S2 → S3.
- Lane B (after S1): S4, S5, S6 in parallel; S12 after S4.
- Lane C: S7 after S2 and S6.
- Lane D: S8 after S2 and S6; S9 after S2.
- Lane E: S10 independent of every other lane (core, optional).
- S11 trails every lane.

## Gates and venues

Per story: its own acceptance plus `bashy shape verify trove` (checks run in
the scrubbed verifier), `GOWORK=off go build ./...` in bashy for Go pieces,
the kit contract test for S7, hermetic tests for S4 and S12, and the scrub
gate always. Venues: unit tests, headless Chrome and the oss text and
translate routes (ollama) on the dev box; heavy media (S8 media stages, S9)
only on the claimed GPU gate host through `bashy claim`, never the dev box,
never the shared release host, no hosted CI. Fixtures are synthetic and
public; no personal data enters the repository.

Close: scenarios i and ii recorded on S3 and S8; parity rows merged; the
yoke pin bumped only if S10 lands.

## Verification (the two scenarios)

1. **Note to an interested party.** `trove add <AP CSP redesign URL> --to
   inbox`; `trove present trove:inbox/ap-csp-redesign.md --as note --for
   teacher` (oss route, dry-run first); `bashy email --role email.send` as a
   Gmail draft; the operator reviews; one send with `--yes`. Record the note,
   the draft and send envelope ids, and the cost class on S3.
2. **Club submissions.** Mount the synthetic submissions; `trove present
   trove:club/ --as review` (text path on the dev box; transcribe and
   video.understand on the claimed gate host); as the owner, a student, a
   parent and an anonymous visitor, `trove ls trove:club/ --json` returns
   four different subsets; every rating carries `advisory: true`; the
   explorer page shows the same four views. Record on S8.

## Decisions

Taken by the operator on 2026-11-14: the name is **trove**; S10 is included
as an optional, separately committed core story; `mail:` and `cal:` are a p2
story in this sprint.

Reserved for the operator: whether advisory ratings may leave the host by
email at all; "mount" or "source" as the user-facing word.

## Not doing

Per-path access lists; writes to mail, calendar or GitHub; a FUSE mount; a
second text editor; replacing the `files` app; a core permission policy;
wish-log replay; index or embedding search; real student data; paid finals
without `--yes`; agent principals. Each is listed as a follow-up in the
design of record.
