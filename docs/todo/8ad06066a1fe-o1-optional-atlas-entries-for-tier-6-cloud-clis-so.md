---
id: 8ad06066a1fe
kind: enhancement
title: 'O1 optional: atlas entries for Tier-6 cloud CLIs so they become typed, effect-gated MCP tools'
seq: 668
status: todo
priority: p3
labels:
    - bashy-hosting
    - mcp
created: 2026-11-23T13:18:04.906322Z
---

Planned vendor: agy. Core (yoke/pkg/atlas), small, optional. Finding 2026-11-23: every command is reachable over MCP through the untyped bashy script tool, but mcpVerbCommands (bashy/internal/agentos/mcp_verbs.go) skips front-door verbs without an atlas entry, so aws, az, gcloud, doctl, gws, glab, gitea, tofu, m365, gam are not typed tools (bashy mcp tools --tools aws -> unknown command). Add atlas entries next to gh (TierCloud, GroupClusterCloud, CapNeedsNetwork; effects cred, net, remote; spend on aws, az, gcloud, doctl); per-subcommand effects remain follow-up 1d91d26edc7c. Accept: bashy mcp tools --tools aws,gcloud --json lists both with bashy.effects; a call without --allow cred fails 126; atlas tests green. Spec: docs/sprint-691-master-execution-plan.md
