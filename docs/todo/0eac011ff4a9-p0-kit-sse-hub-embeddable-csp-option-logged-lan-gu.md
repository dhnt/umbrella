---
id: 0eac011ff4a9
kind: feature
title: 'P0 kit: SSE hub, embeddable CSP option, logged LAN guard'
seq: 651
status: todo
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.356296Z
sprint: 696
---

In examples/desk/kit (stdlib only): kit.Events, one GET /api/events?id= stream per item with frames {item, block, revision} and Last-Event-ID resume (pattern: yoke/pkg/meet/events_sse.go, examples/demo-queue/server.go); a CSP option that allows frame-ancestors 'self' for apps that opt in; kit.CheckLoopback gains an explicit --lan override that is logged on start (every guard has an escape hatch). Contract-test rows for all three; the memo fixture stays green and goes red on each -break variant. No change to the other desk apps in this story. Spec: docs/page-live-group-page.md.
