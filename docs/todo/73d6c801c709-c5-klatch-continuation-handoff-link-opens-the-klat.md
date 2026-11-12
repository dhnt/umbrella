---
id: 73d6c801c709
kind: feature
title: 'C5 Klatch continuation: handoff link opens the Klatch topic linked to the meet room'
seq: 153
status: todo
priority: p2
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.518672Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Wire handoff-link continuation into Klatch (`bashy/examples/comms/` + `bashy/examples/klatch/`) so opening a C2 handoff link resolves and joins the Klatch topic linked to the meet room, following `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]`. Depends on S520.2 `e7f2d0be4fd1` (Klatch group <-> meet room) and benefits from S519.3 `ea31ee9674f6` push relay and S519.4 `f352e5847876` Android; do not duplicate them. Planned worker: claude-opus5.5.

### Rod, Not Fish (Thin Bash# Composition of Small `--json` Verbs)
- **Compose existing verbs, zero duplicated state:**
  - `comms link create --room <id> --json` and `comms link open <ref> [--target auto|klatch|web] --json` compose `bashy meet show <room> --json` and the `examples/klatch/klatch.bsh` verbs (`conversations-list` / topic binding from S520.2) to emit both `url` (`/comms/c/<ref>`) and `klatch_url` (when a linked Klatch topic exists).
  - Kept inside `.bsh` skill-scripts (`#!/usr/bin/env -S bashy --bashsharp`, `~~~skill as guide`, `--skill`, `--contract` / `@effects`) rather than adding custom Go resolvers.
- **Reverse copy parity:** Copying an agent reply from Klatch or via `comms link` passes through `clipboard.bsh` (`sensitive.ClipboardCategory` redaction) so the user can paste it back into a third-party app.

### Software Shaping & Shaping Hooks
- **Named shaping hooks:** Target preference (`auto`, `klatch` app/PWA first, or `/comms/c/<ref>` web UI fallback) and the "Open in Klatch" action in the C1 `comms` web UI ("Continue elsewhere" sheet + `shaped.json` `properties`) are declarative and shapeable via `bashy shape`.

### Acceptance
- Both directions work: a handoff link (`comms link open <ref>` or tapping the URL on phone/desktop) lands in the linked Klatch topic when present (or falls back cleanly to `/comms/c/<ref>`), and the conversation continues with the same outpost agents.
- CLI and web parity (`comms link create|open --json` backs the web UI "Open in Klatch" action); Windows+macOS client, Linux service, iPhone+Android via Klatch app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by `/approve`; new deps pass `bashy/docs/licensing-supply-chain-policy.md`; lands in `bashy/examples/comms/` (and `examples/klatch` if needed) only. Spec: `docs/comms-strategy.md`.
