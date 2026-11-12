---
id: c5ca9e3369d5
kind: feature
title: 'C6 comms listeners for Discord, Slack, Telegram: shared comms/lib/listen.bsh into meet dm'
seq: 154
status: todo
priority: p2
labels:
    - communications
created: 2026-11-12T16:17:25.647373Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Existing yoke/pkg/feed adapters (Discord gateway, Slack Socket Mode, Telegram poll) have no caller outside tests. Glue: Listen (Telegram: Poll loop timeout=30) -> meet dm AGENT --channel --sender --thread (stdin) -> adapter Send reply. Single pairing gate: pass-through checker, meet dm owns pairing. Graduation candidate: bashy feed listen verb. Planned worker: agy-gemini3.8-flash.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
