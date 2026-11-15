---
id: ed8f91939741
kind: spike
title: P2 Design the Meta AI Connectors preview application and settle the WhatsApp channel decision
seq: 351
status: wontfix
priority: p2
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:12.647118Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.513841Z
---

Meta AI Connectors (dev.meta.ai/products/connectors): developer preview in waves; live REST API or MCP onboarding; one integration on AI glasses + Meta AI app + web; OAuth account linking; application needs product, API docs link and use case. Apply the same gateway tool set as the Muse connector story; do not build a second backend. WhatsApp decision record: (a) Muse-in-WhatsApp via the approved directory connector (zero channel code) vs (b) stack-owned WhatsApp Business number via Cloud API + webhooks (developers.facebook.com/documentation/business-messaging/whatsapp/about-the-platform) fronting gateway/steward; recommend (a) default, (b) only for a Meta-independent mobile UI. Also close the Messenger/Instagram question with primary docs or record it as unreachable. Planning only.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
