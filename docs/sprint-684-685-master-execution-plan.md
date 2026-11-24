# Sprints 684 / 685: story review and master execution plan (MVP cut)

Epic: software shaping for group participation. State: **both sprints
delivered 2026-11-24** (results at the end of this page; planning record:
stories updated 2026-11-24 (reviewed with the operator 2026-11-23/24; the board
actions below are applied; no story is assigned yet). The sprint cards and
their stories are authoritative. Supersedes the sprint table in
`plan-group-participation.md`; the contract there still holds except where
this page says otherwise (one group model, no per-item role).

## Context

Sprints 684 (group shaping rod) and 685 (coverage + cross-outpost steering) are
in backlog with 6 and 7 stories. The operator's rules for this plan:

- **Page and Session first**: they are the features needed most urgently; the
  capability they need is history and revert, kept simple;
- the design follows bashy's existing software-shaping design, which already
  keeps revisions; no second model;
- KISS / MVP, rod not fish: the rod must be easy to extend later by shaping;
- no extra judge pass; unit tests per story; no integration work filed inside
  684/685; required integration tests become stories in Sprint 699, as part of
  the release;
- plan only from current code; every story starts after syncing and pinning to
  the `main`/`master` heads at that moment.

Baseline inspected (all 18 submodules verified at origin default-branch head,
clean, 2026-11-23): bashy `9a24fd30`, yoke `dcccc0fa`, outpost `f84b2a77`,
ycode `47ace486`. 

**Result: 13 stories become 6 small stories (17 points) plus 2 integration
stories in 699.** Everything else is unlinked or deferred, not deleted.

## Facts from the code

1. **Shaping already has the revision model** (`yoke/pkg/shape/slot/slot.go`):
   immutable retained versions (`Version{Revision, Digest, Created}` `:28`), one
   pointer (`State{Active, Previous}` `:37`), `Undo` swaps active and previous
   `:396`, `Restore(ref)` selects any retained version `:418`. A draft saves
   against `base_rev` (`yoke/pkg/webconsole/shaped_draft.go:86`). Verbs:
   `bashy shape history | undo | restore` (`bashy/internal/agentos/shape.go:60`).
2. **Page** (`bashy/examples/desk/page/main.go`): the item mixes authored
   content (`Title`, `Body`) with live and private state: participants, votes,
   timers, hands, form owner keys (`:86-114`). Every save bumps one counter and
   publishes a live frame (`saveLocked` `:269`). Only the organizer writes
   content (`mutate` `:634`). No history. Its README already says Sprint 684
   revisions replace the counter for content.
3. **Session** (`bashy/examples/session`): Python and Bash#, not Go. State is
   the sprint card plus an append-only event log; every owner change appends
   one event (`lib/run.py` `log` `:190`: `step_start`, `done`, `leave`, `time`,
   `pause`, `resume`, `skip`, `reorder`). Events carry no author, and there is
   no verb to read the log or step back. The Go server only holds link tokens
   and shells out to `bashy session VERB` (`server/main.go:361`).
4. **Desk kit** (`bashy/examples/desk/kit`, stdlib only, own module) has no
   revision store: `AtomicWrite` `kit.go:467`, 409 already maps to `conflict`
   `kit.go:129`, `Events.Publish` `events.go:113` is a notice stream.
5. **Notepad** is last-writer-wins with one member class (`notepad/main.go`
   `saveLocked` `:113`, `hasWriteAccess` `:142` equals `hasReadAccess` `:130`).
6. **`bashy share add` is a hosted relationship API call**
   (`yoke/pkg/fleet/share_grant_cmd.go:96`); a role or item path there is a
   hosted-plane change, which 684/685 forbid.
7. **Not buildable or not small now:** the draft lease (drafts are private per
   principal, Sprint 689 D1 is todo); cross-host steering (Sprint 679 is 0/6,
   no shared session hub); whiteboard read-only mode; film/video storyboards
   (plain files).
8. **Small and real:** `meet poll` bug `ed305169` (`yoke/pkg/meet/poll.go:89`).
   Form multi-respondent and brainstorm roles already work with unit tests.

## The group model: Klatch's, unchanged

Klatch is the group app, so its model is the model. From the code
(`bashy/examples/klatch/provision.py` `who` `:340`, `sync` `:362`; README):

- **The group is the app's audience on the host.** One roster, read with
  `bashy share who HOST/APP --json` → `{owner, emails[]}`, written with the
  existing `share add | rm`. Klatch converges its accounts to it; removal from
  the roster disables the account.
- **Two roles: owner and member.** Nothing finer.
- **An agent acts as its member**, with its name recorded beside the member
  (Klatch prefixes `[Assistant: NAME]`; `KLATCH_ASSISTANT`).

Page already admits by the same roster: outpost stamps each request with
`owner` or `member` and the member's email, derived from the same host grant,
and Page verifies it (`desk/page/identity.go:76-92`). So the apps and Klatch
share one model today; the plan keeps it that way:

| | Klatch | Page, Session, Notepad |
|---|---|---|
| who is in | roster pushed by `klatch sync` | same roster, as the signed stamp on each request |
| roles | owner, member | owner, member |
| removal | account disabled at next sync | refused at the next request |
| acting through an agent | `[Assistant: NAME]` | `author` = member, `assistant` = agent name on the revision |

Consequences: no new member list, no role names in the kit, no per-app invite
roles, no item path on `share`. The earlier "viewer/editor on the invite" idea
is dropped as a second, redundant model; a finer role can be added later as a
field on the one audience rule, for every app at once.

### Guests: anyone the owner lets in, by name

Everyone can be allowed to join, at the owner's discretion. This also exists
already and is reused, not rebuilt. Page records each participant with one of
three kinds (`desk/page/identity.go:38`, `resolveParticipant` `:164`):

| Kind | Who | How they get in | Known as |
|---|---|---|---|
| `member` | owner and roster members | the signed stamp, no prompt | their email |
| `signed-in` | signed in, not in the roster | the owner's link or code | a per-app pseudonym |
| `anonymous` | anyone else | the owner's link or code, then a join prompt asking for a name or email | that handle, bound to their browser and address |

The owner's switches are the ones Page ships: the item's audience
(`host`, `lan`, `satellite`), the join code or invite link, and
`participant kick | rename | merge`. Session's named links and Notepad's
invite codes are the same idea (the owner hands a link to a named person).

What the plan does with it:

- The revision `author` is that same participant identity, with its kind, so
  history reads "ana@… (member)" or "Ana (anonymous)".
- Guests take part (answer, vote, finish their own step). Whether a guest may
  edit content stays each app's existing rule: never on a Page, yes for a
  Notepad invite holder.
- Page's join code (stamp check, name prompt, cookie binding) moves into the
  kit as one unit when Notepad adopts it (S4), so there is one copy. Nothing
  new is designed: no accounts, no email verification, no guest roles.
- Klatch stays closed to its roster (accounts are required there); a guest
  row is "not applicable" in the matrix.

## The rod: shaping's revision model, applied to an artifact

Not a new model. The same words, the same pointer, the same JSON as
`bashy shape`, so a person or agent who knows one knows the other:

| | Shaping a tool (exists) | An artifact (this sprint) |
|---|---|---|
| a revision | immutable retained version | immutable snapshot of the authored content |
| current | `active` pointer, with `previous` | same |
| save | draft saved against `base_rev` | `set --base-rev R`; a different active revision refuses with both |
| back one | `shape undo APP` | `APP undo ITEM` |
| to any | `shape restore APP REV` | `APP restore ITEM REV` |
| list | `shape history APP` | `APP history ITEM` |
| JSON | `revision`, `created`, `active`, `previous`, `base_rev` | same fields, plus `author` |

Rules that keep it small and extensible:

- **The app chooses the bytes.** Page passes title + body only; votes, timers,
  participants, keys and the live frame counter stay out of history. Notepad
  passes the note body.
- **The app decides who may write; the store only records `author` and an
  optional `assistant`.** Page's organizer, Session's per-step owner and a
  Notepad member all fit, and none needs a role in the kit.
- **Snapshots sit beside the item**; the app's own file is untouched, so
  adoption breaks nothing. `--base-rev` is optional: without it a save is a
  recorded overwrite, as today.
- **One contract, two implementations.** Go desk apps use one small kit file
  (`desk/kit/revision.go`, shaped like `slot.go`: versions + pointer, `Save`,
  `Undo`, `Restore`, `History`, and one shared action handler). Session, which
  is event-sourced Python, serves the same verbs and JSON from the log it
  already keeps. An app in any language adopts by matching the contract.
- **Extension later, without changing the store:** more parts per item (a
  block, a storyboard), a finer role on the audience rule, more apps.

Not built now: merge, locks or leases, any role beyond owner and member, an
item path on `bashy share`, agent members as roster rows, `@NAME`, cross-host
steering.

## Story review and actions

### Sprint 684 → 4 stories, Page and Session first

| Story | Finding | Action |
|---|---|---|
| G3 revisions `3d3ca7b1` | The real gap; must mirror shaping (fact 1) | Keep as **S1** |
| Page history and revert `beb67c64` (new) | Most urgent; promised in the page README | File as **S2**, p1 |
| Session history and undo `5a302563` (new) | Most urgent; log exists, verbs and author missing | File as **S3**, p1 |
| Notepad co-edit `6f77b3f3` | Code plus a live run and the cut skill-script | Keep the code as **S4**, p2; live run moves to 699 |
| G2 share role `47a76966` | As written it changes a hosted API (fact 6), and a per-app role is a second group model beside Klatch's | Unlink; kept as a follow-up "role on the audience rule", not scheduled |
| G1 contract page `36e83cb5` (p0) | Cut on 11-21, still linked and shown as `next` | Unlink; the contract table above goes in the kit README with S1 |
| Klatch check `5b72b105` | Pure venue test | Move to 699 |
| Lease `13b6214a` | Not buildable (fact 7) | Move to Sprint 689 |
| Card | Acceptance lists the pre-cut scope | Rewrite to S1–S4, Page and Session first |

### Sprint 685 → 2 stories

| Story | Finding | Action |
|---|---|---|
| Poll row `596e3a0b` | The only code is bug `ed305169` | Keep as **C1** = that fix |
| Matrix `25a09059` | Fillable from the code now | Keep as **C2** (doc), with the steering inventory |
| Brainstorm `842b7bcc` | Roles exist and are tested | Matrix row; verdict from the 699 run |
| Whiteboard `c4bbeb92`, film/video `dc493ef9` | Not small (fact 7) | Matrix rows "follow-up filed with evidence" |
| X1 `04bc82b8`, X2 `b1ad7a71` | Need Sprint 679 | Unlink both; gated on 679 |
| Card | Acceptance requires X1/X2 and a run per app | Rewrite to C1 + C2 |

## Execution

### Step 0: pin baseline and gate venue (done 2026-11-24)

Every module is on its default-branch head and every sibling pin names that
head: bashsharp `fe4d68ad`, outpost `5f566a72`, ycode `8ad8cd19`, bashy
`6d88b2ac`, yoke `dcccc0fa`; umbrella gitlinks match. `bashy mod drift`
reports no stale pin. bashy and ycode require each other, so that one edge
always trails by exactly one pin-only commit; it is at that minimum.

Failures met on the way, each root-caused before anything was changed. All
were venue causes; no product or pin change was needed:

| Symptom on the gate host | Root cause | Fix |
|---|---|---|
| 44 tests in `bashsharp/cli` fail with "no required module provides package" | they build the sibling `bash`, `bashy` and `coreutils` binaries, which resolve only in the umbrella workspace; they were run in a lone clone with `GOWORK=off` | run bashsharp's suite from an umbrella checkout with submodules |
| `TestSourceRoute` fails with "compile: version go1.27.4 does not match go tool version go1.27.2" | the host's base Go was 1.27.2; it auto-switches for itself but hands child `go` processes a mismatched root | base Go is now 1.27.4, equal to every `go.mod` toolchain line |
| outpost `TestSSHProxyDirectFirstNeitherFailsFastNoPrompt` fails | the test asserts headless behaviour; the remote session had a controlling terminal | commands run under `setsid` |
| Page, Notepad, Form and Session tests fail with "unknown revision examples/desk/kit/v0.1.0" | the desk kit and chart versions are served only by bashy's local Go module proxy; the lane's proxy was empty and its bashy predated `mod proxy` | a current bashy runner, kit and chart published, `GOPROXY` naming the proxy |

With those in place: bashsharp (6 packages) and outpost `cmd/outpost` pass at
the heads above; ycode builds and passes its 83 short-test packages; bashy
builds and its pin and import tests pass; the kit, Page, Notepad, Form and the
Session server pass.

The venue is now one script, `script/gate-lane.sh`: `setup` installs it on a
Linux gate lane, `check` is the preflight (exit 0 only when the venue is
right), `run CMD` runs a command in it. Stories run their tests through it.

### Step 1: board hygiene (done 2026-11-24)

The Action columns above are applied to the cards and stories; unlinked
stories keep their ids and stay in the todo store.

### Step 2: stories

Order: S1 and S3 start together (S3 needs no kit); S2 after S1; S4 after S2.
C1 and C2 in parallel with all of them. One worker each, agy by default.

| # | Story | Files | Unit tests |
|---|---|---|---|
| S1 (3 pts, p1) | Kit revision store shaped like `slot.go`: immutable snapshots + active/previous pointer; `Save(base_rev)`, `Undo`, `Restore`, `History`; one shared action handler; contract table in the README; tag kit v0.2.0 | `desk/kit/revision.go` (new), `README.md` | `desk/kit`: save, stale base returns both, save without base, undo swaps, restore any, save after restore, history order, reload from disk |
| S2 (3 pts, p1) | Page: `page history ID`, `undo ID`, `restore ID REV`, `set --base-rev`; title + body only; organizer face lists revisions with a restore button | `desk/page/main.go` (`mutate`), `cli.go`; kit bumped | `desk/page`: content save recorded with author, stale 409, undo and restore bring the body back and leave votes, timers and participants intact, a participant action creates no revision; existing tests stay green |
| S3 (2 pts, p1) | Session: every event records its author; `session history N` lists the log in the contract's JSON; `session undo N` reverses the last owner change (`time`, `reorder`, `pause`/`resume`, `skip`, `done`); `goto` stays the restore-to-a-step verb | `session/lib/run.py`, `session.bsh` | `session/tests/test_run.py`: author on events, history shape, undo of each event kind, undo with an empty log refused |
| S4 (5 pts, p2) | Notepad adopts the store: same verbs, `export --rev N`. Page's join code moves into the kit unchanged (one copy); Notepad uses it, so a roster member is admitted by the stamp and an invited guest gives a name before joining; an outsider is refused | `desk/notepad/main.go`, `cli.go`, `export.go`; `desk/kit` (join code moved from `desk/page/identity.go`) | `httptest` with owner, member, named guest, outsider, bad signature: stale 409 with both, undo, restore, author and kind on each revision, guest without a name refused, export of a named revision; Page tests stay green |
| C1 (2 pts) | `meet poll` matches a choice on its key before `:`; the prompt asks for the key | `yoke/pkg/meet/poll.go` | `yoke/pkg/meet` table test with described choices |
| C2 (2 pts) | Coverage matrix: artifact, roles, shaping hook, entry point, revision adoption per app; steering inventory; follow-up rows filed | `docs/` | none (doc) |

Test commands: `GOWORK=off go test ./...` in `bashy/examples/desk/kit`,
`desk/page`, `desk/notepad`; `python3 -m unittest` for `examples/session/tests`;
`cd yoke && go test ./pkg/meet/`.

### Step 3: integration stories filed in Sprint 699

Run once on integrated main at the frozen commits, on the gate host, beside C4
of 682. Neither needs the hosted deploy.

| # | Story | Source |
|---|---|---|
| I1 | One group-shape skill-script (Bash#) composing the `--json` verbs, run against Page, then Session, then Notepad: `share add` a member, member admitted, history / undo / restore, `share rm`, removed member and outsider refused, a guest joins by code with a name and is kicked; PDF of a named Notepad revision; the same roster steps fill the matrix verdicts for Form and Brainstorm | move `9c585822cc31` |
| I2 | Klatch owner/member workflow: sync, two members, removal, outsider, repeat sync | move `5b72b105`; operator confirms before the instance starts |

Add both to the 699 card and `docs/sprint-699-master-execution-plan.md`.

## Rules for every story

- Entry: fetch, `bashy mod drift`, bump to heads, build + unit tests, then
  code. Rebase before submit; redo rather than repair a stale workspace.
- Worker instruction committed on the story before `sprint assign` (`--repo`,
  `--band 3`, points as above).
- Acceptance: the story's unit tests green on the gate host + conductor diff
  read, then `sprint accept`. No judge agent, no per-story integration run.
- A worker that needs more than the files listed stops and reports; scope is
  not widened in the story.
- After each merge: `bashy mod sync` + umbrella pin commit; announce on mb.
- No hosted-plane change, no release, no rc tag.

## Verification

- Step 0: `bashy mod drift` clean; per-module unit tests green.
- 684 closes when S1–S4 unit tests pass at the merged heads (S2 and S3 are
  accepted as soon as their own tests pass); 685 when C1 passes and C2 is
  merged.
- End to end: I1 and I2 in Sprint 699, evidence in
  `docs/sprint-699-evidence.md`.

## Decisions (settled with the operator, 2026-11-23/24)

1. One group model, Klatch's: the roster is the app's audience on the host,
   roles are owner and member. The viewer/editor role approved on 11-21 is
   dropped from 684 as redundant; it returns later as a field on the audience
   rule if needed.
2. Guests join by the owner's link or code and give a name or email first,
   exactly as Page does today; no new guest mechanism.
3. Page and Session get history and revert only.
4. Session `undo` reverses the last owner change; stepping further back uses
   the existing `goto`.
5. X1 and X2 leave 685 until Sprint 679 delivers the shared session hub.
6. Whiteboard and film/video get follow-up rows; the lease story moves to 689.

## Result (2026-11-24)

| | Sprint 684 | Sprint 685 |
|---|---|---|
| Stories | 4 of 4 | 2 of 2 |
| Duration | 2 h 55 min of a 48 h box | 1 h 7 min of a 24 h box |
| Manager | codex-gpt6.2-astra | agy-gemini4-hydrogen (one-sprint eligibility override) |
| Scorecard | auto-fail: 6 attribution bypass entries, none in code | no auto-fail, 0 bypass entries |

Delivered: S1 kit revision store (bashy `9db42aa8`, kit v0.2.0), S2 Page
(`416aad9e`), S4 Notepad and the shared join code (`68fd9961`, kit v0.3.0),
S3 Session (`9135c8c8`); C1 meet poll (yoke `c2d6591f`), C2
`group-shaping-coverage-matrix.md`. Each closed on its own unit tests on the
gate host at the merged commit and the manager's diff read.

Recorded as failing, not fixed here: ycode
`TestHarnessStreamWaitsForAppendNotifications` (bug `08ee6df70b5d`) and
`bashy/yoke/fetch` `TestStandaloneHelpAndDeps` (`bf5c8c71f65e`); both fail
identically before and after the pin changes of these sprints.

What follows:

- **Sprint 703** (backlog, planning only): the defects and gaps these sprints
  found but did not own. The agent's kb context (`08ee6df70b5d`, needs an
  operator ruling first), the two red tests, three load-sensitive ycode tests,
  the Session test teardown leak (`790d4c29d660`), lifting the revision wiring
  into the kit's shared handler (Page and Notepad carry about 250 and 580
  lines of their own), the board publishing story status and assignee to
  origin, the fleet probe and vendor quota, one agent name held by two live
  sessions, and `weave start --resume` (`5771d343ce2a`).
- **Sprint 699**: integration stories I1 and I2, unchanged. No test was added
  there: I1 already covers Page, Session and Notepad.

Rules these sprints added to the ones above: a candidate module version is
built only against a private proxy and private caches, and the shared proxy
sees a version once, after acceptance; umbrella pin commits are forward only
(the new gitlink must contain the one on origin); umbrella commits are made
from a worktree on the origin head, never from the shared checkout's local
`main`.
