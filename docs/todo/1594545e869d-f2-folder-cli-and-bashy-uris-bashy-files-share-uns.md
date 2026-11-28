---
id: 1594545e869d
kind: feature
title: 'F2 folder CLI and bashy:// URIs: bashy files share/unshare/shares (owner), ls/stat/cat/get/link (member)'
seq: 835
status: todo
priority: p1
created: 2026-11-27T15:44:28.894254Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 F2. Owner: bashy files share NAME [--path DIR] [--circle|--group|--email] [--force --reason R] writes ~/.bashy/shared/NAME.json (creates the empty default folder when no --path), then outpost apps share files-NAME; refuses a path that is HOME, an ancestor of HOME or contains ~/.bashy unless --force (logged in the record); unshare NAME (removes record, app and rule; keeps files); shares lists the records. Member: bashy files ls/stat/cat/get/link over the satellite with the member token (SatelliteTokenSource; relax ParseSatelliteAppURL satellite_exchange.go:39 for files-* apps), mesh for owned hosts; bashy://HOST/files-NAME/PATH resolution shared with K3. CLI is the agent surface; MCP wrapper only if bashy's existing MCP exposure already covers verbs. Not in MVP: write, sync, caching, locking, versioning, mounts, quotas, discovery listing. Code inspected 2026-11-27 (revised after review): yoke pkg/fleet satellite_exchange.go satellite_invite.go; bashy internal/agentos mcp_connect.go.

Review 2026-11-27: unchanged. Folder verbs are not offered tools and are not metered in this sprint (plan §3.1, §5). Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Revised 2026-11-27 night (operator: everything is a tool call as far as agents are concerned; the name is TaaS). Folder verbs are tool calls: bashy files share offers files-NAME with the audience (outpost apps share offer-files-NAME); member ls/stat/cat/get/link HOST:NAME/PATH is a thin CLI over the files-NAME call; an agent can instead mount it with bashy remote add HOST files-NAME (T2). Relax the satellite URL check for offer-* apps. The earlier 'not offered tools, not metered' note is superseded.
