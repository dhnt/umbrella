---
id: 0eac011ff4a9
kind: feature
title: 'P0 kit: SSE hub, embeddable CSP option, logged LAN guard'
seq: 651
status: done
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.356296Z
weave: 166
assignee: agy-opus5.5
sprint: 696
closed: 2026-11-23T12:38:16.383387Z
closed_by: agy-gemini4-carbon
---

In examples/desk/kit (stdlib only): kit.Events, one GET /api/events?id= stream per item with frames {item, block, revision} and Last-Event-ID resume (pattern: yoke/pkg/meet/events_sse.go, examples/demo-queue/server.go); a CSP option that allows frame-ancestors 'self' for apps that opt in; kit.CheckLoopback gains an explicit --lan override that is logged on start (every guard has an escape hatch). Contract-test rows for all three; the memo fixture stays green and goes red on each -break variant. No change to the other desk apps in this story. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).
