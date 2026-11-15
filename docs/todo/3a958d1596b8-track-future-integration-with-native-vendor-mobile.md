---
id: 3a958d1596b8
kind: feature
title: Track future integration with native vendor mobile apps (Claude, ChatGPT, Gemini, Muse/Meta AI/WhatsApp) beyond the Sprint 646 MVP
seq: 364
status: todo
priority: p3
labels:
    - software-shaping
    - vendor-gateway
    - mobile
created: 2026-11-15T15:12:33.113133Z
---

Tracking item for work after Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353). The MVP covers mobile only through connector reuse: a connector added on the web shows up in the mobile app, and replies are text-first. Design of record: docs/vendor-chat-gateway-mvp.md.

## Per-app qualification (dated sources, then live checks with operator authorization)

| App | What to qualify | Research source |
|---|---|---|
| Claude iOS/Android | Adding a connector on mobile (beta); MCP Apps inline cards only, no side panel; reuse by Claude Duet | superseded story 50291ed35646 |
| ChatGPT iOS/Android | Work plugin availability; the Android Cloud UI; host-paired Remote vs Cloud | superseded story f0cabeb9c6e3 |
| Gemini Android/iOS | Connectors auto-synced from the web; Keep Activity and Workspace gates; Scheduled Actions as a trigger | superseded story 7eb38edf97a8 |
| Muse iOS/Android, WhatsApp, Meta AI app and glasses | After Muse Connector Platform review and Meta AI Connectors preview admission | superseded stories 58d2c602a03e, f9298cd7f42b, ed8f91939741 |

## Mobile-specific design

- Approval and diff cards as MCP Apps where they render inline, with text fallback elsewhere.
- Phone notifications for pending approvals and finished tasks (Sprint 620 ntfy Approve/Deny, story 46433a7796d3), until vendor push or MCP Events exist.
- Resuming a task by id after a mobile reconnect.
- Voice input where the app offers it.

## Done when

- A per-app matrix of what is documented, what was checked live, and any gaps.
- One mobile acceptance scenario per app on the fleet-mirror venue: wish → delegate → approve → result, with the originating workstation offline.
- Follow-up sprint stories filed for each gap.
