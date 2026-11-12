---
id: cd9d0870e0a2
kind: spike
title: 'C8 Decision: general webhook ingress through the satellite (gates WhatsApp Cloud API, Teams, Google Chat)'
seq: 156
status: todo
priority: p3
labels:
    - communications
created: 2026-11-12T16:17:25.922337Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Wave-3 channels are official but need a public HTTPS webhook and business/tenant registration. Decide whether satellite/outpost app share can host a per-owner webhook ingress under grants, or defer. Relates 5e498abf46ae, ad1db13b585f, 42f89d1069ee. Decision only. Planned worker: claude-opus5.5.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
