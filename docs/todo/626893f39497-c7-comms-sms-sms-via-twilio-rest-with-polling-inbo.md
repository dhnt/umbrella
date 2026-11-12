---
id: 626893f39497
kind: feature
title: 'C7 comms/sms: SMS via Twilio REST with polling inbound (no webhook)'
seq: 155
status: todo
priority: p3
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.784136Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Implement two-way SMS in `bashy/examples/comms/sms/` via the official Twilio Messages REST API with polling inbound (no public webhook required), following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]` (relates `c512b342864d`). Planned worker: muse-spark1.3.

### Rod, Not Fish (One `sms.bsh` = Command + Skill + Composable `--json` Verbs)
- **Single Bash# skill-script `sms.bsh` (`#!/usr/bin/env -S bashy --bashsharp`):**
  - Carries an embedded `~~~skill as guide` fence (`--skill` / `--help`, documenting US A2P 10DLC / toll-free verification steps and per-message cost) and `--contract` / `@effects(net,read,write)` metadata.
  - Registered via idempotent `register.sh` (`bashy commands add` + `bashy skill add`) and auto-discovered by the C1 Channels page.
  - Uses curl/stdlib REST against Twilio's Messages API with credentials (`TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_FROM_NUMBER`) read from `bashy secret` (never passed in command-line argv).
- **Small standalone `--json` verbs composed in pipelines:**
  - `doctor` / `setup [--json]`: checks vault credentials and Twilio number status, prints exact human steps for US A2P 10DLC or toll-free verification when needed, and resumes cleanly (`onboard.bsh` pattern).
  - `status [--json]`: verifies account/number readiness and emits JSON for the CLI and C1 Channels page.
  - `send --to <E164> [--json]`: sends an outbound SMS (with optional C2 handoff link/capsule for long agent turns).
  - `poll [--once] [--since ...] --json`: polls Twilio's inbound Messages list, tracks the high-water message SID/timestamp in state, and emits normalized `bashy-feed-envelope-v1` JSONL on stdout.
  - `listen`: thin composition piping `sms.bsh poll --json` into `comms/lib/listen.bsh` (C6) -> `bashy meet dm` -> `sms.bsh send`.

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** 160-character SMS truncation + C2 handoff-link footer template, polling interval, and E.164 sender pre-filter rules live in shapeable `.bsh` config/functions rather than compiled Go.

### Acceptance
- Both directions work over Twilio REST (`send --json` and `poll --once --json | listen.bsh` -> `meet dm` -> SMS reply).
- `sms.bsh --skill` and `sms.bsh --contract` pass; credentials never appear in process argv or logs.
- CLI and web parity (backed by `sms.bsh setup|status|send --json`); Windows+macOS client, Linux service, iPhone+Android native SMS; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
