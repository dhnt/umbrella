---
id: eebd9e94a8b9
kind: feature
title: F1 Build examples/calendar MVP (self-hosted, Desk primitives, ICS + Google import/export)
seq: 122
status: done
priority: p1
labels:
    - collaboration-followup
created: 2026-11-11T09:56:30.56162Z
assignee: agy-gemini4-carbon
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
closed: 2026-11-21T11:04:31.147082Z
closed_by: agy-gemini4-carbon
---

Build `examples/calendar` (Desk tool) MVP in `bashy` (`examples/calendar/`), following `docs/calendar-decision.md` §3 and §5, `examples/desk/kit/internal/fixture`, `examples/desk/notepad`, `examples/desk/viewer`, `examples/session`, and `docs/kb/pages/enable-an-app-for-consumer-shaping.md`.

## Scope & Allowed Paths (inside `bashy` repository)
- `examples/calendar/` — new self-contained Go module (`module calendar`, `go 1.27`, `require desk-kit v0.0.0`, `replace desk-kit => ../desk/kit`, stdlib + `desk-kit` only, `CGO_ENABLED=0`, zero compiled binaries tracked in git; `.gitignore` must ignore `calendar`, `calendar.exe`, `.desk-build/`, `.check.*`).
  Required files: `go.mod`, `go.sum`, `.gitignore`, `main.go`, `cli.go`, `ics.go`, `calendar_test.go`, `calendar.bsh`, `calendar.sh`, `register.sh`, `shaped.json`, `contract.bsh`, `checks/go.bsh`, `dag.md`, `browser-test.mjs`, `README.md`, `templates/agenda.html`, `formats/event.schema.json`.
- `examples/desk/kit/ui.go`, `examples/desk/kit/kit.css`, `examples/desk/kit/options.go` — add `{"calendar", "Calendar", "📅"}` to `kit.Tools`; add `--desk-accent-calendar` in all 3 theme blocks of `kit.css` (`:root`, `@media (prefers-color-scheme: dark)`, `:root[data-theme="dark"]`) plus `:root[data-desk-tool="calendar"] { --desk-accent: var(--desk-accent-calendar); }` (`TestEveryFamilyToolHasAnAccent` enforces all 3 + selector); add `"calendar"` verb list to `ToolVerbs` in `options.go`.
- `examples/desk/shaped_test.go` — add `"calendar": "../calendar"` to `shapedTools` and include `"calendar"` in `TestConsumerPolishedToolsDeclareGenieExamples`.
- Placement stays `examples/` only; do NOT add to `bashy-defaults` or `cmd/bashy`.

## Functional & Contract Requirements
1. **Entity (`items/<id>.json`, atomic writes):**
   - ID `^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$`.
   - Fields: `id`, `title`, `start` (RFC 3339), `end` (RFC 3339, `end >= start`), `tz` (explicit IANA timezone validated with `time.LoadLocation`; invalid zone returns HTTP 400 / CLI exit 2; event times are NEVER derived from `created`/`updated`), `location`, `body` (Markdown), `refs` (`[]string`: `kb:<slug>`, `sprint:<N>`, `viewer:session-<S>`, `klatch:<id>`, `https://...`), `audience` (`[]string` of `bashy person` ids), `status` (`pending|closed|cancelled` — note `kit.ValidStatus` checks `pending|closed` in generic `contracttest`: ensure `add` starts `pending`, `close` transitions to `closed` and subsequent `set` returns 409, and `cancel` transitions to `cancelled` — if `kit.ValidStatus` is used on `status`, either extend `kit.ValidStatus` with `StatusCancelled = "cancelled"` or verify `contracttest` remains 100% green), `source` (`{"provider": "local|ics|google", "uid": "<external UID>"}`), `owner`, `members`, `invites`, `created`, `updated`.
   - **Desk `contracttest` compatibility trap:** `contracttest.Run` posts `{"action":"add","title":"contract probe","body":"..."}` with no `start`/`end`/`tz`. When `start`/`end`/`tz` are omitted on `add`, default `tz` to `"UTC"`, `start` to a deterministic valid RFC 3339 timestamp (e.g. `2026-01-01T09:00:00Z`), and `end` to `start + 1h`, while rejecting any explicitly supplied malformed timestamp, `end < start`, or invalid IANA `tz` with HTTP 400 / exit 2. Also reject secret-typed/secret-named `fields` with 400 mentioning `"secret"` (`contracttest` `secrets()` check), enforce strict JSON decoding (unknown fields / trailing data = 400), honor `X-Forwarded-Prefix` (`behindShell()` check), and NEVER include `body` in `add`, `open`, `list`, or `GET /api/state` responses (`show` is the read that returns `body`).

2. **Verbs & Web-to-CLI Parity (`bashy-calendar-v1` envelope on `--json`):**
   - Verbs: `serve`, `add`, `show`, `set`, `list` (`--from`, `--to`, `--tz`, `--audience`, `--status`, `--json`), `cancel` (marks `cancelled`, keeps item), `open` (id, URL, status only), `share` (mints single-use invite), `join` (`calendar join ID INVITE` prints join URL; HTTP/browser join redeems single-use invite into a member token), `close` (marks `closed`), `export`, `import`, `save`, `load`.
   - Common options via `kit.ParseCommon`: `--json`, `--fields`, `--no-input`, `--explain`, `--dry-run`, `--help=mcp`. Write/import/export/save/load verbs honor `--dry-run` with zero state mutation.
   - Creating, updating, or importing an event NEVER executes commands or launches agents. No recurrence (`RRULE`), RSVP, built-in reminders, CalDAV, or background sync.

3. **Audience & 404 Enforcement:**
   - Owner key (`X-Facilitator-Key` / `--key`, auto-resolved locally from `opts.data/items/<id>.json` when available for owner CLI calls), single-use `share` invite -> member cookie/header, `set ID --revoke MEMBER` revokes a member.
   - Non-members and revoked members receive **HTTP 404** (not 403) on protected item state/action/export, and the CLI surfaces the same denied failure (non-zero exit).

4. **Agenda Page (`templates/agenda.html` + `formats/event.schema.json`):**
   - Load `templates/agenda.html` from disk relative to the app source/working dir with `//go:embed` fallback so consumer shaping edits to `templates/agenda.html` take effect cleanly.
   - Day/week agenda list grouped by date in the viewer's timezone (`?tz=` query / selector, defaulting to event/host zone; no month grid), create/edit/cancel/close/share actions wired to `/api/action`, and event detail panel rendering Markdown `body` and `refs` links through `/api/render` (`kit/render`, sanitized `.desk-content`).
   - Must load `kit.CSS()` + `kit.JS()`, carry `.desk-appbar` (`data-desk-tool="calendar"`), and carry zero raw hex/rgb colors or `font-family` declarations outside `kit.css` tokens (`contracttest.StyleViolations`).

5. **Durable Git-Dir `save` / `load`, ICS, and Offline-Fixture Google Interop:**
   - `calendar save [--dir DIR] [--dry-run] [--json]` writes `<DIR>/events.json` plus `<DIR>/<id>.ics` per event (default `docs/calendar`); `calendar load [DIR] [--dry-run] [--json]` loads them back idempotently. Never invokes `git`.
   - `ics.go` (stdlib RFC 5545 `VCALENDAR`/`VEVENT` subset: `UID`, `DTSTART`/`DTEND` with `TZID` or `Z` UTC or `VALUE=DATE`, `SUMMARY`, `DESCRIPTION`, `LOCATION`, `STATUS`, `URL` for `refs`): `calendar export [ID|--all] --to ics|json [-o FILE] [--dry-run] [--json]` and `calendar import -f FILE|- [--from ics] [--dry-run] [--json]`. Preserves `source: {"provider": "ics", "uid": UID}` so re-importing the same `UID` updates the existing event instead of duplicating.
   - Google import/export (`calendar import --from google [--calendar CAL_ID] [--dry-run] [--json]` and `calendar export [ID|--all] --to google [--calendar CAL_ID] [--dry-run] [--json]`): composes `BASHY_GOOGLE_CMD` (default `"${BASHY_BIN:-bashy}" google`) invoking `calendar-list` on import and `calendar-create` / `calendar-update` on export (recording Google's event `id` in `source: {"provider": "google", "uid": id}` so re-export updates rather than duplicates). If `google` CLI or BYOP credentials are absent, return a clear actionable error (`CLI_NOT_FOUND` / onboarding hint). Test in `calendar_test.go` using offline JSON fixtures and a fake `BASHY_GOOGLE_CMD` script (never call live Google APIs in automated tests).

6. **Consumer Shaping (`kb:enable-an-app-for-consumer-shaping`):**
   - `shaped.json` at `examples/calendar/shaped.json`: `{"server": {"main": ".", "args": ["serve", "-addr", "$ADDR", "-data", "$DATA"]}, "genie": {"examples": [...]}}` with 3 concrete consumer wishes.
   - `contract.bsh` (`@effects("read,write,exec,net")`) and `checks/go.bsh` (matching `examples/desk/notepad/checks/go.bsh`).
   - `register.sh`: builds to `${XDG_CACHE_HOME:-$HOME/.cache}/bashy/desk-calendar/calendar` (`GOWORK=off CGO_ENABLED=0`), runs `commands add`, `skill add`, and `app add "$name" --type shaped --source "$here" --label "Calendar" --icon "📅" --tip "..." --force`.
   - CLI runtime discovery (`examples/desk/viewer/cli.go` pattern): explicit handoff (`BASHY_APP=calendar` + `BASHY_APP_ADDR`/`BASHY_APP_DATA`, `CALENDAR_ADDR`/`CALENDAR_DATA`, or `-addr`/`-data`) wins; otherwise client verbs call `kit.DiscoverAppRuntime("calendar")` (`bashy app show calendar --runtime --json`), using `info.Addr`, `info.Data`, and `info.URL` (so printed URLs use the console mount). If runtime discovery fails, exit non-zero with the actionable message naming `CALENDAR_ADDR` and `CALENDAR_DATA` — never fall back silently to fixed port `127.0.0.1:18099`.

## Tests & Dev-Box Gate Rules
- **NEVER launch Chrome/Playwright on the dev box.** Write `examples/calendar/browser-test.mjs` (Playwright headless Chromium round-trip modelled on `examples/desk/notepad/browser-test.mjs`) and `dag.md` (`serve`, `test`, `register`, `show`, `roundtrip`), and syntax-check `node --check examples/calendar/browser-test.mjs` locally; the sprint manager runs `browser-test.mjs` in an isolated gate-host lane.
- Run and pass all targeted tests on the dev box before committing:
  1. `(cd examples/desk/kit && GOWORK=off CGO_ENABLED=0 go test -v ./...)`
  2. `(cd examples/calendar && GOWORK=off CGO_ENABLED=0 go test -v ./...)` (covering `contracttest.Run`, IANA tz + DST + invalid tz refusal, owner/invite/member/revoke 404 parity, ICS import/export + `--dry-run` + `source.uid` dedupe, offline-fixture Google import/export + `source.uid` update + missing-CLI error, `save`/`load` round-trip without git, and `DiscoverAppRuntime` discovery + failure refusal)
  3. `(cd examples/desk && GOWORK=off CGO_ENABLED=0 go test -short -run 'TestConsumerPolishedToolsDeclareGenieExamples|TestDeskToolsShipShapedServer' .)`
  4. `bash -n examples/calendar/register.sh examples/calendar/calendar.sh` and `node --check examples/calendar/browser-test.mjs`
- Commit named paths only (never `git add -A`, never push, describe hosts by role only) with trailers:
  Sprint: #616
  Story: #122
  Story-ID: eebd9e94a8b9
  Agent: agy-gemini4-carbon

## Gate-Host Test Triage Ledger
- **2026-11-21 (`browser-test.mjs` run #1 in gate-host lane 3):**
  - **Symptom:** `page.waitForURL(/\?id=/, {timeout: 5000})` timed out at `examples/calendar/browser-test.mjs:89` after `#saveBtn` succeeded (`Saved event` alert visible).
  - **Root cause & classification:** **New-test bug** in `examples/calendar/browser-test.mjs` (zero product defect). Line 70 navigates to `srv.participant + '?tz=America/New_York'`, so when `templates/agenda.html` `syncURL()` updates the URL via `u.searchParams.set('id', id)` and `history.replaceState()`, `id` is appended as `&id=<evID>` (`/?tz=America%2FNew_York&id=...`), which never matches `/\?id=/` (and `history.replaceState` does not fire a `"load"` event when already settled). Secondary race at lines 123–126: revoking multiple members in a loop waited on static `'Revoked member'` alert text, which already matched after the first click.
  - **Fix (`bashy` `081de64af8bf`):** Poll `new URL(window.location.href).searchParams.get('id')` via `page.waitForFunction`, and wait for `.cal-revoke-btn` count to decrement on each revoke click.
- **2026-11-21 (`browser-test.mjs` WSL2 `requestAnimationFrame` root cause in gate-host lane 3):**
  - **Symptom:** `locator('#saveBtn').click()` timed out (`waiting for element to be visible, enabled and stable`) in WSL2 headless Chromium.
  - **Root cause & classification:** **WSLg `DISPLAY` / `WAYLAND_DISPLAY` vblank stall on headless Windows gate host** (zero product defect). WSL2 automatically exports `DISPLAY=:0` and `WAYLAND_DISPLAY=wayland-0` into `wsl.exe` sessions; on a headless/locked Windows host, WSLg's Wayland/X11 surface never delivers frame callbacks, stalling `requestAnimationFrame` (`envClean=false -> RAF_TIMEOUT` across every step). Deleting `DISPLAY` and `WAYLAND_DISPLAY` from the browser child environment restores pure headless frame scheduling (`envClean=true -> RAF_OK` across every step).
  - **Fix (`bashy` `8276b5d9f4da`, host KB `wslg-display-and-wayland-display-stall-playwright-requestanimati`):** Strip `DISPLAY` and `WAYLAND_DISPLAY` in `chromium.launch({ env })` (`examples/calendar/browser-test.mjs`).
- **2026-11-21 (`browser-test.mjs` catching stale DOM node in `templates/agenda.html`):**
  - **Symptom:** `page.waitForFunction` timed out at `browser-test.mjs:130` waiting for `document.querySelectorAll('.cal-revoke-btn').length === 0` after revoking the last member.
  - **Root cause & classification:** **Product UI bug** in `examples/calendar/templates/agenda.html:585-607`. When `data.members` transitioned from length 1 to length 0, the `else` branch set `membersBox.hidden = true` without clearing `membersList.textContent = ''`, leaving the last `.cal-revoke-btn` node attached inside the hidden container.
  - **Fix (`bashy` `a2b81fe447881eabd7bbe7f51337a426327e1680`, merged to `main` in `401de2e106f3`):** Clear `membersList.textContent = ''` unconditionally before rendering `data.members` in `templates/agenda.html`.

## Verification & Delivery Evidence (2026-11-21)
- **Delivered `bashy` submodule SHA:** `401de2e106f3d2e72d6b60a27c031e31a1efbf2c` (merging `agent/weave-issue-126` tip `13e25b1a9cc7`, worker `agy-gemini4-carbon` on `bashy#126`).
- **Official locked build image (`localhost/bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2`, digest `sha256:c99fcb7318b23ed06b3775368ee3966795a5498fb9a050a92d6f21866680b7ba`, gate-host lane 3):**
  - `desk/kit` (`desk-kit`, `desk-kit/contracttest`, `desk-kit/internal/fixture`, `desk-kit/render`): `-count=1` **PASS** (`TestEveryFamilyToolHasAnAccent` green across all 3 theme blocks).
  - `examples/calendar` (`GOWORK=off CGO_ENABLED=0 go test -count=1 -v ./...`): **PASS** (`8/8` suites: `TestDeskContract`, `TestContractRedOnBreak`, `TestTimezoneValidationAndDST`, `TestAudienceInviteRevoke404AndCancelLifecycle`, `TestICSImportExportDryRunAndDedupe`, `TestGoogleImportExportOfflineFixturesAndMissingCLI`, `TestSaveAndLoadGitDirWithoutGit`, `TestDiscoverAppRuntimeAndShapingHooks`).
- **Consumer shaping E2E (`localhost/bashy-build:v1.0.0-rc.39-go1.27.2-c7e19f271086`, digest `sha256:c7e19f271086e3a20fd7ade71ad41afba36700cfba3c90e064117e5c0359e3a2`, gate-host lane 3):**
  - `register.sh` -> `app show calendar --json` (`type: "shaped"`, `valid: true`): **PASS**.
  - Loopback `bashy app serve` + `GET /calendar/`: **PASS** (`5/5` Genie proxy markers: `/_shape/page.js`, `/_shape/genie.js`, `data-bashy-genie`, `data-app="calendar"`, `data-mode="live"`).
  - Live console CLI runtime discovery (`bashy calendar add shaped-rt --json` with no explicit addr/data env): **PASS** (resolved `http://127.0.0.1:18916/calendar/?id=shaped-rt` via `kit.DiscoverAppRuntime("calendar")`).
  - Personal fork + verifier + rollback (`src branch` -> `src pr open` -> `src pr verify` (`checks/go.bsh` + `shape/compat` `verdict: pass`) -> `src activate` -> `src pr merge` -> second fork `src activate` -> `src undo`): **PASS**.
- **Real headless Chromium round trip (`examples/calendar/browser-test.mjs`, gate-host lane 3 only, never Chrome on dev host):**
  - `browser-test.mjs passed cleanly for calendar` (agenda shell markers, UI event creation with Markdown + refs, `/api/render` `.desk-content` rendering, `America/New_York` viewer TZ conversion, HTTP 404 stranger checks, single-use `#invite=` join in a second browser context, member revocation returning 404, event cancellation, theme toggle, copy button).
- **Google Calendar interop:**
  - Verified with offline JSON fixtures and fake `BASHY_GOOGLE_CMD` (`calendar-list`, `calendar-create`, `calendar-update` with idempotent `source.{provider:"google", uid}` persistence, `--dry-run` zero external calls, and `CLI_NOT_FOUND` onboarding guidance). Live Google API round trip explicitly skipped (requires operator-attended BYOP credentials).
- **Sibling Desk & shaped app non-regression suites:**
  - `desk/kit`, `desk/notepad`, `desk/form`, `desk/viewer`, `desk/chart` (`+ chart/fence`), `brainstorm/server`, `whiteboard`, `session`, and `examples/desk` (`-short`): all **PASS**.
