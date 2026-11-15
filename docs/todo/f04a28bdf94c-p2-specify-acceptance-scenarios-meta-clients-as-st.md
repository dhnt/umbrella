---
id: f04a28bdf94c
kind: test
title: 'P2 Specify acceptance scenarios: Meta clients as stack UI plus the outpost Muse Code agent journey, mobile and clean-machine'
seq: 355
status: wontfix
priority: p2
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:29.693753Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.606753Z
---

Scenario specs only; live runs need separate operator authorization. Per surface (muse.ai web, Muse iOS, Muse Android, WhatsApp, Meta AI app/web, Muse Code on a clean machine): first sign-in, connector/account linking, read journey (fleet/satellite/outpost status), one Write with approval, one Sensitive-write approval-every-time check, denial path, cancellation, resume after app close. Outpost journey (Goal B): fresh host role install, auth choice, Contributor-off verification, headless muse exec through agentlaunch completing a bounded bashy task via loopback MCP, usage/billing visibility, revocation. End-to-end shaping lifecycle (wish -> candidate -> verify -> preview -> approve -> activate -> undo) from one mobile client and one headless client. Evidence form per scenario (recording, transcript, command log) decided here. Planning only.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
