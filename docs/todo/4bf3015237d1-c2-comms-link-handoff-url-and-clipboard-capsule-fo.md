---
id: 4bf3015237d1
kind: feature
title: 'C2 comms link: handoff URL and clipboard capsule for instant tool switching (CLI + web)'
seq: 150
status: todo
priority: p1
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.126105Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Build composable handoff-link and clipboard verbs in `bashy/examples/comms/link/` and `bashy/examples/comms/clipboard/` for instant tool switching between third-party apps (WeChat, iMessage, WhatsApp, Signal, email) and bashy (`/comms/c/<ref>` or linked Klatch topic), following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`. Planned worker: claude-opus5.5.

### Rod, Not Fish (Small Composable `--json` Verbs + `.bsh` Skill-Scripts)
- **Split into two orthogonal `.bsh` skill-scripts (`#!/usr/bin/env -S bashy --bashsharp`, `~~~skill as guide`, `--skill`, `--contract` / `@effects`):**
  1. **`clipboard.bsh` (`bashy clipboard copy|paste`):**
     - `clipboard copy` reads stdin, classifies content via `yoke/pkg/sensitive` (`ClipboardCategory` / `ClipboardShape`), refuses secret-shaped content (`--force` only with explicit `@confirm`), and writes to the OS clipboard (`pbcopy` on macOS, `~~~powershell as ps` fence `Set-Clipboard` on Windows, `wl-copy`/`xclip` on Linux).
     - `clipboard paste` emits clipboard plain text to stdout (`pbpaste`, `Get-Clipboard`, `wl-paste`/`xclip -o`).
     - Browsers use the standard Clipboard API on the web face.
  2. **`link.bsh` (`bashy comms link create|capsule|open|revoke`):**
     - `create --room <id> [--ttl <dur>] [--json]`: generates an opaque conversation ref (no secrets, no message text; access still requires sign-in + circle/group grant; optional expiry) and emits `{ref, url, klatch_url, capsule, expires_at}` (`url` points to `https://<outpost-share>/comms/c/<ref>`).
     - `capsule <ref> [--json]`: outputs the redacted 3-line plain-text capsule (`Continue with <agent> on bashy: ...`, `Last: <one-line summary>`, `Agents: bashy comms link open <ref>`).
     - `open <ref> [--json]`: resolves `<ref>` to the meet room / linked Klatch target so an agent or browser attaches to the same conversation.
     - `revoke <ref> [--json]`: invalidates `<ref>` immediately.
- **Pipeline composition:** Works standalone in Unix/Bash# pipelines: `bashy comms link capsule <ref> | bashy clipboard copy`, `bashy share qr "$(bashy comms link create --room R --fields url)"`, or over `mb`/`inbox` and `comms/ntfy` (C3).

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** The 3-line capsule template, summary line truncation length, and default link TTL live in shapeable `.bsh` / declarative config rather than hardcoded Go, and the "Continue elsewhere" sheet in the `comms` web UI (C1) exposes copy/open/QR properties in `shaped.json`.
- **Reverse direction:** The "copy" action in the web UI or Klatch copies an agent reply through the same `ClipboardCategory` redaction guard to paste back into the third-party app.

### Acceptance
- Both directions work (WeChat/third-party app on phone -> copy/open link -> web UI `/comms/c/<ref>` or Klatch -> agent reply -> copy back).
- `clipboard.bsh` and `link.bsh` each include `~~~skill as guide` (`--skill`), `--contract`, and idempotent `register.sh` (`commands add` + `skill add`).
- Secret-shaped strings are blocked by `ClipboardCategory` before touching the OS or browser clipboard.
- CLI and web parity; Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` only. Spec: `docs/comms-strategy.md`.
