---
id: 8d4a91d1c1b5
kind: feature
title: 'C4 comms/email: two-way email via himalaya CLI (listen by poll, send, reply, digest)'
seq: 152
status: todo
priority: p1
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.389209Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Implement two-way email in `bashy/examples/comms/email/` via the `himalaya` CLI (MIT/Apache-2.0) as a sha256-pinned download for macOS, Windows, and Linux, following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]` and `[[kb:gmail-setup-send-and-verify]]` (relates `6bdc6f81ca48`). Planned worker: opencode-glm-5.3.

### Rod, Not Fish (One `email.bsh` = Command + Skill + Composable `--json` Verbs)
- **Single Bash# skill-script `email.bsh` (`#!/usr/bin/env -S bashy --bashsharp`):**
  - Carries an embedded `~~~skill as guide` fence (`--skill` / `--help`) and `--contract` / `@effects(net,read,write,exec)` metadata.
  - Registered via idempotent `register.sh` (`bashy commands add` + `bashy skill add`, including sha256-pinned `himalaya` download per OS/arch).
- **Small standalone `--json` verbs composed in pipelines (`media.bsh` & `onboard.bsh` pattern):**
  - `doctor` / `setup [--json]`: verifies or installs the sha256-pinned `himalaya` binary, checks vault-backed credentials (`bashy secret`, app password or OAuth via Ortie), prints exact human steps when interaction is required, and resumes cleanly after the human finishes.
  - `status [--json]`: checks IMAP/SMTP account connectivity and emits machine-readable status for CLI and the C1 Channels page.
  - `poll [--once] [--folder INBOX] --json`: runs `himalaya envelope list --json` for unseen messages and emits normalized `bashy-feed-envelope-v1` JSONL on stdout (passing every sender through so `meet dm` owns the single pairing gate).
  - `send` & `reply [--json]`: sends a new email or threaded reply (optionally embedding a C2 handoff capsule).
  - `digest [--json]`: thin composition reading unread inbox/room summaries and piping them to `email.bsh send`.
  - `listen`: thin composition piping `email.bsh poll --json` into `comms/lib/listen.bsh` (C6) -> `bashy meet dm` -> `email.bsh reply`.
- **Generic KB runbook:** Contribute/update a generic email runbook under `bashy/kb/defaults/pages/` teaching the composable verbs and provider OAuth/app-password steps (rod, not a single-account script).

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** Email subject prefix, plain-text reply/digest templates, polled IMAP folder, and optional pre-filter rules live in shapeable `.bsh` / template files rather than hardcoded code.

### Acceptance
- Both directions work across macOS, Windows, and Linux using the sha256-pinned `himalaya` binary.
- `email.bsh --skill`, `email.bsh --contract`, and `email.bsh poll --once --json` work standalone in pipelines.
- CLI and web parity (backed by `email.bsh setup|status|send --json`); paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md` (with license-inventory entry if required); lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
