---
id: 8db4892f3a6d
kind: feature
title: 'S5: Export presentation-only BubbleTea TUI Host seam and /hub status slash command'
seq: 563
status: wontfix
priority: p1
labels:
    - ycode
    - tui
created: 2026-11-20T13:08:36.52004Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
closed: 2026-11-24T18:16:38.844094Z
---

Repo: ycode. Expose the presentation-only BubbleTea TUI runner and Host interface (ycode/internal/harness/frontend/tui) cleanly for bashy genie hub sessions and add /hub slash command to inspect bound co-served URLs/protocols, keeping ycode 100% free of MCP and fleet-roster dependencies (TestGeneratedDocsAdvertiseNoMCPServer stays green). Spec: docs/plan-one-agent-genie-hub.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. Routing between people, agents and hosts is already supported by the group model as implemented (Sprints 684/685, gateway sync/pull/hosted routes); the extra protocol surfaces are not needed now. Retired, not delivered.
