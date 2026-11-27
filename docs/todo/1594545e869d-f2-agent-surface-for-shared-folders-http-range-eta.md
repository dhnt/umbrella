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

Plan: docs/sprint-739-master-execution-plan.md §4 F2. Owner: bashy files share DIR --name N [--circle|--group|--email] writes the outpost.shares setting then outpost apps share files-N; unshare; shares. Member: bashy files ls/stat/cat/get/link over the satellite with the member token (SatelliteTokenSource; relax ParseSatelliteAppURL satellite_exchange.go:39 for files-* apps), mesh for owned hosts; bashy://HOST/files-NAME/PATH resolution shared with K3. CLI is the agent surface; MCP wrapper only if bashy's existing MCP exposure already covers verbs. Not in MVP: write, sync, caching, locking, versioning, mounts, quotas, discovery listing. Code inspected 2026-11-27 (revised after review): yoke pkg/fleet satellite_exchange.go satellite_invite.go; bashy internal/agentos mcp_connect.go.
