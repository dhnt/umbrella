# Sprint 682 — shaping-enable the example apps for consumers (plan)

- **Planner:** the conductor.
- **Operator, 2026-11-20:** "software shaping enable the apps for consumers
  (first); owner/producer in another follow-up sprint" (Sprint 683). A website
  is just an app with sub-apps, so the steps must be general.

## Model (what "consumer shaping" means here)

A web app registered with `bashy app add NAME --type shaped --source DIR` is
shaped per user. The console injects the Genie button into its pages
(`yoke/pkg/webconsole/genie.go` `injectGenie`; static `shaped.go:354`; own
server `shaped_server.go:577/594`).

A consumer's wish follows this path:
1. `POST /api/shape/{app}/candidates` (`shaped_candidate.go:700`).
2. A candidate clone is created per principal (`<root>/<app>/<principalKey>`).
3. `bashy delegate` runs in genie mode.
4. verify → preview → approve (or reject), with undo. The result applies only
   to that user.

The owner side (offer, adopt, release, publication, the website tiers in
`docs/shaping-enable-a-website.md`) is Sprint 683.

- **Manifest:** `shaped.json` (`yoke/pkg/shape/appserver/manifest.go`).
  `server{main,args with $ADDR|$PORT and $DATA}`,
  `genie{position,anchor,hidden,examples,voice}`, and others; unknown keys
  are rejected.
- **What makes a page shaped:** the registry type, NOT the file. A plain
  `--port` proxy (`handler.go:573`) gets no Genie button.

**Reference implementations:**
- `examples/shaping/hello-world`: static, with the consumer wish e2e
  `e2e-agent.sh` → `scripts/test-shaping-hello-world.sh`.
- `desk/form` and `desk/notepad`: own-server apps registered `--type shaped`
  in `register.sh`.

## Current state (surveyed 2026-11-20)

| App | Registered as | shaped.json | Genie examples | Gap |
|---|---|---|---|---|
| desk/viewer | proxy `--port 18096` | server only | no | not shaped → no button |
| desk/chart | proxy `--port 18098` | server only | no | not shaped → no button |
| session | proxy `--port 18093` | **none** | no | no manifest; fixed-port server owned by session.bsh |
| desk/form | shaped | server only | no | examples only |
| desk/notepad | shaped | server only | no | examples; a 12.9 MB binary committed in the source tree |
| board | shaped (install) | server + examples | yes | wish e2e only |
| whiteboard | shaped (install) | server + examples (root) | yes | `desk/shaped_test.go:32` still points at `../whiteboard/server`; reproduce first |
| table | shaped (install, Linux) | server + examples | yes | wish e2e only |
| hello-world | shaped (static) | — | — | reference |

## Stories

### C1 — viewer and chart become shaped apps

- Switch `register.sh` to `app add --type shaped --source "$here"`, as
  form and notepad do.
- Their agent CLIs (`viewer.bsh`, `bashy chart`) must keep working when the
  console chooses `$ADDR`. Resolve the live address the same way form and
  notepad do, rather than hardcoding 18096 or 18098. Explain the mechanism in
  the design note.
- Add `genie.examples` (2–3 real consumer wishes per app).
- Add both apps to `desk/register_shaped_test.go`.

Accept when:
- the registry type is shaped and the page carries the Genie scripts
  (existing injection tests pattern);
- `viewer add/append/open` and `chart` still work end to end against the
  shaped instance;
- the desk tests pass.

### C1b — local discovery so agent CLIs keep working (added 2026-11-20 after C1 review)

C1 makes viewer and chart shaped. Their server now runs at a console-chosen
address with a per-principal data folder. A plain `bashy viewer add` with no
handoff variables would then post to the old fixed port, where nothing
listens. That is a regression for agents, who use viewer for reports. Merge
C1 only together with C1b.

- **Platform (yoke webconsole/fleet). Revised at design review: no new IPC
  transport.**
  - When the console starts a shaped instance, it writes
    `<console-home>/shape/<app>/<encoded-principal>/runtime.json` with an
    atomic write. The file is 0600 in the owner-only tree and holds the
    address, data folder, console app URL, pid and revision. The console
    removes it on stop.
  - `bashy app show NAME --runtime [--json]` reads it for the local OS-user
    principal and verifies the pid and health. If the file is stale or absent,
    the command exits non-zero with an actionable message: open the app once,
    or pass the handoff variables.
  - Idle-start is a Sprint 683 follow-up.
- **Viewer and chart CLIs.** When neither the `*_ADDR` nor the `*_DATA`
  handoff variable is set, they resolve the address through `--runtime`. An
  explicit handoff still wins. If discovery fails, they print one actionable
  error naming the handoff variables. They never fall back silently to the old
  fixed port.
- **Tests:**
  - `--runtime` unit tests: write/remove lifecycle, stale pid, absent file;
  - CLI tests: discovery used when no environment variables are set, and an
    explicit handoff overrides it.
- Remote and other-principal discovery stays in Sprint 683.

### C2 — session becomes a shaped app

- Add `shaped.json`: `server.main "server"`, args with `$ADDR` and `$DATA`.
  The server already handles a prefix (`server/main.go:104`).
- Register it `--type shaped`.
- Make `session.bsh` use the console-managed address instead of starting its
  own fixed-port server.
- Add `genie.examples` and add it to `shapedTools`.

Accept as for C1, plus session's existing Python tests stay green.

### C3 — consumer polish for the already-shaped apps

- Add `genie.examples` for form and notepad.
- **whiteboard test path:** first reproduce the `desk/shaped_test.go`
  whiteboard subtest failure and name the root cause (the manifest moved to the
  whiteboard root in 93a5de97). Then fix the path. If it does not fail, report
  why.
- **Committed binaries** (notepad `notepad`, chart `desk-chart`): confirm
  whether they are tracked. Removing tracked binaries needs
  `DECISION <story>` first.
- board and table need network access (table is Linux only), so leave them out
  of `shapedTools`. Record why in the plan appendix.

### C4 — consumer acceptance and the general runbook

- One e2e skill-script, modelled on hello-world `e2e-agent.sh`, runs as a
  MEMBER principal (not the owner) against each shaped example app:
  1. wish (a `genie.examples` line);
  2. verify;
  3. preview URL;
  4. approve;
  5. confirm the change is visible to that member only;
  6. undo.
- It runs under the conductor on a console started with a shaping agent
  (`--shape-agent`). The worker writes it and dry-runs it; the conductor runs
  it live.
- KB runbook "Enable an app for consumer shaping": the general steps distilled
  from C1–C3. Register `--type shaped`; manifest with `server` and
  `genie.examples`; the CLI follows the console address; injection check;
  member-wish e2e. Applies to any app, including a website layer. Register it
  through the kb, with generic names only.

### Closure: KB for general bashy users (operator, 2026-11-20)

The sprint closes only when the bashy KB teaches ANY bashy user, not just these
examples, how to shaping-enable their own app for consumers.

- **One kb page** (`bashy kb`), written for the general owner of any app. It
  covers:
  - when an app qualifies (static `public/` or its own server);
  - the `shaped.json` manifest (`server`, `genie` placement and examples);
  - `bashy app add --type shaped`;
  - making an agent CLI follow the console address;
  - checking that the Genie button is injected;
  - a member's wish → verify → preview → approve → undo;
  - common failures and their root causes, as found in C1–C3.
- **Grounded.** Every command in it is one that actually ran in this sprint,
  with generic names and no host or user details.
- **Discoverable.** Link it from `bashy shape --help`'s companion doc and from
  `docs/shaping-enable-a-website.md` (a website is an app with sub-apps). The
  owner-side steps stay in Sprint 683.
- **Verified.** `bashy kb search "enable an app for shaping"` finds it, and the
  conductor walks through it on one app.

## Non-goals (Sprint 683)

Owner/producer shaping: offer, adopt, release and submit; the website tiers
and private fields; publishing an approved version to other members.

## Delivery

- **Worker:** codex (operator choice), one story at a time: C1 → C2 → C3 → C4.
  It sends a design note first, works in its own worktree in bashy (and yoke
  only if a platform defect is found, which needs `DECISION` first), runs
  targeted tests only on the dev box, and does not push.
- **Conductor:** reviews, re-runs the tests, merges, and runs the live member
  e2e.
- **Release:** none authorized.
