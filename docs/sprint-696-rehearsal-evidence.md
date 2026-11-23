# Sprint 696 — page dress rehearsal evidence and Sunday class runbook

Story `142b21dad07f` (#660, p2 UAT). Spec: `docs/page-live-group-page.md`.
The class is a test case for `page`, not the product: class-specific
outcomes go to the class repository; defects come back here as todos.

## (a) Identity, venue and verdicts

| Item | Value |
|------|-------|
| bashy base | `origin/main` `6b743ec2` (feat(page): templates, genie examples and the one-page runbook) |
| Story branch | `s696-142b21dad07f` = `6b743ec2` + `3a3e4657` (test: `page` joins the `assertRegisteredGenie` set) + `6f16fecf` (fix: shaped-fork clone skips sibling-source tests) + `b6b7b244` (fix: join form sends its real Origin on a LAN address) |
| Candidate on the gate host | `6b743ec2` checkout + `git diff 6b743ec2 b6b7b244` applied (sha256 prefix `12bb7a97fc9f9aed`), `git status` shows exactly the five story files |
| Venue | `<claimed-gate-host>.lane1`, lease epoch 10, claimed by the sprint manager — the Windows gate host, its Ubuntu 24.04 WSL2 distro, reached attached through `outpost ssh exec --timeout 10m <alias> -- wsl.exe ...`; a scratch directory removed after the run |
| Toolchain there | Go 1.27.4 (`GOWORK=off`), Node v22.12.0 (scratch), Playwright, Google Chrome 143 at `/usr/bin/google-chrome` |
| Dev box | macOS; only module-local `go test` for `desk/kit` and `desk/page`. No browser, Chrome, Playwright, full bashy build or D2 there |
| Final runs | 2026-11-23, D2 16:17–16:21Z, D1/D3/D4 driver immediately after; `driver-exit=0`, `node checks done; failures=0`, 64/64 `CHECK ... PASS` |

| Check | Verdict | Note |
|-------|---------|------|
| D1 real-browser `EventSource` live stream | **PASS** | after fix `b6b7b244` (root cause below) |
| D2 `TestDeskRegisterScriptsUsePublicShapedAppPath/page` | **PASS** | after fix `6f16fecf` (root cause below) |
| D3 real headless-Chrome `page export --to pdf` | **PASS** | `%PDF-1.4`, 5 pages, block states in text, zero leaks |
| D4 two-door multi-identity dress rehearsal | **PASS** | both doors, every block and face, 19-value store-secret export audit clean |

### Defects found and fixed (root cause first)

1. **D2 — shaped fork could not pass its own required check (test
   defect).** `register.sh` forks `page` into a shaped app whose clone
   holds only `page`. `startForm` / `startBrainstorm` in the page tests
   built `../form/server` and `../../brainstorm/server`, which do not
   exist in that clone, so the fork's required `go test` failed and `src
   activate` refused. Fix `6f16fecf`: those tests skip when the sibling
   source is absent; in the bashy tree they still run.
2. **D1 — every real-browser join on the LAN door was refused (product
   defect).** Run 179 and the first relaunch run recorded, verbatim:

   ```
   browser response 403 POST /dress-rehearsal {"error":{"code":"request_failed","message":"Use the page page"},"schema_version":"bashy-page-v1"}
   CHECK browser-eventsource-connects: FAIL none
   ```

   The request headers Chrome sent, captured with Playwright `allHeaders()`:

   ```
   browser POST /dress-rehearsal {"host":"192.0.2.10:28113","origin":"null","referer":""}
   ```

   Cause: the join screen is the desk's only native `<form method=post>`.
   The kit-wide `Referrer-Policy: no-referrer` makes Chromium send
   `Origin: null` for it. The LAN door is plain HTTP on a non-loopback
   address, which is not a potentially trustworthy origin, so Chromium
   sends **no `Sec-Fetch-Site`** either. `kit.GuardPOST` therefore cannot
   tell the join from a cross-site post and refuses it. The brief's
   proposed fix (accept `Origin: null` only with `Sec-Fetch-Site:
   same-origin`) was implemented first and re-run on the gate host: it
   still failed (same 403). That pairing only occurs on loopback or HTTPS,
   and accepting `null` without fetch metadata would admit cross-site
   posts, so it was withdrawn before commit. Fix `b6b7b244`: the join
   screen answers with `Referrer-Policy: same-origin`, so the browser sends
   its real Origin there and still nothing cross-origin; `GuardPOST` is
   unchanged and a null Origin stays refused (unit test in
   `page/join_test.go`, red without the fix). After the fix:

   ```
   browser POST /dress-rehearsal {"host":"192.0.2.10:28113","origin":"http://192.0.2.10:28113","referer":"http://192.0.2.10:28113/dress-rehearsal"}
   browser response 303 POST /dress-rehearsal
   ```

## (b) Evidence (scrubbed, verbatim)

Every Chrome/Playwright invocation ran under `env -u DISPLAY -u
WAYLAND_DISPLAY` with `--disable-gpu`. Participant addresses are RFC 5737
`192.0.2.10–14` on a dummy interface in the WSL2 distro (`192.0.2.21–22`
as forwarded tunnel clients). Identities are fake; cookie, fingerprint and
key values in the raw log are rehearsal-only and are not reproduced here.

### Unit tests on the gate host, then D2

```
BASE=6b743ec24152 + candidate diff sha256=12bb7a97fc9f9aed
 M examples/desk/page/block_board_test.go
 M examples/desk/page/block_form_test.go
 M examples/desk/page/join_code.go
 M examples/desk/page/join_test.go
 M examples/desk/register_shaped_test.go
ok  	desk-kit	0.532s
ok  	desk-kit/cmd/atlas	0.268s
ok  	desk-kit/contracttest	0.005s
ok  	desk-kit/internal/fixture	7.571s
ok  	desk-kit/render	0.088s
ok  	page	9.340s
?   	page/blocks	[no test files]
2026-11-23T16:17:42Z
=== RUN   TestDeskRegisterScriptsUsePublicShapedAppPath
=== RUN   TestDeskRegisterScriptsUsePublicShapedAppPath/page
--- PASS: TestDeskRegisterScriptsUsePublicShapedAppPath (199.53s)
    --- PASS: TestDeskRegisterScriptsUsePublicShapedAppPath/page (176.88s)
PASS
ok  	github.com/qiangli/bashy/examples/desk	199.539s
d2-exit=0
2026-11-23T16:21:02Z
```

The subtest drives `register.sh` (`app add --type shaped`), `app show`,
`app list`, the live shaped console's `/_shape/page.js` and
`/_shape/genie.js` injection on `/page/`, `src activate`, `src pr merge`
and `src undo`.

### D4 setup — siblings, one fixed port, class page from a template

```
## build
brainstorm
form
notepad
page
viewer

## LAN addresses (RFC 5737 on a dummy interface)
s696lan          UNKNOWN        192.0.2.10/24 192.0.2.11/24 192.0.2.12/24 192.0.2.13/24 192.0.2.14/24

## siblings
healthz :28107 200
healthz :28091 200
healthz :28096 200
healthz :28095 200

## page serve --lan (both doors, one fixed port)
{"app":"page","commands":[["outpost","apps","add","page","--url","http://127.0.0.1:28113/","--trust-cloud-identity","--require-login"]],"dryRun":true,"icon":"","public":false,"requireLogin":true,"schema_version":"bashy-page-v1","target":"http://127.0.0.1:28113/","verb":"publish"}
desk: --lan override: binding 0.0.0.0:28113 beyond loopback; anyone who can reach this host there can open the tool (no LAN identity)

## class page from templates/meeting.md
CHECK owner-key-returned: PASS
block: poll-1 (poll form-8294502de227)
block: form-1 (form form-08f74595e114)
block: anon (poll form-cc493820cc76)
block: board-1 (board page-afd6cf2db23f)
blocks: [('here-1', 'here'), ('hands-1', 'hands'), ('timer-1', 'timer'), ('timer-2', 'timer'), ('timer-3', 'timer'), ('book-1', 'book'), ('note-1', 'note'), ('notes-frame', 'embed'), ('sketch', 'embed'), ('poll-1', 'poll'), ('form-1', 'form'), ('anon', 'poll'), ('board-1', 'board')]
{'id': 'rehearsal', 'join_code': 'dress-rehearsal', 'lan_url': 'http://<claimed-gate-host>.local:28113/dress-rehearsal', 'schema_version': 'bashy-page-v1', 'status': 'filled-by-agent', 'url': 'http://127.0.0.1:28113/dress-rehearsal'}
CHECK board-facilitator-key-held: PASS
```

The page is `templates/meeting.md` plus `book:rbook/p1`, `note:rnote`, a
same-origin `embed:/notepad/?id=rnote` and a non-kit `embed:/whiteboard/`,
then `page block add poll ... --votes 3`, `page block add form --def`,
`page block add poll ... --anonymous` and `page block add board`, with
`PAGE_SSO_SECRET` set to a rehearsal-only random secret.

### D4 — identities on both doors, every block and face

```
CHECK sat-member-join: PASS status=303
CHECK sat-anon-no-client-address-refused: PASS status=403
CHECK sat-anon-forwarded-192.0.2.21-enrolls: PASS status=303
CHECK sat-anon-forwarded-192.0.2.22-enrolls: PASS status=303
CHECK lan-join-Bea@192.0.2.11: PASS status=303
CHECK lan-join-Cal@192.0.2.12: PASS status=303
CHECK lan-join-Dee@192.0.2.13: PASS status=303
CHECK lan-duplicate-handle-other-address-409: PASS status=409
CHECK sat-member-uses-pseudonym: PASS
CHECK poll-ada-3: PASS
CHECK poll-bea: PASS
CHECK poll-cal: PASS
CHECK poll-sky: PASS
CHECK poll-over-budget-400: PASS status=400
CHECK lan-refresh-keeps-identity: PASS status=200
CHECK poll-bea-revote-after-refresh: PASS
CHECK lan-cookie-loss-reclaim-same-address: PASS status=303
CHECK poll-bea-vote-after-reclaim: PASS
CHECK poll-unenrolled-impostor-refused: PASS status=403
CHECK poll-bea-counted-once: PASS count=4 bea-rows=1 bea-final=["Alpha"]
CHECK form-ada: PASS
CHECK form-bea: PASS
CHECK form-tao: PASS
CHECK anon-cal: PASS
CHECK anon-dee: PASS
CHECK anon-poll-no-handles: PASS
CHECK board-card-ada: PASS status=200
CHECK board-card-bea: PASS status=200
CHECK board-phase-discuss: PASS
CHECK board-phase-vote: PASS
CHECK board-vote-bea: PASS status=200
CHECK board-write-refused-in-vote-phase-409: PASS status=409
CHECK face-organizer-has-controls: PASS
CHECK face-participant-no-organizer-controls: PASS
CHECK face-display-200: PASS
CHECK preview-face-active-respondent: PASS
CHECK preview-uses-own-identity-cookie: PASS page-preview-rehearsal
CHECK preview-answer-accepted: PASS status=200
CHECK preview-isolation-tally-unchanged: PASS
CHECK embed-same-origin-frame: PASS
CHECK embed-whiteboard-link-out-card: PASS
CHECK book-inline: PASS
CHECK note-inline: PASS
CHECK participant-html-no-addresses-cookies-keys: PASS
CHECK participant-state-no-addresses-keys: PASS status=200
CHECK here-organizer-sees-address: PASS
CHECK here-participant-no-address: PASS
```

The satellite member is an HMAC-signed `X-Outpost-Relationship: member`
request and shows as its app pseudonym `ada-pseudonym-7f3a`; the anonymous
signed tunnel request without a client address is refused (outpost
follow-up `a1333108286e`). The organizer CLI afterwards:

```
Pick up to three (poll poll-1, open, 5 responses)
  Alpha: 2 (Bea, ada-pseudonym-7f3a)
  Beta: 2 (Cal, ada-pseudonym-7f3a)
  Gamma: 3 (Cal, Dee, ada-pseudonym-7f3a)
  Delta: 1 (Sky)
Anonymous check (poll anon, open, 2 responses)
  Yes: 1
  No: 1
Sign-in sheet (form form-1, open, 3 responses)
  Bea: Team=Blue; Lead=no
  Tao: Team=Green; Lead=
  ada-pseudonym-7f3a: Team=Red; Lead=yes
```

### D1 — live stream: protocol resync, then a real browser

```
sse first connect status 200 ids [ '8915699e6796-31', '8915699e6796-32' ] sample [
  'retry: 2000',
  'id: 8915699e6796-31',
  'data: {"item":"rehearsal","block":"","revision":22}'
]
sse reconnect with Last-Event-ID 8915699e6796-32 got [
  'retry: 2000',
  'id: 8915699e6796-33',
  'data: {"item":"rehearsal","block":"here-1","revision":22}',
  'id: 8915699e6796-34'
]
CHECK sse-last-event-id-replays-missed-frames: PASS
browser POST /dress-rehearsal {"host":"192.0.2.10:28113","origin":"http://192.0.2.10:28113","referer":"http://192.0.2.10:28113/dress-rehearsal"}
browser response 303 POST /dress-rehearsal
browser response 404 GET /notepad/?id=rnote {"error":{"code":"not_found","message":"Not found"},"schema_version":"bashy-page-v1"}
browser after join: /dress-rehearsal title: Page · bashy desk cookie: true
CHECK browser-eventsource-connects: PASS /api/events?id=rehearsal&view=participant
CHECK browser-poll-tally-live: PASS
CHECK browser-hands-raise-live: PASS
CHECK browser-hands-next-live: PASS
CHECK browser-timer-start-and-ticks-live: PASS timer-1: explore 15:00 Running -> explore 14:58 Running
CHECK browser-board-vote-live: PASS
CHECK here-browser-participant-online: PASS
CHECK browser-no-reload-during-live-updates: PASS navigations after join=0
CHECK browser-display-face-renders: PASS
CHECK here-offline-with-last-seen-after-close: PASS
node checks done; failures=0
node-exit=0
```

The browser joined by typing a handle and pressing Enter, as a person
does. While other identities voted, the organizer started the timer, a
hand was raised and `next` called, and a board card was voted, each block
changed in the DOM with zero navigations. The `404 /notepad/` is the
same-origin embed frame: standalone `page serve` mounts only `page`, so a
same-origin path to a sibling resolves only behind the console or outpost
app shell (see the runbook).

### D3 — close, export, audit

```
rehearsal http://127.0.0.1:28113/dress-rehearsal closed
export md exit=0 size=3112
export html exit=0 size=39084
export pdf exit=0 size=509691
%PDF-1.4
CHECK pdf-magic: PASS
pdf streams decoded: 13 pages: 5

## export audit
store secret values collected: 19
record.md address/cookie/key pattern hits=0 secret-value hits=0
CHECK export-record.md-clean: PASS
record.html address/cookie/key pattern hits=0 secret-value hits=0
CHECK export-record.html-clean: PASS
CHECK export-pdf-raw-clean: PASS
```

The rendered PDF text, extracted with `pypdf` 5.1.0 in a scratch venv on
the gate host (it has no `pdftotext`). The 39 values are the 19 store
secrets plus the cookies and keys the driver held:

```
pdf pages: 5
record.pdf text has: Pick up to three
record.pdf text has: Alpha
record.pdf text has: Sign-in sheet
record.pdf text has: Anonymous check
record.pdf text has: Ideas
record.pdf text has: Ship weekly
record.pdf text has: Reading one
record.pdf text has: Shared note
record.pdf text has: Participants
record.pdf text has: closed
record.pdf text address/cookie/key pattern hits=0 secret-value hits=0 (of 39 store secrets)
```

`record.md` participants section — handles and auth kind only:

```
- Bea (anonymous)
- Cal (anonymous)
- Dee (anonymous)
- Sky (anonymous)
- Tao (anonymous)
- ada-pseudonym-7f3a (member)
```

## (c) Operator runbook — live class, Sunday 2026-11-29

The satellite door is primary; the LAN door is the fallback. One fixed
port serves both. The general procedure is the bashy kb runbook
`run-a-class-or-meeting-on-one-page`; this is the class-day checklist.

### T−60 min: pre-flight (go / no-go)

1. On the class host: `bashy --version`, and check that `page --help`
   resolves (registered through `examples/desk/page/register.sh`).
2. Start the sibling apps, each in its own attached terminal, on
   loopback: `form serve`, `brainstorm -addr 127.0.0.1:18091 -data DIR`
   (brainstorm binds all interfaces by default), `viewer serve`, `notepad
   serve`. `curl -fsS` each app's `/healthz`. If an app is not on its
   default port, point the page at it with `PAGE_FORM_URL` /
   `PAGE_BRAINSTORM_URL`.
3. Pick one fixed port, e.g. `P=8090`, and set the outpost secret
   (`PAGE_SSO_SECRET`) the satellite door was published with:

   ```bash
   page publish-outpost --port $P     # satellite door: signed-in visitors
   page serve --lan --port $P         # LAN door: same listener; keep this terminal attached
   ```

4. Create the class page from a template with a short code. Keep the
   organizer link and the owner key private:

   ```bash
   page add -f templates/agenda.md --title "Sunday class" --audience lan --code sunday-class
   page open PAGE                     # satellite link, LAN link, QR codes, bare code
   ```

5. Smoke test from a second device: open the satellite link while signed
   in, join, raise a hand, and see it on the organizer view. Then open the
   LAN link from a phone on the room Wi-Fi, type a handle and press Enter
   (a real browser form post, the path D1 caught), and vote once.
6. **Go** only if steps 1–5 pass. **No-go trigger:** any step fails and
   is not fixed by T−15 min. In that case, use the fallback below.

### During class

- Share the **satellite link first**, then the LAN link and QR code as
  the fallback for anyone who cannot sign in. The bare code works at the
  page root on either door.
- Project `?view=display`; drive from the organizer link. Use
  `?view=participant` to preview what the room sees; preview answers do
  not count.
- **Seconds (data verbs, live):** `page block add poll PAGE --options
  "A,B,C" --votes 3`, `page block close|show-results PAGE BLOCK`, `page
  block results PAGE BLOCK`, `page block add form PAGE --def FILE`, `page
  block add board PAGE --title T`, `page set PAGE -f agenda.md` (for
  `note:`, `book:`, `embed:`, `timer:` blocks), `page hands list|next
  PAGE`, timer controls on the organizer face.
- Material: prefer inline `book:` and `note:` blocks. Under standalone
  `page serve`, a same-origin `embed:/notepad/...` frame has nothing to
  load (rehearsal `404`); give the sibling's own link instead.
- **Minutes (shaping):** use `bashy shape wish page '...'` only for a
  change that was rehearsed beforehand, and verify and preview it before
  you approve it. Never shape live what a data verb already does.
- Moderate with `page participant PAGE list|rename|merge|kick`.

### After class

```bash
page close PAGE
page export PAGE --to md   -o <class-repo>/records/2026-11-29.md
page export PAGE --to html -o <class-repo>/records/2026-11-29.html
env -u DISPLAY -u WAYLAND_DISPLAY page export PAGE --to pdf -o <class-repo>/records/2026-11-29.pdf
```

Before you commit to the class repository, grep the exports for any
address or key. Exports are designed to carry only `handle (auth)`. Then
`page unpublish-outpost`, and record the outcome and any defects: the
outcome in the class repository, and each defect as a todo on Sprint 696
here.

### Fallback: today's tools

If pre-flight fails, or the page fails mid-class and is not back within
five minutes, run the class on the standalone apps: `form` for the ballot
and the collection, `brainstorm` for the board, `viewer` and `notepad` for
the material, and a plain timer. Share each app's own link. Keep the
`page` terminal output and the failure time for the root-cause record.
