---
id: 142b21dad07f
kind: test
title: 'P2 UAT: dress rehearsal on the gate host, then a weekly class on one page'
seq: 660
status: assigned
assignee: claude-opus5.5
priority: p2
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.687086Z
sprint: 696
---

Dress rehearsal on the claimed gate host with fake identities on both doors (satellite member, LAN anonymous), a ballot, a form collection, a timer and an export; then the live class on Sunday 2026-11-29 through the satellite door with the LAN door as fallback. Outcome and any defects recorded in the class repository and as todos here; bashy docs stay general (the class is a test case, not the product). If the rehearsal fails, the class runs on today's tools. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Wave 5b P2 Gate-Host Dress Rehearsal & Class Runbook brief (`assignee: claude-opus5.5`):
1. **Claimed Gate-Host Venue & Hard Dev-Box Prohibition**:
   - Gate-host `lane1` (lease epoch 10) is ALREADY claimed and announced on `mb` by the sprint manager (`bashy claim list` shows the exact resource target; `$(command -v outpost) ssh list` shows the paired SSH alias).
   - **CRITICAL**: Invoke the standalone `outpost` binary directly (`$(command -v outpost) ssh ...`) — **NEVER** call `bashy outpost ...` (triggers yoke adapter recursion).
   - **NEVER** run browsers, Chromium/Chrome, Playwright, full `bashy` builds, or `TestDeskRegisterScriptsUsePublicShapedAppPath` on the macOS dev box. Run ALL rehearsal and deferred checks remotely inside the claimed gate host's WSL2 environment in an isolated scratch directory (`/tmp/s696-uat-$$`), cleaned up on exit.
   - **Gate-Host WSL2 + Headless Chrome Rules** (from host `kb`):
     - Keep the `outpost ssh` / `wsl.exe` session **attached** for each run (`outpost ssh exec --timeout 10m <alias> -- ...`; WSL stops idle distros ~15s after the last `wsl.exe` client exits, killing detached `nohup`/`setsid` jobs).
     - Strip `DISPLAY` and `WAYLAND_DISPLAY` (`env -u DISPLAY -u WAYLAND_DISPLAY`) and pass `--disable-gpu` for ALL headless Chromium/Chrome and Playwright invocations so WSLg does not stall `requestAnimationFrame` or engage d3d12.
2. **Execute & Record Verbatim Evidence for All 4 Deferred Checks + Full Two-Door Dress Rehearsal** (against current `bashy` `origin/main` `6b743ec2` + any `s696-142b21dad07f` test/fix commit):
   - **(D1) Real Browser `EventSource` Live SSE Check** (deferred from `0eac011ff4a9`): open a live `page` in real headless Chromium/Playwright on the gate host (`env -u DISPLAY -u WAYLAND_DISPLAY`, `--disable-gpu`), verify `EventSource` connects to `/api/events`, receives live `{item, block, revision}` frames and updates the DOM without page reload across live block mutations (`poll` vote tally, `timer` start/tick, `hands` raise/next, `board` card/vote), and verify `Last-Event-ID` reconnect/resync.
   - **(D2) Shaped Registration E2E (`TestDeskRegisterScriptsUsePublicShapedAppPath/page`)** (deferred from `df08cca51889`): add `"page"` to the `assertRegisteredGenie` list in `bashy/examples/desk/register_shaped_test.go` (branch `s696-142b21dad07f` from `6b743ec2`) and run `GOWORK=off go test -v -count=1 -run '^TestDeskRegisterScriptsUsePublicShapedAppPath/page$' ./examples/desk` on the gate host, proving `register.sh` (`app add --type shaped`), `app show`, `app list`, live shaped console `/_shape/page.js` + `/_shape/genie.js` injection on `/page/`, `src activate`, `src pr merge`, and `src undo`.
   - **(D3) Real Headless-Chrome PDF Export (`page export --to pdf`)** (deferred from `488e3c331aa5`): run real `page export <id> --to pdf -o record.pdf` using real Chrome/Chromium on the gate host (`env -u DISPLAY -u WAYLAND_DISPLAY`), verify valid non-empty `%PDF-1.` output, and verify rendered content has inline block states and ZERO participant addresses, fingerprints, cookies, respondent tokens, or facilitator keys.
   - **(D4) Full Multi-Identity Two-Door Dress Rehearsal on One Fixed Page**:
     - Run real sibling servers (`form`, `brainstorm`, `viewer`, `notepad`) and `page serve --lan` (with outpost secret configured) on the gate host, starting a page from `templates/meeting.md` (or class agenda) with a short `--code`.
     - Drive fake identities across **BOTH doors** (including real headless browser sessions):
       - **Satellite door**: valid HMAC-signed outpost-stamped member requests (`principal` -> app-specific pseudonym) + verify fail-closed refusal when an anonymous signed tunnel request lacks client address (`a1333108286e`) vs enrollment when distinct forwarded `192.0.2.x` addresses are supplied.
       - **LAN door**: multiple distinct anonymous `handle@address` participants (`192.0.2.x`), testing browser refresh + cookie-loss reclaim from same address (still 1 vote!) and cross-address duplicate-handle refusal (`409`).
     - Exercise every block & face on that one fixed page: `here` live online/offline/last_seen, `hands` raise/lower/next/clear, 3-vote-budget `poll` ballot + `form` collection + `--anonymous` poll, `board` write cards + vote phase, inline `book` + `note`, `embed` (same-origin frame + non-kit link-out card), `timer` controls + SSE ticks, organizer dual-face view + `?view=participant` throwaway preview isolation + `?view=display` projector view, `page close`, and `page export --to md|html|pdf` audited for zero leaked addresses/fingerprints/cookies/tokens/keys.
3. **Root Cause First**: If ANY check fails, stop, reproduce, classify (product / test / environment), record root cause, fix `page` cleanly on `s696-142b21dad07f` (or file a standalone todo for sibling/outpost gaps per rule #2), and re-run on the gate host to green.
4. **Deliverables in Repo (`./script/scrub-gate.sh` MUST pass — ZERO real hostnames, OS usernames, home paths, or non-RFC5737 IPs!)**:
   - Write `docs/sprint-696-rehearsal-evidence.md` in `umbrella` containing: (a) pinned SHAs, claimed gate-host lane (`<claimed-gate-host>.lane1`, epoch 10, role-described), and D1–D4 verdict summary; (b) scrubbed verbatim command/test evidence for D1, D2, D3, and D4; (c) the **Sunday 2026-11-29 Operator Live Class Runbook** (pre-flight check, starting sibling apps + `page publish-outpost --port PORT` + `page serve --lan --port PORT`, creating the class page from `templates/` with `--code`, sharing satellite primary + LAN fallback links/QR, live second-speed data verbs vs rehearsed `shape wish`, post-class `page close` + `page export --to md|html|pdf` into the class repository, and explicit fallback trigger to run on standalone tools if pre-flight fails).
   - Commit any `bashy` change (`register_shaped_test.go` + any root-caused `page` fix) on `s696-142b21dad07f` (`BASHY_AGENT=claude-opus5.5`, contiguous trailers `Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #660`, `Story-ID: 142b21dad07f`, `Agent: claude-opus5.5`), commit `docs/sprint-696-rehearsal-evidence.md` (+ `bashy` pin if changed) at umbrella root (`./script/scrub-gate.sh` exit 0, same contiguous trailers), run `bashy sprint submit 696 142b21dad07f --as claude-opus5.5 -m "..."`, and leave both working trees 100% clean without pushing (do NOT release the gate-host claim yourself; the manager will release it after verifying).
