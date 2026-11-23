# Sprint 696 — page dress rehearsal evidence and Sunday class runbook

Story `142b21dad07f` (#660, p2 UAT). Spec: `docs/page-live-group-page.md`.
The class is a test case for `page`, not the product: class-specific
outcomes go to the class repository; defects come back here as todos.

## (a) Identity, venue and verdicts

| Item | Value |
|------|-------|
| bashy base | `origin/main` `6b743ec2` (feat(page): templates, genie examples and the one-page runbook) |
| Story branch | `s696-142b21dad07f` = `6b743ec2` + `3a3e4657` (test-only: `page` joins the `assertRegisteredGenie` set in `examples/desk/register_shaped_test.go`) |
| Venue | `<claimed-gate-host>.lane1`, lease epoch 10, claimed by the sprint manager — the Windows gate host, its WSL2 distro, scratch `/tmp/s696-uat-$$` |
| Dev box | macOS; no browser, Chrome, Playwright, full bashy build or product-CLI test was run there |

| Check | Verdict | Note |
|-------|---------|------|
| D1 real-browser `EventSource` live stream | **NOT RUN — blocked** | venue unreachable, see below |
| D2 `TestDeskRegisterScriptsUsePublicShapedAppPath/page` | **NOT RUN — blocked** | test change committed (`3a3e4657`), not executed |
| D3 real headless-Chrome `page export --to pdf` | **NOT RUN — blocked** | |
| D4 two-door multi-identity dress rehearsal | **NOT RUN — blocked** | |

**Blocker (environment, not product).** Every `outpost ssh exec` to the
gate-host alias on 2026-11-23 returned, verbatim:

```
Error: elevation required for "<claimed-gate-host>" — run `outpost connect <claimed-gate-host>`
```

The dev box's cached elevation for that host was last minted about four
hours earlier and had passed outpost's one-hour idle limit. `outpost
connect` needs the OS password of the user outpost runs as on that host.
An agent must not supply or guess it, so only the operator can clear the
blocker. Alternate aliases for the same host do not help: no attached
satellite serves them (`none of the attached satellites that answered ...
serves host`). The sprint manager was told on `mb` at about 2026-11-23T15:03Z.

**What does not depend on the venue and is done:** the D2 test change on
the story branch and the Sunday runbook below. **To resume:** the operator
runs `outpost connect <claimed-gate-host> --keep-alive` on the dev box. A
worker then runs the checks below on the claimed lane, attached
(`outpost ssh exec --timeout 10m <alias> -- ...`), and replaces section (b)
with the verbatim output. Under the spec, a failing rehearsal means the
class runs on today's tools (section (c), "Fallback").

## (b) Command plan and evidence slots

All on the gate host's WSL2 distro, inside
`d=/tmp/s696-uat-$$; mkdir -p "$d"; trap 'rm -rf "$d"' EXIT`, at bashy
`s696-142b21dad07f`. Every Chrome/Chromium/Playwright invocation runs
under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-gpu` (WSLg
otherwise stalls `requestAnimationFrame` and engages d3d12).

### D1 — live stream in a real browser

1. Start `page serve --port P` and add a page that carries a `poll`, a
   `timer`, a `hands` block and a `board` block.
2. In headless Chromium, open the participant link. Assert that
   `EventSource` opens `/api/events?id=PAGE` (network log) and that the
   DOM changes with no navigation while a second identity votes, the
   organizer starts the timer, someone raises a hand followed by `page
   hands next`, and a card is written and voted.
3. Kill the stream (server-side restart of the connection). The browser
   resends `Last-Event-ID`, and the block revisions missed in the gap
   arrive or are re-read.

Evidence: _pending — not run._

### D2 — shaped registration end to end

```bash
cd bashy && GOWORK=off go test -v -count=1 \
  -run '^TestDeskRegisterScriptsUsePublicShapedAppPath/page$' ./examples/desk
```

This proves `register.sh` (`app add --type shaped`), `app show`, `app
list`, the Genie injection on `/page/` (`/_shape/page.js`,
`/_shape/genie.js?v=`, `data-app="page"`, `data-mode="live"`), `src
activate`, `src pr merge` and `src undo`.

Evidence: _pending — not run._

### D3 — PDF export through real headless Chrome

```bash
env -u DISPLAY -u WAYLAND_DISPLAY page export PAGE --to pdf -o "$d/record.pdf"
head -c 8 "$d/record.pdf"            # %PDF-1.
pdftotext "$d/record.pdf" - | grep -E -c '192\.0\.2\.|[0-9a-f]{64}|page-participant|facilitator' # expect 0
```

Evidence: _pending — not run._

### D4 — two doors, many identities, one fixed page

The sibling apps `form`, `brainstorm`, `viewer` and `notepad` run on
their default loopback ports. `page publish-outpost --port P` then `page
serve --lan --port P`, with `PAGE_SSO_SECRET` set to a rehearsal-only
secret. The page is `page add -f templates/meeting.md --audience lan
--code s696-dress`. It also gets a 3-vote `poll`, a `form`, an
`--anonymous` poll, a `board`, `book`, `note`, a same-origin `embed` and a
link-out `embed`.

- Satellite door: requests stamped with HMAC as a member resolve to the
  app pseudonym. An anonymous signed tunnel request without a forwarded
  client address is refused (outpost follow-up `a1333108286e`). With
  distinct forwarded `192.0.2.x` addresses, each one enrolls.
- LAN door: distinct anonymous `handle@192.0.2.x` participants. These
  need source addresses on a dummy interface, which needs root in WSL2. If
  root is not available, record that and use the distro's own address
  plus the satellite-door cases. A refresh and a cookie loss from the same
  address still count as one vote. The same handle from another address
  gets `409`.
- Faces: organizer, `?view=participant` (preview isolation) and
  `?view=display`. Then `page close` and `page export --to md|html|pdf`,
  audited for addresses, fingerprints, cookies, respondent tokens and
  keys.

Evidence: _pending — not run._

## (c) Operator runbook — live class, Sunday 2026-11-29

The satellite door is primary; the LAN door is the fallback. One fixed
port serves both. The general procedure is the bashy kb runbook
`run-a-class-or-meeting-on-one-page`; this is the class-day checklist.

### T−60 min: pre-flight (go / no-go)

1. On the class host: `bashy --version`, and check that `page --help`
   resolves (registered through `examples/desk/page/register.sh`).
2. Start the sibling apps, each in its own terminal (or as services):
   `form serve`, `brainstorm serve`, `viewer serve`, `notepad serve`.
   `curl -fsS` each app's `/healthz` on loopback.
3. Pick one fixed port, e.g. `P=8090`:

   ```bash
   page publish-outpost --port $P     # satellite door: signed-in visitors
   page serve --lan --port $P         # LAN door: same listener; keep this terminal attached
   ```

4. Create the class page from a template with a short code. Keep the
   organizer link private:

   ```bash
   page add -f templates/agenda.md --title "Sunday class" --audience lan --code sunday-class
   page open PAGE                     # satellite link, LAN link, QR codes, bare code
   ```

5. Smoke test from a second device: open the satellite link while signed
   in, join, raise a hand, and see it on the organizer view. Then open the
   LAN link from a phone on the room Wi-Fi.
6. **Go** only if steps 1–5 pass. **No-go trigger:** any step fails and
   is not fixed by T−15 min. In that case, use the fallback below.

### During class

- Share the **satellite link first**, then the LAN link and QR code as
  the fallback for anyone who cannot sign in. The bare code works at the
  page root on either door.
- Project `?view=display`; drive from the organizer link.
- **Seconds (data verbs, live):** `page block add poll PAGE --options
  "A,B,C" --votes 3`, `page block close|show-results PAGE BLOCK`, `page
  block add form PAGE --def FILE`, `page block add board PAGE --title T`,
  `page set PAGE -f agenda.md` (for `note:`, `book:`, `embed:`, `timer:`
  blocks), `page hands next PAGE`, timer controls on the organizer face.
- **Minutes (shaping):** use `bashy shape wish page '...'` only for a
  change that was rehearsed beforehand, and verify and preview it before
  you approve it. Never shape live what a data verb already does.
- Moderate with `page participant PAGE list|rename|merge|kick`.

### After class

```bash
page close PAGE
page export PAGE --to md   -o <class-repo>/records/2026-11-29.md
page export PAGE --to html -o <class-repo>/records/2026-11-29.html
page export PAGE --to pdf  -o <class-repo>/records/2026-11-29.pdf
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
