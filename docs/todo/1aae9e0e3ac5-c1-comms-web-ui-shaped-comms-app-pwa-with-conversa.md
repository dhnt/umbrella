---
id: 1aae9e0e3ac5
kind: feature
title: 'C1 Comms web UI: shaped comms app (PWA) with Conversations, Composer, Approvals, Channels pages'
seq: 149
status: todo
priority: p1
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:24.994843Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Register one shaped app `comms` in `bashy/examples/comms/web/` via `bashy app add comms --type shaped --source <dir>` (pattern `bashy/examples/desk/notepad/` & `form/` and `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`), served live by the web console at `/comms/` and shaped via the injected Genie button and `/shape/comms/` (candidate previews at `/shape/comms/preview/<id>/`); responsive so it installs as a PWA on iPhone and Android; remote via outpost app share under circle/group grants. Planned worker: claude-sonnet5.5.

### Rod, Not Fish (Bash# Skill-Script + Composable CLI Verbs)
- **One `.bsh` = command + skill:** `comms.bsh` (`#!/usr/bin/env -S bashy --bashsharp`) carries an embedded `~~~skill as guide` fence (`--skill` / `--help`) and `--contract` / `@effects(...)` metadata; `register.sh` registers the command (`bashy commands add`), skill (`bashy skill add`), and shaped app (`bashy app add comms --type shaped --source`) without clobbering existing user registrations.
- **Strict one-way CLI -> Web parity (zero web-only logic):** Every web page and API route delegates to composable `--json` CLI verbs:
  - **Conversations:** `bashy meet list --json`, `bashy meet show <room> --json`, `bashy meet contributions <room> --json`.
  - **Composer:** `bashy meet dm <agent> --channel web --sender <user> [--thread <ref>]`, `bashy notify`, `bashy comms <channel> send --json`.
  - **Approvals:** `bashy approve list --json`, `bashy approve show <id> --json`, `bashy approve allow|deny <id>`, `bashy app pair [approve|deny]`, `bashy app devices --json`, `bashy app revoke <id>`.
  - **Channels (data-driven discovery — rod, not fish):** Discovers installed `comms-*` commands / declarative `channels.json` catalog dynamically and invokes `bashy comms <channel> doctor|setup|status --json` so adding a new channel requires zero web UI code changes.
  - **Switch ("Continue elsewhere"):** Calls `bashy comms link create --json`, `bashy comms link capsule <ref>`, `bashy share qr`.

### Software Shaping Contract & Shaping Hooks
- **Required shaping artifacts (`yoke/pkg/shape/verify`):**
  1. `contract.bsh` declaring `@effects(...)` (verifier fails closed without an effect cap).
  2. `checks/smoke.bsh` exercising all four pages and JSON endpoints (verifier fails closed without required checks).
  3. `shaped.json` declaring `"properties"` (enforced by expand-then-contract `shape/compat` surface verification across `public/*`, `api/*.md`, and `shaped.json`) and `"genie"` placement + example wishes.
- **Named shaping hooks:** Navigation tabs, conversation card layout, composer canned-reply / quick-action presets, and `channels.json` catalog cards live in declarative files under `public/` and `shaped.json` (never hardcoded Go) so users/agents can reshape them via `bashy shape`.

### Acceptance
- Both directions work; strict one-way CLI and web parity (`--json` CLI verbs back every web action).
- `comms.bsh --skill` and `comms.bsh --contract` pass; `register.sh` is idempotent.
- End-to-end `bashy shape` proof: `wish -> verify -> preview -> approve -> undo` passes `contract.bsh`, `checks/smoke.bsh`, and `shape/compat` expand-then-contract checks.
- Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
