---
id: 6d4586110064
kind: spike
title: 'P2 Design durable cross-client tasks for Meta surfaces: mobile approvals, cancellation, idempotent retries and no-push recovery'
seq: 353
status: wontfix
priority: p2
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:29.443634Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.227287Z
---

Shared semantics with S642/S643; relate notifications to Sprint 620 (docs/comms-strategy.md), do not duplicate comms. Design: long tasks that continue after the Muse app closes and resume on any client; approval round-trips on mobile for Write and Sensitive-write tools (approval covers only the details shown; changed details need fresh approval); cancellation and single-owner handoff between a Muse client, the steward and an outpost Muse Code session (session messaging where available); retry rules per connector guidelines (check status first, Idempotency-Key on the public wire, no duplicate effects); durable status/result polling that works with no push channel documented for Meta clients. Planning only.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
