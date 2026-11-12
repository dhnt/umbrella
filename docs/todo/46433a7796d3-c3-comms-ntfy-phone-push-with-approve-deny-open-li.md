---
id: 46433a7796d3
kind: feature
title: 'C3 comms/ntfy: phone push with Approve/Deny, Open link and Copy capsule actions; subscribe into meet dm'
seq: 151
status: todo
priority: p1
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.257347Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Implement two-way phone push in `bashy/examples/comms/ntfy/` using ntfy (Apache-2.0) server + official iOS/Android apps, reusing the existing ntfy sink (story `33f400bc9ac3`) and following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`. Planned worker: codex-gpt6-sol.

### Rod, Not Fish (One `ntfy.bsh` = Command + Skill + Composable `--json` Verbs)
- **Single Bash# skill-script `ntfy.bsh` (`#!/usr/bin/env -S bashy --bashsharp`):**
  - Carries an embedded `~~~skill as guide` fence (`--skill` / `--help`, documenting setup + iOS push via the ntfy upstream relay) and `--contract` / `@effects(net,read,write)` metadata.
  - Registered via idempotent `register.sh` (`bashy commands add` + `bashy skill add`) and auto-discovered by the `comms` web UI Channels page (C1).
- **Small standalone `--json` verbs composed in pipelines:**
  - `doctor` / `setup [--json]`: checks server/topic reachability and credentials (`bashy secret`), prints any human phone-app subscription steps, and is resumable (`onboard.bsh` pattern).
  - `status [--json]`: reports configured server, topics, and listener health for the CLI and C1 Channels page.
  - `send [--topic T] [--ref REF] [--approve-id ID] [--json]`: publishes a notification with action buttons (`Approve` / `Deny` resolving `/approve <id>` or `/deny <id>`, `Open` opening the C2 handoff URL `/comms/c/<ref>`, `Copy` copying the redacted C2 capsule).
  - `poll [--once] [--since ...] --json`: subscribes/fetches from the ntfy JSON/SSE stream and emits normalized `bashy-feed-envelope-v1` JSONL on stdout.
  - `listen`: thin composition piping `ntfy.bsh poll --json` into `comms/lib/listen.bsh` (C6) -> `bashy meet dm` -> `ntfy.bsh send` reply on the same topic/thread.

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** Action button presets (labels, HTTP/view action templates for Approve/Deny/Open/Copy), priority/tag mappings, and topic routing rules are defined in declarative config / `.bsh` functions so users and agents can shape notification behavior without editing Go code.

### Acceptance
- Both directions work (agent push with Approve/Deny/Open/Copy actions -> phone -> reply or button tap -> `meet dm` / `/approve`).
- `ntfy.bsh --skill`, `ntfy.bsh --contract`, and standalone `poll --once --json` pipeline composition work on macOS, Windows, and Linux.
- CLI and web parity (C1 Channels & Composer call `ntfy.bsh status|setup|send --json`); Windows+macOS client, Linux service, iPhone+Android via official ntfy app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
