---
id: 8d4a91d1c1b5
kind: feature
title: 'C4 comms/email: two-way email via himalaya CLI (listen by poll, send, reply, digest)'
seq: 152
status: todo
priority: p1
labels:
    - communications
created: 2026-11-12T16:17:25.389209Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

himalaya (MIT/Apache) as sha-pinned download for macOS/Windows/Linux; setup with app password or OAuth via Ortie; listen polls envelope list --json for unseen mail from allowed senders -> meet dm -> message reply; send for notify/digest (relates 6bdc6f81ca48). Planned worker: opencode-glm-5.3.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
