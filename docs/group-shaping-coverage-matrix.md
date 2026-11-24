# Group-shaping coverage matrix and steering inventory

Sprint 685, story C2. Plan: `sprint-684-685-master-execution-plan.md`.
Doc only: nothing here changes product code. Every cell below was read from the
source at these heads: umbrella `a3bb61121`, `yoke` `dcccc0fa`, `outpost`
`5f566a72`, `bashy` checked out at `9135c8c8` (origin head `033fbe8f`; no file
under `bashy/examples/` differs between the two). A cell that says "none found"
means the code was searched and nothing turned up, not that it was proven absent.

Paths are relative to `bashy/examples/` (written `E/`) unless they start with
`yoke/`, `outpost/` or `bashy/`. Shared kit: `E/desk/kit` (`identity.go`,
`guard.go`, `revision.go`).

The Verdict column is filled by the Sprint 699 run (story I1); until then every
row reads `pending Sprint 699 I1`.

## Coverage matrix

| App/Tool | Artifact | Who may write | Guest door | Shaping hook | Bashy entry point | Revision adoption | Follow-up todo | Verdict |
|---|---|---|---|---|---|---|---|---|
| page | Item JSON `items/<id>.json` (Markdown, blocks, audience, participants); `E/desk/page/main.go:8`, `itemPath` `:215` | Organizer only for content: `mutate` gated by `canOrganize` = `isOwner` or organizer cookie (`faces.go:188`, `main.go:371`); participants act only through block actions, which create no revision (`TestParticipantActionsCreateNoRevision`) | Join code (`join_code.go:20`, `join_app.go:48,85`), anonymous handle prompt (`join_http.go:116`), single-use invite (`main.go:826,846`), verified outpost principal (`kit.IdentifyParticipant`) | `desk/page/shaped.json`; `register.sh:54` `app add --type shaped` | `bashy page` via `page.bsh`; verbs add, open, show, set, history, undo, restore, share, participant, block, export (`cli.go:26,284-311`) | done in Sprint 684 (kit `RevisionStore`, `main.go:295-296`; `revision_test.go`) | - | pending Sprint 699 I1 |
| session | Plan = sprint card of `step-NN` todos; run state = append-only `<sprint>.jsonl` (`E/session/lib/common.py:71-83`); server holds only link tokens (`server/main.go:1-4,209`) | Owner key (`ownerOK` `server/main.go:291,365-368`); a participant may only finish their own step (`:521,540`) | None for non-roster people: tokens minted per named step owner (`mintLocked` `:182`); `session join URL` (`:1103`); no invite flow | `session/shaped.json`; `register.sh:34` `app add --type shaped` | `bashy session` via `session.bsh:101-153` (plan, next, done, history, undo, serve, join ...) | done in Sprint 684 (event log: `history`/`undo` in `lib/run.py:88,285,411`; undoes only owner `UNDOABLE` events `:51,287-291`; no restore verb, no content snapshots; `tests/test_run.py:67-73`) | - | pending Sprint 699 I1 |
| notepad | Note JSON `items/<id>.json`, body history in the kit store (`E/desk/notepad/main.go:6,141`) | `noteAuthor` (`main.go:176`): verified member, owner (`isNoteOwner` `:169`), enrolled non-kicked participant, loopback caller; `share` owner-only (`:618`) | Single-use invite plus a handle (`share` `:612-632`, `join` `:636`, `kit.CleanHandle`/`ResolveParticipant`) | `desk/notepad/shaped.json`; `register.sh:58` `app add --type shaped` | `bashy notepad` via `notepad.bsh`; add, open, show, set, share, join, export, history, undo, restore (`cli.go:313,344-517`) | done in Sprint 684 (kit `RevisionStore`; whole note only, `--part` refused; `revision_test.go:70,161,207`) | - | pending Sprint 699 I1 |
| form | Definition + answers, `items/<id>.json`, integer `Revision` counter only (`E/desk/form/server/main.go:6,63,129`) | Definition and `ask`: owner (`isOwner` `:141`, `:473,575,761`). `answer` (`:359-360,653`) has no member check inside it (verify before relying) | One-respondent mode: single-use invite (`:426-437,751`) then `join` (`:~790-801`); many-respondent mode: reusable URL plus cookie `form-participant` (`:765`) | `desk/form/shaped.json`; `register.sh:28` `app add` | `bashy form` via `form.bsh`; add, open, show, set, share, close, wait, reply, ask, join (`main.go:5`) | can adopt the kit store (definition only; answers are separate) | - | pending Sprint 699 I1 |
| brainstorm | Session JSON `sessions/<name>.json` with cards, votes, phase, rounds, members; `Revision` counter (`E/brainstorm/server/main.go:151,174-177`) | Facilitator: `kit.Grant(FacilitatorKey)` (`:360`); participants add/edit/delete only their own cards in the write phase (`:647-657`) and vote; private sessions admit only facilitator and `Members` (`allowed` `:350`) | Open session: link plus cookie `brainstorm-participant` (`:367,589-591`); private session: single-use facilitator invite (`:740`, `join` `:588-620`) | `server/shaped.json` exists, but `register.sh:53` runs `app add brainstorm --port` (a port tile, not `--type shaped`); shaped registration is a manual README step (`README.md:155-161`) | `bashy brainstorm` via `brainstorm.bsh:182`; serve, backup, restore, add, open, show, set, list, share, close, vote, revoke | can adopt the kit store (caveat: multi-writer cards, not one document; today a counter plus round snapshots and `backup`/`restore`) | `todo:cb9b4b80a88d` (shaped registration); roster story `842b7bcc` | pending Sprint 699 I1 |
| chart | Item JSON `items/<id>.json`, counter `Revision` (`E/desk/chart/main.go:48-60,69,103`) | Owner only (`isOwner` `:115-116`; `mutate` `:299`, `share` `:370`, `revoke` `:468`); members read-only (`:282`) | Single-use invite, read-only guest (`share` `:~370-380`, `join` `:400-406`) | `desk/chart/shaped.json`; `register.sh:19` `app add chart --type shaped` | `bashy chart` via `chart.bsh` (builds and execs the Go binary); add, open, show, set, close, list, share, revoke, join | can adopt the kit store (body/config) | - | pending Sprint 699 I1 |
| viewer | Book: ordered append-only pages plus assets, `items/<id>.json` (`E/desk/viewer/main.go:15`) | `canWrite` = loopback caller or facilitator key (`main.go:163-165`; `local` `:153`); gates `appendPage` `:372` and `share` `:545,564` | Single-use invite, read-only member (`share` `:545-549`, `join` `:582-586`, `canRead` `:159`) | `desk/viewer/shaped.json`; `register.sh:58` `app add --type shaped` | `bashy viewer` via `viewer.bsh`; add, append, open, show, list, share, close, join, export (`main.go:270-294`) | not applicable (append-only by design; `set|edit|put` refused `main.go:294`, `viewer_test.go:96,110`) | - | pending Sprint 699 I1 |
| whiteboard | Board record `boards/<id>.json` plus scene blob `scenes/<id>` and `files/` (`E/whiteboard/server/desk.go:21-37`, `storage.go:65,97`); live canvas is in-memory socket diffs (`README.md:70-71`) | No access check: `OwnerKey` generated (`desk.go:197-203`) but never compared; `Locked` set by `close` (`:270`) but `set` ignores it (`:247-253`); collab accepts any session, CORS `*` (`collab.go:92`); `README.md:38-40` says loopback plus the paired console is the boundary | `share` returns `prefix/#room=<id>` (`desk.go:~290`); anyone with the link and reach joins | `whiteboard/shaped.json`; `register.sh:5-10`; `whiteboard.bsh:68` `app add --type shaped` | `bashy whiteboard` via `whiteboard.bsh`, data verbs in `whiteboard_api.py` | can adopt the kit store (scene blob as a part); today only an integer counter (`desk.go:~245,271`) | `todo:78bc2bb3f32b` (no read-only mode; one collab server per principal: `server/main.go:76`, `collab.go:15-17`, `README.md:5,107`); story `c4bbeb92` | pending Sprint 699 I1 |
| film | `PROJECT/storyboard.json`, schema `bashy-film-storyboard-v1` (`E/film/film.bsh:110,272-283`), plus `drafts/`, `finals/`, `lock/` | Filesystem permissions only; no access code | None | None: no `shaped.json` or `register.sh`; listed in `bashy/internal/agentos/adapterembed/examples/defaults/bashy-defaults.bsh:104` | `bashy film init|draft|lock|final|status|doctor` (`film.bsh:9-10,28-32`) | can adopt the kit store. Existing named-revision analog: `lock` (`cmd_lock` `film.bsh:975-1030`, `bashy-film-lock-v1` with per-file sha256 `:1019-1022`, refuses on a changed storyboard `:994-995`, `final` verifies it `:555`); single slot, no history (`rm -rf` and `mv` `:1025-1026`) | `todo:ba8f2b5cb347` (storyboards are plain files); story `dc493ef9` | pending Sprint 699 I1 |
| video | `PROJECT/storyboard.txt`, one segment per line (`E/video/video.sh:410,434`); output `build/demo.mp4` | Local filesystem only | None | None; `README.md:8` "an example, not a bashy command" | `video.sh doctor|cameras|build|render|run|clean` (`:471-476`) and `bashy dag examples/video` (`dag.md`); the `video` entry in `bashy-defaults.bsh:114` is the unrelated `video.understand` door | can adopt the kit store (storyboard.txt as one part); today none | `todo:ba8f2b5cb347`; story `dc493ef9` | pending Sprint 699 I1 |
| board | Kaneo projects, tasks and columns in a per-principal Postgres cluster (`E/board/README.md:36-37`, `board-console/main.go.tmpl:195-201,365-411`) | Upstream auth; the CLI sends the principal's `BOARD_TOKEN` (`board_api.py:184-211`); not enforced in this repo | None found in this repo; projects have a `public` flag (`board_api.py:26,34`) enforced upstream | `board/shaped.json`; `register.sh`; `board.bsh:67` `app add --type shaped` | `bashy board` via `board.bsh` and `board_api.py` | not applicable (data is Postgres, not files; kit store writes files) | - | pending Sprint 699 I1 |
| table | Grist documents under `<data>/docs` and `<data>/landing.db` (`E/table/shape-adapter/main.go:65-66`) | The principal's own server process (`main.go:26-36`); CLI needs `TABLE_TOKEN` (`README.md:97-98`) | None found | `table/shaped.json`; `register.sh`; `table.bsh:68` `app add --type shaped` | `bashy table` via `table.bsh` and `table_api.py` | not applicable (Grist owns its storage) | `todo:2f6d27f53940` (Linux only: `table.bsh:54-56,73,146`; `README.md:3,10`) | pending Sprint 699 I1 |
| notes | Memos in the pinned `memos-shape` fork's own database (`E/notes/notes.bsh:8`, `notes_api.py:1`) | Upstream decides; client sends `NOTES_TOKEN` (`notes_api.py:122-124`); permission_denied for non-owners (`README.md:106,113`) | Memo visibility PRIVATE/PROTECTED/PUBLIC/SPACE (`notes_api.py:64-67`); no door in this directory | `notes/shaped.json`; registered by `notes.bsh:56` (`install`), not `register.sh` (`:5` only adds the command) | `bashy notes` via `notes.bsh`; list, show, add, set, archive, rm, search, export (`notes_api.py:23`) | not applicable (upstream app owns content; README's history is shaping history, `README.md:42-57`) | - | pending Sprint 699 I1 |
| site | Hugo-style tree `content/*.md`, `layouts/`, `static/`, `hugo.toml`, output `public/` (`E/site/README.md:19-37`, `generator/main.go:52,126`) | Sveltia CMS `/admin` commits Markdown (`README.md:50-52`); no auth code here, console `--auth` governs | `publish-outpost` public by default, `--private` to require an outpost login (`site.bsh:29-32`, `E/desk/kit/outpost.bsh:10-19`); published site is read-only static | No `shaped.json` at the site root (only `site/chat/shaped.json`); `site.bsh:184-188` `site_shape_register` runs `app add --type shaped` (not verified to work without one) | `bashy site new|build|serve|edit|publish-outpost|unpublish-outpost|publish-pages|shape-register` (`site.bsh:217-224`); `site new --template chat` routes to `site/chat/chat.bsh` (`:192-194`; Linux only `chat.bsh:29`) | not applicable (git is the history; `site_publish_pages` commits `site.bsh:177`) | - | pending Sprint 699 I1 |
| clips | Job JSON `jobs/<id>.json`, rendered files in `clips/` (`E/clip/server/job.go:74`) | No access check in `server/*.go`; only the loopback default `127.0.0.1:22807` (`main.go:360`); `POST /api/jobs` unauthenticated (`page.go:33`) | None | `clip/shaped.json`; `register.sh:19` `app add --type shaped`; `clip_test.go:424` checks the manifest | `bashy clips` (not `clip`, already the clipboard skill) via `clip.bsh`; queue, status, work, take, serve, doctor (`main.go:25-34`) | not applicable (mutable status files and binaries; no history in README). Capture is Linux X11 only (`clip_test.go:232-262`) | - | pending Sprint 699 I1 |
| files | Files under the confined scope root served by the embedded File Browser, an in-process outpost capability (`outpost/cmd/outpost/capability_files.go:11-22,89-96`; `BuiltinFiles` `outpost/internal/agent/builtin_apps.go:60`) | Read-only unless `settings.allow_write`, which only the host can set (`capability_files.go:19-22,57`); login required (`:112`) | None: login required | None: in-process, registered as a normal `http` app (`builtin_apps.go:56-59`); service declaration `yoke/pkg/fleet/baseline/services/files.yaml:1-9` | None: `bashy/internal/agentos/atlas.go:1423` says Terminal and Files deliberately have no `bashy files` verb | not applicable | - | pending Sprint 699 I1 |
| klatch | Server accounts, contacts, groups, messages (server is not in this repo; `E/klatch/` is a CLI wrapper plus `provision.py`) | Account holders; admin operations use the admin password | Roster sync, no open door: `bashy share who HOST/APP --json` then `PUT /admin/sso/roster` (`provision.py:340-370,114-115`; `klatch.bsh:109-125`); external contacts refused (`README.md:15`, `provision.py:109-111`). `provision.py:112` sends `setOpenAccess` while `CONFIG_BODY` has `enableOpenAccess: False`: interaction not resolved | None: `register.sh:6` only adds the command | `bashy klatch setup|provision|status|sync|post-file` plus participant verbs (`klatch.bsh:63,100`) | not applicable (chat server; `messages-edit`/`messages-delete` only) | - | pending Sprint 699 I1 |

Counts (17 rows): 3 done in Sprint 684 (page, notepad, session); 6 can adopt the
kit store (form, brainstorm, chart, whiteboard, film, video); 8 not applicable
(viewer, board, table, notes, site, clips, files, klatch).

## Follow-ups filed (standalone, not linked to Sprint 685)

| Todo | Gap | Why it is not small |
|---|---|---|
| `78bc2bb3f32b` | whiteboard: no read-only mode, no write gate, one collab server per principal | a read-only join in the collab protocol plus multi-principal reach to one server |
| `ba8f2b5cb347` | film and video storyboards are plain files; film `lock` is the only named-revision analog | needs kit-store adoption and a group-edit path in two bash tools |
| `cb9b4b80a88d` | brainstorm: `register.sh` adds a port tile, not a shaped app | shaped build path plus a decision on the `0.0.0.0` default (`server/main.go:30`) |
| `2f6d27f53940` | table: Linux only (recorded exception) | an exception to record, not a fix |

Existing stories left as they are: `c4bbeb92` (whiteboard live viewer),
`dc493ef9` (video/film co-edit), `842b7bcc` (brainstorm circle participants),
`3aa3e25a` (same-origin framing of whiteboard and table).

## Steering inventory

What can steer what, from the code.

1. **A shared-session directive reaches a weave run on another host.**
   `yoke/pkg/weave/weave_directive.go`: `runWeaveConduct` (`:295`) polls a joined
   shared session (`sessionClientForRepo`, `:302-307`; interval default 3s,
   `:382`). `consumeDirectives` (`:36`) reads events of kind `directive` through
   `SessionClient.GetEvents` (`:37,46`), skips gateway-task directives (`:49-52`),
   and `applyDirective` (`:118`) handles `say`, `add`, `prio`/`prioritize` and
   `kill`; any other verb yields `unknown_verb`. `say` types a line into the run's
   control socket only if the run is `working` with a live wrapper pid
   (`applyDirectiveSay` `:171-188`). A cursor file `directive-cursor` (`:272-290`)
   makes consumption resumable, and each directive is acknowledged
   (`directiveAckDetail` `:29`).
2. **It does not reach a bashy chat session.** `yoke/pkg/chat/cmd_interact.go`
   has no reference to a session client, `GetEvents`, `directive` or a remote
   host. `chat steer` (`:241`) resolves a card in the host room (`findMember`
   `:29`) and delivers through the session's control socket or steer inbox
   (`steerCard` `:358`, `SteerableCard` `:354`) on the same machine, and emits a
   local `room.EventSteer` (`:293`). A session launched with neither a control
   socket nor an inbox cannot be steered at all (`:156`). So a directive from a
   shared session has no consumer that calls `chat.Steer`.
3. **No inbound A2A server is wired.** `yoke/pkg/herald` is client only: it
   imports `a2aproject/a2a-go/v2/a2a`, `a2aclient` and `a2aclient/agentcard`
   (`client.go:11-13`) and dials peers (`herald.go:7-62`, `CardPath` `:72`).
   A search of `yoke`, `outpost`, `bashy/internal` and `bashy/cmd` finds no
   `a2asrv` import (`yoke/go.mod:402` carries only `a2a-go/v2 v2.3.1`) and no
   handler serving `/.well-known/agent-card.json`. `herald acp` (`herald.go`,
   `acp.go:57`, `acp.NewAgent`) exposes this machine as an ACP agent, not A2A.
4. **Cross-outpost steering is not built and waits for Sprint 679.** X1
   `04bc82b8` (inventory, protocol choice, smallest missing link inside one
   circle) and X2 `b1ad7a71` (one group across hosts, two humans and their
   agents) are unlinked from Sprint 685 and gated on Sprint 679 (the shared
   session hub); see the plan, "Sprint 685 → 2 stories". Files:
   `docs/todo/04bc82b80f56-x1-*.md`, `docs/todo/b1ad7a71c13f-x2-*.md`.
