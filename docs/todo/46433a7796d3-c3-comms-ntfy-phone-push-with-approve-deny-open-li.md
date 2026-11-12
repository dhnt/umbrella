---
id: 46433a7796d3
kind: feature
title: 'C3 comms/ntfy: phone push with Approve/Deny, Open link and Copy capsule actions; subscribe into meet dm'
seq: 151
status: todo
priority: p1
labels:
    - communications
created: 2026-11-12T16:17:25.257347Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

ntfy (Apache-2.0) server + official iOS/Android apps. send: publish with actions; listen: SSE subscribe -> meet dm -> reply; approve buttons resolve /approve. Reuse existing ntfy sink (story 33f400bc9ac3). iOS push via ntfy upstream relay documented. Planned worker: codex-gpt6-sol.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
