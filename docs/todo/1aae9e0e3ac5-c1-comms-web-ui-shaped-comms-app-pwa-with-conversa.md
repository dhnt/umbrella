---
id: 1aae9e0e3ac5
kind: feature
title: 'C1 Comms web UI: shaped comms app (PWA) with Conversations, Composer, Approvals, Channels pages'
seq: 149
status: todo
priority: p1
labels:
    - communications
created: 2026-11-12T16:17:24.994843Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Register one shaped app 'comms' via app add --type shaped (pattern bashy/examples/desk/notepad/register.sh), served by the existing web console at /shape/comms/; responsive so it installs as a PWA on iPhone and Android; remote via outpost app share under circle/group grants. Pages: Conversations (meet/room list+show), Composer (meet dm / notify / comms <channel> send), Approvals (pairing + /approve), Channels (comms <channel> setup|status). No web-only operation. Planned worker: claude-sonnet5.5.

Acceptance (common): both directions; CLI and web parity (every web action calls a CLI op); Windows+macOS client, Linux service, iPhone+Android via app or PWA; paired member allowed, unpaired sender gets a pair code, non-member denied; destructive verbs gated by /approve; new deps pass bashy/docs/licensing-supply-chain-policy.md; lands in bashy/examples/comms/ only. Spec: docs/comms-strategy.md.
