---
id: 73d6c801c709
kind: feature
title: 'C5 Klatch continuation: handoff link opens the Klatch topic linked to the meet room'
seq: 153
status: todo
priority: p2
labels:
    - communications
created: 2026-11-12T16:17:25.518672Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Depends on S520.2 e7f2d0be4fd1 (Klatch group <-> meet room) and benefits from S519.3 ea31ee9674f6 push relay / S519.4 f352e5847876 Android; do not duplicate them. comms link (C2) resolves to the linked Klatch topic when one exists; conversation continues in Klatch app or PWA with the same agents on the outpost. Planned worker: claude-opus5.5.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
