---
id: 4bf3015237d1
kind: feature
title: 'C2 comms link: handoff URL and clipboard capsule for instant tool switching (CLI + web)'
seq: 150
status: todo
priority: p1
labels:
    - communications
created: 2026-11-12T16:17:25.126105Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

comms link create|open REF. Handoff link = https URL to the outpost-shared comms app or linked Klatch topic carrying an opaque conversation ref (no secrets, no message text; access still needs sign-in + grant; optional expiry). Capsule = link + one-line last-turn summary + 'bashy comms link open REF'. Reverse 'copy' of an agent reply. Redact via yoke/pkg/sensitive ClipboardCategory. No clipboard command exists: register one via bashy commands add (pbcopy/pbpaste, PowerShell Set/Get-Clipboard, wl-copy/xclip); browsers use the Clipboard API. Delivery: ntfy (C3), bashy share qr, mb/inbox. Walk-through: WeChat on phone -> copy/open -> web UI or Klatch -> agent reply -> copy back. Planned worker: claude-opus5.5.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
