---
id: 507e2cab30e5
kind: feature
title: F2 Re-advertise 'bashy site attach' on agent-ready pages once a released bashy carries it
seq: 741
status: todo
priority: p2
labels:
    - hosted-plane
    - release
created: 2026-11-25T06:08:19.593255Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
---

Held back from train 1 by A2a. 'bashy site attach' first landed in bashy 775bcc30 (2026-11-23) and is in no released bashy (latest v1.0.0-rc.40-dev). Switch the line back on in the hosted plane config only after the bashy release that carries it is promoted; verify from that release against dhnt.io.

## Triage 2026-11-25 (consolidated into Sprint 724)

No longer waiting on a bashy build: 775bcc30 is in tag v1.0.0-rc.41. Remaining: confirm that release is promoted, switch the line on in the hosted plane config (merge to dev, next train), verify from the released bashy.
