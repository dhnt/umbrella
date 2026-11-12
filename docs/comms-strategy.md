# bashy communications strategy: humans and agents, two ways

Status: strategy and plan only, reviewed 2026-11-12. No code. The sprint card
and its stories are authoritative; this document records the reasoning, the
review of what exists, and the research behind the choices.

## Goal

Make bashy features reachable in both directions:

- **push out**: notify, ask, report;
- **receive / access**: humans and agents outside drive bashy verbs, reply and
  approve.

It must be practical for users in the US on the devices they own (iPhone,
Android, macOS, Windows, Linux), and it must use only legally supported
channels.

## Guidelines (operator, 2026-11-12)

1. **CLI for agents, web UI for humans, for every comms operation.** The web
   UI is the lowest common denominator across mobile and desktop. Elsewhere in
   bashy a UI is optional; for comms the human web UI is required. Parity
   stays one-way: every web action calls a CLI operation, and no operation
   exists only on the web.
2. **Instant switch between tools on the local device**, via the system
   clipboard or a web URL that carries the current context. This compensates
   for third-party tools bashy cannot, or legally may not, integrate. Example:
   a user working with bashy through WeChat on a phone copies a link, opens it,
   and continues in a bashy Klatch chat (or the comms web UI) with the same
   agents running on an outpost.
3. **Reuse, don't reinvent.** Prefer permissively licensed projects (MIT,
   Apache-2.0, BSD) run as-is or carved out, glued with Bash# skill-scripts.
4. **Rod, not fish — small JSON verbs, one `.bsh` = command + skill, and
   software shaping (`[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`).**
   - **Grow bashy, don't work around it.** Register missing verbs with
     `bashy commands add` + `bashy skill add`; shape existing surfaces with
     `bashy shape`. `bashy` ships the mechanism, never a hardcoded channel
     catalog (`yoke/pkg/fleet/apps.go`).
   - **Small verbs, composed (`--json`).** Every CLI verb does ONE thing,
     reads/writes plain files, stdin/stdout, or `--json`, and works standalone
     in pipelines (`bashy comms ntfy poll --once --json | bashy comms listen ...`,
     `bashy comms link capsule REF | bashy clipboard copy`). Higher-level
     workflows (`listen`, `digest`, `setup`) are thin Bash# compositions of
     those small JSON verbs — never a monolith (pattern: `onboard.bsh`,
     `media.bsh`). KB runbooks teach the verbs and human steps, not one canned
     flow.
   - **One `.bsh` file = executable command + embedded skill.** Every command
     in `bashy/examples/comms/` is a `.bsh` script
     (`#!/usr/bin/env -S bashy --bashsharp`) with an embedded `~~~skill as guide`
     fence (`--skill` / `--help` extracts it), contract metadata (`--contract`
     or `@effects(...)` / `@guard` / `@confirm`), and optional polyglot fences
     (e.g., `~~~powershell as ps` for Windows clipboard). Write Go only for a
     primitive verb a script cannot do.
   - **Software shaping (`bashy shape`) & explicit shaping hooks.** The human
     web UI is a shaped app registered via
     `bashy app add comms --type shaped --source <dir>` (live app served at
     `/comms/`, shaped through the injected Genie button and `/shape/comms/`,
     previewed at `/shape/comms/preview/<id>/`). It includes `contract.bsh`
     (`@effects(...)` cap), `checks/smoke.bsh` (frozen verifier checks), and
     `shaped.json` (`properties` for expand-then-contract `shape/compat`
     surface verification and `genie` placement/example wishes). User-tunable
     choices (layout/tabs, channel catalog cards, canned replies, capsule and
     digest templates, action button presets, sender/folder filters) live in
     declarative JSON/templates or `.bsh` functions — never hardcoded Go — and
     every story names its shaping hooks.
5. **Examples first.** New work lands in `bashy/examples/comms/` and graduates
   to optional, then core, only on evidence.
6. **Platforms.** Client pieces: macOS and Windows at minimum. Services and
   listeners: Linux at minimum. Prefer choices that work on all three.

## What already exists (reuse, do not rebuild)

| Area | Existing | Where |
|---|---|---|
| Single inbound door | `bashy meet dm AGENT --channel C --sender S [--thread T]`: text on stdin, reply on stdout; sender pairing with ask/control/approve scopes, `/approve`, room timeline | `yoke/pkg/meet/dm_frontdoor.go` |
| Channel adapters | `bashy feed`, envelope `bashy-feed-envelope-v1`. Discord gateway, Slack Socket Mode and Telegram poll are implemented but **nothing outside tests calls the inbound `Listen`/`Poll`**; `bridge.go` relays channel to channel only. Outbound uses the Go adapters or the pinned `openclaw message send` | `yoke/pkg/feed/adapters/`, `yoke/docs/feed-adapter-contract.md` |
| Bus and push | `mb`, `inbox`, `notify`, `ping`; desktop, ntfy and webhook sinks as skill functions; cross-host delivery through a cloudbox team session | `yoke/pkg/bus/`, `bashy/docs/unified-inbox.md` |
| Durable context | meet rooms and room timelines (`bashy meet list\|show\|contributions\|dm`) | `yoke/pkg/meet`, `yoke/pkg/room` |
| Agent faces | `bashy mcp serve --allow EFFECTS` (effect policy, audit), `bashy acp`, herald (A2A) | `yoke/mcp/`, `yoke/pkg/acp`, `yoke/pkg/herald` |
| Authorization | circles AND (group OR email); outpost default-deny; outpost app share for remote browsers; `bashy approve list\|show\|allow\|deny\|wait`; `bashy app pair\|devices\|revoke` | `outpost/internal/agent/grants.go`, `yoke/pkg/boundary/members.go` |
| Human web host & software shaping | shaped apps on the local web console: live mount at `/<app>/` (e.g. `/comms/`), Shape review panel at `/shape/<app>/`, candidate preview at `/shape/<app>/preview/<id>/`; verified candidate loop (`contract.bsh` `@effects`, `checks/smoke.bsh`, `shaped.json` `properties` expand-then-contract `shape/compat`, auto-injected Genie button) | `yoke/pkg/shape/`, `yoke/pkg/webconsole/shaped*.go`, pattern `bashy/examples/desk/{notepad,form}/` |
| Link to a phone | `bashy share qr URL` | `yoke/pkg/share/share.go` |
| Own chat | Klatch (Databag fork) with upstream phone apps and `examples/klatch/klatch.bsh` CLI verbs | `bashy/examples/klatch` |
| Clipboard safety | secret-shape classifier (`ClipboardCategory`, `ClipboardShape`) used by the ask form and browser guard; **no clipboard read/write command exists** | `yoke/pkg/sensitive/clipboard.go` |
| Extension points | `.bsh` command + `~~~skill as guide`, `commands add` (exec / sha-pinned download / script), `skill add`, `@effects`, `@guard`, `@confirm`, `@sandbox()`, polyglot fences with pinned toolchains | `yoke/pkg/fleet/commands.go`, `sh/polyglot/`, `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]` |
| License rule | compiled in: MIT/Apache/BSD only; a separately downloaded process may carry any license | `bashy/docs/licensing-supply-chain-policy.md` |

Open stories this strategy builds on (linked, not duplicated):

- S520.2 `e7f2d0be4fd1`: Klatch group linked to a meet room. This is the core of the switch-to-Klatch path.
- S519.3 `ea31ee9674f6`: Klatch push relay.
- S519.4 `f352e5847876`: Android build.
- S568 D4 `376dd5d21c7a`: two-way delivery contract.
- S583.6 `c059685e7311`: circle partitions for mb, inbox and notify.
- S619 S2 `40768b892ad2`: signed identity.
- S430 F4-S3 `5e498abf46ae`: webhooks and a Telegram bot from cloudbox.
- S430 F4-S6 `6bdc6f81ca48`: email digest.
- `ad1db13b585f`: deferred channels.
- `42f89d1069ee`: herald inbound gateway.

## Strategy: three layers

### Layer 1: the conversation belongs to bashy

Every human-agent exchange is a meet room conversation on the outpost, with a
stable conversation ref. Klatch, the web UI, Discord, email, SMS or a pasted
link are only views of it. Context never lives inside a third-party tool, so a
switch loses nothing.

### Layer 2: two required faces for every operation

| Operation | Agent face (composable `--json` CLI verbs) | Human face (shaped web UI at `/comms/`, shaped via `/shape/comms/`, mobile PWA) |
|---|---|---|
| List / open conversations | `meet list --json`, `meet show --json`, `meet contributions --json` | Conversations |
| Send, reply, ask | `meet dm`, `notify`, `comms <channel> send --json` | Composer |
| Pairing and approvals | `meet dm` pairing, `/approve`, `approve list\|show\|allow\|deny`, `app pair\|devices\|revoke` | Approvals |
| Channel setup and status | `comms <channel> doctor\|setup\|status --json` | Channels (data-driven discovery from registered `comms-*` commands / `channels.json` catalog — rod, not fish) |
| Switch out | `comms link create --json`, `comms link capsule REF`, `clipboard copy` | "Continue elsewhere": copy, open, QR |
| Switch in | `comms link open REF --json` | link lands on the conversation at `/comms/c/<ref>` or a Klatch topic |

The web UI is one shaped app registered with
`bashy app add comms --type shaped --source <dir>` and served by the existing
web console at `/comms/` (with live shaping at `/shape/comms/` and candidate
previews at `/shape/comms/preview/<id>/`). It is responsive, so it installs as a
PWA ("Add to Home Screen") on iPhone and Android. Phones and remote desktops
reach it through outpost app share under the same circle and group grants.

### Layer 3: instant switching

**Handoff link.**
- An `https` URL to the outpost-shared comms app (`/comms/c/<ref>`), or to a Klatch topic.
- It carries an opaque conversation ref only: no secrets and no message text.
- A leaked link grants nothing, because access still requires sign-in and a passing grant.
- An optional expiry bounds how long a ref resolves (`comms link revoke REF` invalidates it immediately).
- Opening it attaches to the same meet room. The agent keeps running on the outpost.

**Clipboard capsule.** A short plain-text block that pastes into any app (WeChat, iMessage, WhatsApp, Signal, email):

```text
Continue with <agent> on bashy: https://<outpost-share>/comms/c/<ref>
Last: <one-line summary of the last turn>
Agents: bashy comms link open <ref>
```

- **Composable CLI pipeline:** `bashy comms link capsule <ref> | bashy clipboard copy` (and `bashy clipboard paste` for the reverse path).
- **Reverse direction.** The "copy" action in the web UI or Klatch puts an agent reply on the clipboard, to paste back into the third-party app.
- **Redaction.** Capsule and copy text pass through `sensitive.ClipboardCategory` (`ClipboardShape`); secret-shaped content is never placed on the clipboard.

**Getting the link to the user:**
- **Phone:** an ntfy notification with Open and Copy actions, or the PWA share sheet.
- **Desktop to phone:** `bashy share qr`.
- **Agents:** the capsule is delivered over `mb` / `inbox`.

**Klatch continuation.**
- Builds on S520.2: opening the link joins the Klatch topic linked to the room (`meet show --json` + `klatch` verbs).
- The conversation continues in the Klatch phone app or PWA.

**Clipboard on the CLI.**
- No clipboard command exists today.
- Register a standalone `clipboard.bsh` (`clipboard copy` / `clipboard paste`) with `bashy commands add` + `bashy skill add`: `pbcopy`/`pbpaste` on macOS, PowerShell `~~~powershell as ps` fence (`Set-Clipboard`/`Get-Clipboard`) on Windows, `wl-copy`/`xclip` on Linux, enforcing `sensitive.ClipboardCategory` before copying.
- Browsers use the Clipboard API on every platform.

## Channels for US users (official or legal routes only)

| Wave | Channel | Route (reused) | License | Legal basis | Devices |
|---|---|---|---|---|---|
| 1 | Comms web UI + handoff link | shaped app on the existing web console (`/comms/`, shaped via `/shape/comms/`) | own | own software | every browser; PWA on iPhone and Android |
| 1 | ntfy | ntfy server and official apps; publish, SSE/JSON subscribe, action buttons | Apache-2.0 | official apps; iOS push via the ntfy upstream relay | iPhone, Android, CLI everywhere |
| 1 | Email | himalaya CLI: poll `--json`, reply, send; OAuth through Ortie or app passwords | MIT / Apache-2.0 | IMAP/SMTP, provider OAuth | macOS, Windows, Linux sha256-pinned binary; phones via any mail app |
| 1 | Klatch | `examples/klatch` linked to meet rooms (S520.2) | own fork | own software | upstream phone apps, PWA, desktop |
| 2 | Discord, Slack, Telegram | existing `feed` adapters + `comms/lib/listen.bsh` pipeline into `meet dm` | in tree | official bot APIs; Slack Socket Mode and Discord gateway need no public URL | all |
| 2 | SMS | Twilio REST (curl/stdlib REST); inbound by polling the Messages API, no webhook | MIT | official; US A2P 10DLC or toll-free verification required; paid | native SMS on every phone |
| 3 | WhatsApp Cloud API, Microsoft Teams, Google Chat | official APIs | various | business verification or tenant registration; public HTTPS webhook | on demand after the ingress decision |

**Switch-only (no integration).** WeChat, iMessage, personal WhatsApp and Signal have no legally supported bot route for personal use. Users reach bashy from them with the capsule or link, and continue in Klatch or the web UI.

**Excluded:**
- **Client-protocol hooks:** itchat, WeChatFerry, Baileys, whatsmeow. They break platform terms and risk account bans.
- **signal-cli:** unofficial and GPL.
- **AstrBot:** AGPL.
- **n8n:** Sustainable Use License.
- **Dendrite:** maintenance mode.
- **matterbridge:** dormant upstream.
- **Microsoft Bot Framework SDK:** end of life, with no Go SDK.

**Reference only (patterns, not code):**
- OpenClaw (MIT): DM policy, allowlist and pairing, plus its channel plugin layout.
- nanobot (MIT): `BaseChannel`, `is_allowed`, the outbox.
- opencode (MIT): `serve` (OpenAPI plus SSE sessions) and ACP.
- MCP, A2A and AG-UI, for agent and UI interop.

## Example layout, Bash# skill-script contract, and software shaping

- **Layout:** each channel/tool is `bashy/examples/comms/<name>/{<name>.bsh, register.sh, README.md}` (following `bashy/examples/desk/{notepad,form}` and `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`).
  - **One `.bsh` = command + skill:** `#!/usr/bin/env -S bashy --bashsharp`, an embedded `~~~skill as guide` fence (`--skill` / `--help`), and `--contract` / `@effects(...)` metadata.
  - **Small composable `--json` subcommands (rod, not fish):** `doctor | setup | status | send | poll --once --json | listen`. Each subcommand does one thing and emits `--json` so agents and scripts can compose them directly (`poll --once --json | comms listen ...`).
  - **Non-destructive registration (`register.sh`):** registers the command (`bashy commands add --from <name>.bsh` or `--mode exec`) and skill (`bashy skill add <name>.bsh`) without clobbering existing user registrations.
  - **External binaries:** fetched via sha256-pinned `download` commands or a resumable `doctor` verb (`media.bsh` / `onboard.bsh` pattern).
- **Shaped app layout (`bashy/examples/comms/web/`):**
  - Registered with `bashy app add comms --type shaped --source <dir>` (live at `/comms/`, shaped at `/shape/comms/`).
  - Required shaping artifacts (`yoke/pkg/shape/verify`):
    1. `contract.bsh` declaring `@effects(...)` (fail-closed if missing),
    2. `checks/smoke.bsh` exercising every page and API route (fail-closed if missing),
    3. `shaped.json` declaring `"properties"` (enforced by expand-then-contract `shape/compat` surface verification) and `"genie"` placement + example wishes,
    4. `public/` static PWA assets (Genie button auto-injected by the web console; existing `public/*` routes, `api/*.md` units, and `shaped.json` properties evolve via expand-then-contract).
- **Inbound pipeline:** `<channel>.bsh poll --once --json` (or stream) → `bashy-feed-envelope-v1` JSONL → `comms/lib/listen.bsh` → `bashy meet dm "$AGENT" --channel "$C" --sender "$S" [--thread "$T"]` (stdin) → `<channel>.bsh send` on the same channel and thread.
- **Pairing:** exactly one gate. Listeners pass every sender through, and `meet dm` owns pairing, scopes and `/approve`. This avoids `Listen` silently dropping an unpaired sender before a pair code can be issued.
- **Destructive verbs** need `/approve`, from the chat, an ntfy action button or the web UI.
- **Where listeners run:** as a bashy service on Linux, and in the foreground or as a service on macOS and Windows.

### Named shaping hooks across C1–C8

| Story | Surface | Shaping hooks (user/agent tunable via `bashy shape` or `.bsh` config, zero Go edits) |
|---|---|---|
| C1 (`comms` web UI) | `public/`, `shaped.json`, `comms.bsh` | Navigation tabs, conversation card layout, composer quick-reply/canned-response presets, declarative `channels.json` catalog cards, `shaped.json` `properties` & `genie.examples` |
| C2 (`comms link` + `clipboard`) | `link.bsh`, `clipboard.bsh` | Plain-text 3-line capsule template, default handoff link TTL, summary line length/format |
| C3 (`comms/ntfy`) | `ntfy.bsh` | Notification action button presets (Approve/Deny/Open/Copy labels & commands), priority/tag mapping, topic routing |
| C4 (`comms/email`) | `email.bsh` | Subject prefix, reply/digest template, polling folder and sender filter rules |
| C5 (`comms/klatch`) | `link.bsh` / `klatch.bsh` | Handoff target preference (`klatch` app/web vs `/comms/c/<ref>` fallback) |
| C6 (`comms/lib/listen.bsh` + bots) | `listen.bsh`, `{discord,slack,telegram}.bsh` | Pre-`meet dm` envelope filter/transform function, reply wrapper format, per-sender cooldown/rate limit |
| C7 (`comms/sms`) | `sms.bsh` | 160-char SMS truncation/capsule template, polling interval, sender allowlist pre-filter |
| C8 (webhook ingress spike) | decision doc + prototype | Provider-agnostic webhook-to-`bashy-feed-envelope-v1` `.bsh` normalizer contract under outpost app share grants |

## Graduation (examples, then optional, then core)

An example graduates when all of these hold:
- green two-way runs on Windows, macOS and Linux, and on iPhone and Android through the app or PWA;
- two or more owners use it;
- a license row exists in `bashy/docs/license-inventory.md`;
- a decision story is recorded.

The first candidate is `comms/lib/listen.bsh`, as a `bashy feed listen` verb that gives the existing `Listen`/`Poll` code a caller.

## Stories (Sprint 620 `91b5eb56-f45a-5905-acd4-c67eddfb7e69`)

| Story | ID | Scope | Planned worker |
|---|---|---|---|
| C1 | `1aae9e0e3ac5` | Comms web UI: shaped `comms` app (`/comms/`, `/shape/comms/`), PWA, four pages backed by `--json` CLI verbs, `contract.bsh` + `checks/smoke.bsh` + `shaped.json` | claude-sonnet5.5 |
| C2 | `4bf3015237d1` | `comms link` (`create\|capsule\|open\|revoke --json`) and standalone `clipboard.bsh` (`copy\|paste` per OS with `sensitive.ClipboardCategory` redaction) | claude-opus5.5 |
| C3 | `46433a7796d3` | ntfy two-way (`ntfy.bsh`): composable `doctor\|setup\|status\|send\|poll\|listen --json`, Approve/Deny/Open/Copy actions into `meet dm` | codex-gpt6-sol |
| C4 | `8d4a91d1c1b5` | Email via sha256-pinned himalaya (`email.bsh`): `doctor\|setup\|status\|poll\|send\|reply\|digest\|listen --json` + KB runbook | opencode-glm-5.3 |
| C5 | `73d6c801c709` | Klatch continuation: composable `.bsh` resolution of room → Klatch topic URL in `comms link` (depends on S520.2) | claude-opus5.5 |
| C6 | `c5ca9e3369d5` | Generic `comms/lib/listen.bsh` (`bashy-feed-envelope-v1` → `meet dm` → `send`) + thin Discord, Slack, Telegram `.bsh` wrappers | agy-gemini3.8-flash |
| C7 | `626893f39497` | SMS via Twilio REST (`sms.bsh`): `doctor\|setup\|status\|send\|poll\|listen --json` with vault-held secrets | muse-spark1.3 |
| C8 | `cd9d0870e0a2` | Decision: provider-agnostic webhook ingress (`webhook` → `bashy-feed-envelope-v1` `.bsh` normalizer) through the outpost, gating wave 3 | claude-opus5.5 |

Planned workers are not assignments; the sprint stays in backlog until the
operator starts it.

**Acceptance common to C1–C7:**
- both directions work;
- CLI and web parity holds (one-way: every web action invokes a composable `--json` CLI verb; no web-only operations);
- **rod, not fish (`[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`):** each command is a `.bsh` file (`#!/usr/bin/env -S bashy --bashsharp`) with an embedded `~~~skill as guide` fence (`--skill`) and `--contract` / `@effects(...)`, registered via `bashy commands add` + `bashy skill add`, exposing small standalone `--json` verbs composed in pipelines;
- **software shaping:** shaped surfaces carry `contract.bsh`, `checks/smoke.bsh`, and `shaped.json` (`properties` + `genie`), name their shaping hooks, and pass `bashy shape` verification (`verify` / `preview` / `approve` / `undo` and `shape/compat` expand-then-contract);
- Windows and macOS client and Linux service are all exercised, plus iPhone and Android;
- a paired member is allowed, an unpaired sender gets a pair code, and a non-member is denied;
- destructive verbs are gated by `/approve`;
- new dependencies pass the licensing-policy checklist.

## End-to-end walk-through (acceptance of the strategy)

1. A user on an iPhone is chatting in WeChat.
2. An agent working on an outpost needs the user's answer. It sends an ntfy push with a capsule and Open/Copy actions.
3. The user taps Open. Safari (or the installed PWA) shows the comms conversation after sign-in, and the grant passes. Alternatively, the linked Klatch topic opens in the Klatch app.
4. The user answers. The agent continues on the outpost.
5. The user taps Copy on the agent's reply and pastes it into the WeChat thread.
6. Later, at a Windows desktop, the user opens the same conversation in a browser, or an agent runs `bashy comms link open <ref>`. Same room, same context.
