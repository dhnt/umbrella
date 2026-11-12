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
4. **Examples first.** New work lands in `bashy/examples/comms/` and graduates
   to optional, then core, only on evidence.
5. **Platforms.** Client pieces: macOS and Windows at minimum. Services and
   listeners: Linux at minimum. Prefer choices that work on all three.

## What already exists (reuse, do not rebuild)

| Area | Existing | Where |
|---|---|---|
| Single inbound door | `bashy meet dm AGENT --channel C --sender S [--thread T]`: text on stdin, reply on stdout; sender pairing with ask/control/approve scopes, `/approve`, room timeline | `yoke/pkg/meet/dm_frontdoor.go` |
| Channel adapters | `bashy feed`, envelope `bashy-feed-envelope-v1`. Discord gateway, Slack Socket Mode and Telegram poll are implemented but **nothing outside tests calls the inbound `Listen`/`Poll`**; `bridge.go` relays channel to channel only. Outbound uses the Go adapters or the pinned `openclaw message send` | `yoke/pkg/feed/adapters/`, `yoke/docs/feed-adapter-contract.md` |
| Bus and push | `mb`, `inbox`, `notify`, `ping`; desktop, ntfy and webhook sinks as skill functions; cross-host delivery through a cloudbox team session | `yoke/pkg/bus/`, `bashy/docs/unified-inbox.md` |
| Durable context | meet rooms and room timelines | `yoke/pkg/meet`, `yoke/pkg/room` |
| Agent faces | `bashy mcp serve --allow EFFECTS` (effect policy, audit), `bashy acp`, herald (A2A) | `yoke/mcp/`, `yoke/pkg/acp`, `yoke/pkg/herald` |
| Authorization | circles AND (group OR email); outpost default-deny; outpost app share for remote browsers | `outpost/internal/agent/grants.go`, `yoke/pkg/boundary/members.go` |
| Human web host | shaped apps on the local web console at `/shape/{app}/` | `yoke/pkg/webconsole`, pattern `bashy/examples/desk/notepad/register.sh` |
| Link to a phone | `bashy share qr URL` | `yoke/pkg/share/share.go` |
| Own chat | Klatch (Databag fork) with upstream phone apps | `bashy/examples/klatch` |
| Clipboard safety | secret-shape classifier used by the ask form and browser guard; **no clipboard read/write command exists** | `yoke/pkg/sensitive/clipboard.go` |
| Extension points | `.bsh` command + `~~~skill` guide, `commands add` (exec / sha-pinned download / script), `@guard`, `@confirm`, `@sandbox()`, polyglot fences with pinned toolchains | `yoke/pkg/fleet/commands.go`, `sh/polyglot/` |
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

| Operation | Agent face (CLI) | Human face (web UI, `/shape/comms/`, mobile PWA) |
|---|---|---|
| List / open conversations | `meet`, `room` list and show | Conversations |
| Send, reply, ask | `meet dm`, `notify`, `comms <channel> send` | Composer |
| Pairing and approvals | `meet dm` pairing, `/approve`, `app pair` | Approvals |
| Channel setup and status | `comms <channel> setup\|status` | Channels |
| Switch out | `comms link create` (link + capsule) | "Continue elsewhere": copy, open, QR |
| Switch in | `comms link open REF` | link lands on the conversation or a Klatch topic |

The web UI is one shaped app served by the existing web console. It is
responsive, so it installs as a PWA ("Add to Home Screen") on iPhone and
Android. Phones and remote desktops reach it through outpost app share under
the same circle and group grants.

### Layer 3: instant switching

**Handoff link.**
- An `https` URL to the outpost-shared comms app, or to a Klatch topic.
- It carries an opaque conversation ref only: no secrets and no message text.
- A leaked link grants nothing, because access still requires sign-in and a passing grant.
- An optional expiry bounds how long a ref resolves.
- Opening it attaches to the same meet room. The agent keeps running on the outpost.

**Clipboard capsule.** A short plain-text block that pastes into any app (WeChat, iMessage, WhatsApp, Signal, email):

```text
Continue with <agent> on bashy: https://<outpost-share>/shape/comms/c/<ref>
Last: <one-line summary of the last turn>
Agents: bashy comms link open <ref>
```

- **Reverse direction.** The "copy" action in the web UI or Klatch puts an agent reply on the clipboard, to paste back into the third-party app.
- **Redaction.** Capsule and copy text pass through `sensitive.ClipboardCategory`; secret-shaped content is never placed on the clipboard.

**Getting the link to the user:**
- **Phone:** an ntfy notification with Open and Copy actions, or the PWA share sheet.
- **Desktop to phone:** `bashy share qr`.
- **Agents:** the capsule is delivered over `mb` / `inbox`.

**Klatch continuation.**
- Builds on S520.2: opening the link joins the Klatch topic linked to the room.
- The conversation continues in the Klatch phone app or PWA.

**Clipboard on the CLI.**
- No clipboard command exists today.
- Register one with `bashy commands add` in the example: `pbcopy`/`pbpaste` on macOS, PowerShell `Set-Clipboard`/`Get-Clipboard` on Windows, `wl-copy`/`xclip` on Linux.
- Browsers use the Clipboard API on every platform.

## Channels for US users (official or legal routes only)

| Wave | Channel | Route (reused) | License | Legal basis | Devices |
|---|---|---|---|---|---|
| 1 | Comms web UI + handoff link | shaped app on the existing web console | own | own software | every browser; PWA on iPhone and Android |
| 1 | ntfy | ntfy server and official apps; publish, SSE subscribe, action buttons | Apache-2.0 | official apps; iOS push via the ntfy upstream relay | iPhone, Android, CLI everywhere |
| 1 | Email | himalaya CLI: poll `--json`, reply, send; OAuth through Ortie or app passwords | MIT / Apache-2.0 | IMAP/SMTP, provider OAuth | macOS (brew), Windows (scoop), Linux binary; phones via any mail app |
| 1 | Klatch | `examples/klatch` linked to meet rooms (S520.2) | own fork | own software | upstream phone apps, PWA, desktop |
| 2 | Discord, Slack, Telegram | existing `feed` adapters + listener glue into `meet dm` | in tree | official bot APIs; Slack Socket Mode and Discord gateway need no public URL | all |
| 2 | SMS | Twilio REST (twilio-go MIT or curl); inbound by polling the Messages API, no webhook | MIT | official; US A2P 10DLC or toll-free verification required; paid | native SMS on every phone |
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

## Example layout and inbound design

- **Layout:** each channel is `bashy/examples/comms/<name>/{<name>.bsh, register.sh, README.md}`.
  - Subcommands: `setup | listen | send | status`.
  - An embedded `~~~skill` guide.
  - Tools as sha-pinned `download` commands.
- **Inbound:** listener → `bashy-feed-envelope-v1` → `bashy meet dm` (stdin) → reply on the same channel and thread.
- **Pairing:** exactly one gate. Listeners pass every sender through, and `meet dm` owns pairing, scopes and `/approve`. This avoids `Listen` silently dropping an unpaired sender before a pair code can be issued.
- **Destructive verbs** need `/approve`, from the chat, an ntfy action button or the web UI.
- **Shared code:** listeners share `comms/lib/listen.bsh`.
- **Where listeners run:** as a bashy service on Linux, and in the foreground or as a service on macOS and Windows.

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
| C1 | `1aae9e0e3ac5` | Comms web UI: shaped `comms` app, PWA, four pages, each backed by a CLI subcommand | claude-sonnet5.5 |
| C2 | `4bf3015237d1` | `comms link` handoff link and clipboard capsule, CLI and web, clipboard command per OS, redaction | claude-opus5.5 |
| C3 | `46433a7796d3` | ntfy two-way: push, Approve/Deny, Open, Copy actions, subscribe into `meet dm` | codex-gpt6-sol |
| C4 | `8d4a91d1c1b5` | Email via himalaya: setup, listen (poll), send, reply, digest | opencode-glm-5.3 |
| C5 | `73d6c801c709` | Klatch continuation: handoff link opens the linked Klatch topic (depends on S520.2) | claude-opus5.5 |
| C6 | `c5ca9e3369d5` | Discord, Slack, Telegram listener glue (`comms/lib/listen.bsh`) | agy-gemini3.8-flash |
| C7 | `626893f39497` | SMS via Twilio REST with polling inbound | muse-spark1.3 |
| C8 | `cd9d0870e0a2` | Decision: general webhook ingress through the satellite, which gates wave 3 | claude-opus5.5 |

Planned workers are not assignments; the sprint stays in backlog until the
operator starts it.

**Acceptance common to C1–C7:**
- both directions work;
- CLI and web parity holds;
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
