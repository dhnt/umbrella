---
id: f0edb1d7a496
kind: spike
title: P1 Design hub routing and the agent-mediated gateway tool set mapped to bashy verbs, with Meta Read/Write/Sensitive-write classification
seq: 349
status: todo
priority: p1
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:12.400138Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
---

Shared with S643 routing story 598058346ae0. Map Cloudbox accounts/members, Satellite discovery, Outpost administration and Bashy userland verbs to a bounded agent-mediated tool set for all four stack components; satellite is a discoverable target where applicable, not on every path. Classify every tool Read / Write / Sensitive-write per Muse connector guidelines (platform.muse.ai/docs section 3) from bashy effect classes (see bashy mcp serve --allow destroy,spend,cred,priv and bashy mcp tools --json); anything combining read+write is a Write; spend/cred/destroy-class effects are Sensitive-write (approval every use). Preserve named satellite gaps (docs/satellite-operations-workflow.md). Text fallback everywhere; rich forms only where a surface documents them. Planning only.
