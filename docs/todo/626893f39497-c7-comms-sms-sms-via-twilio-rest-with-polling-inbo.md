---
id: 626893f39497
kind: feature
title: 'C7 comms/sms: SMS via Twilio REST with polling inbound (no webhook)'
seq: 155
status: todo
priority: p3
labels:
    - communications
created: 2026-11-12T16:17:25.784136Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

twilio-go (MIT) or curl; send via Messages API; inbound by polling Messages list -> meet dm -> reply. README documents US A2P 10DLC / toll-free verification and cost. Relates c512b342864d Twilio client. Planned worker: muse-spark1.3.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
