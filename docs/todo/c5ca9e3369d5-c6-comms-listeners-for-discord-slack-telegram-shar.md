---
id: c5ca9e3369d5
kind: feature
title: 'C6 comms listeners for Discord, Slack, Telegram: shared comms/lib/listen.bsh into meet dm'
seq: 154
status: todo
priority: p2
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.647373Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Build the shared channel-agnostic listener pipeline `bashy/examples/comms/lib/listen.bsh` and thin per-channel skill-scripts for Discord, Slack, and Telegram (`bashy/examples/comms/{discord,slack,telegram}/`), giving the existing `yoke/pkg/feed/adapters` (`Listen`/`Poll` and `Send`) a production caller into `bashy meet dm`, following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`. Graduation candidate for `bashy feed listen`. Planned worker: agy-gemini3.8-flash.

### Rod, Not Fish (Composable `listen.bsh` Pipeline + One `.bsh` per Channel)
- **`comms/lib/listen.bsh` (`#!/usr/bin/env -S bashy --bashsharp`, `~~~skill as guide`, `--skill`, `--contract`):**
  - Generic pipeline verb (`listen --agent <agent> --channel <c> [--send-cmd <cmd>] [--once] [--dry-run] [--json]`) that reads `bashy-feed-envelope-v1` JSONL from stdin (or `--poll-cmd`), invokes `bashy meet dm "$AGENT" --channel "$C" --sender "$S" [--thread "$T"]` with the message body on stdin, and pipes the stdout reply into the channel's `send` verb on the same channel and thread.
  - **Single pairing gate:** Listeners use a pass-through sender check so every inbound sender reaches `bashy meet dm`, which owns pairing codes, scopes (`ask`/`control`/`approve`), and `/approve` (preventing `Listen` from silently dropping an unpaired sender before a pair code can be issued).
  - Reused by `ntfy.bsh` (C3), `email.bsh` (C4), and `sms.bsh` (C7).
- **Per-channel `.bsh` skill-scripts (`discord.bsh`, `slack.bsh`, `telegram.bsh`):**
  - Each file is a standalone `.bsh` command + embedded `~~~skill as guide` (`--skill`, `--contract`), registered via idempotent `register.sh` (`bashy commands add` + `bashy skill add`) and auto-discovered by the C1 Channels page.
  - Exposes composable `--json` subcommands: `doctor` / `setup` (vault-backed bot tokens via `bashy secret`, prints exact Discord Gateway / Slack Socket Mode / Telegram BotFather steps), `status --json`, `send --json`, `poll [--once] --json` (Telegram `Poll` loop with `timeout=30`; Discord gateway / Slack Socket Mode stream emitting `bashy-feed-envelope-v1`), and `listen` (piping `poll --json` into `comms/lib/listen.bsh`).

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** Pre-`meet dm` envelope filter/transform function, reply wrapper/formatting template (e.g. thread quoting or appending a C2 handoff link when a response is long), and per-sender rate/cooldown settings live in shapeable `.bsh` hooks rather than compiled Go.

### Acceptance
- Both directions work for Discord, Slack, and Telegram (`poll --once --json | listen.bsh` and continuous `listen` service mode -> `meet dm` -> channel reply).
- Each `.bsh` passes `--skill` and `--contract`; `register.sh` is idempotent.
- CLI and web parity (C1 Channels & Composer invoke `<channel>.bsh setup|status|send --json`); Windows+macOS client, Linux service, iPhone+Android via official apps or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
