---
id: daf6adc9246c
kind: feature
title: 'F1 Site MCP on dhnt.io: publish the owner site MCP endpoint, set PUBLIC_SITE_MCP_UPSTREAM, re-advertise /mcp; A5 MCP leg on the live site'
seq: 740
status: todo
priority: p2
labels:
    - hosted-plane
created: 2026-11-25T06:08:19.310737Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
---

Remainder of Sprint 697 A2, held back from train 1 by A2a (operator rule: never release an unusable surface). Done when an anonymous agent following dhnt.io agents.txt connects to <origin>/mcp and gets list_pages/read_page/cite answers through the hosted proxy, Bearer still routes to the gateway, and the advertising is switched back on in the same change. Live check runs in the next release train.
