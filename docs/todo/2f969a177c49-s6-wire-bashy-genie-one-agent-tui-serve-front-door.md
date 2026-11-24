---
id: 2f969a177c49
kind: feature
title: 'S6: Wire bashy genie One Agent TUI + serve front door, genie cligw bridge, pins, and e2e suite'
seq: 564
status: wontfix
priority: p1
labels:
    - bashy
    - genie
    - tui
    - e2e
created: 2026-11-20T13:08:36.665215Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
closed: 2026-11-24T18:16:22.127347Z
---

Repos: bashy, umbrella. Extend bashy genie and bashy genie serve (internal/agentos/genie.go + genie_hub_tui.go) with --agent, --cligw, --protocol, --tui=unified|native, --no-tui, --listen, --token-env, --gate, --dry-run, --json, and literal -- extra-args while preserving all existing genie/ycode invocations. Route background hub logs away from stderr while TUI owns the terminal; fail closed on --protocol tui,acp. Bump yoke + ycode pins and prove PTY TUI + HTTP/A2A/MCP/ACP/REST + ephemeral cligw in deterministic zero-token e2e tests. Depends on S2, S3, S4, S5. Spec: docs/plan-one-agent-genie-hub.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. Routing between people, agents and hosts is already supported by the group model as implemented (Sprints 684/685, gateway sync/pull/hosted routes); the extra protocol surfaces are not needed now. Retired, not delivered.
