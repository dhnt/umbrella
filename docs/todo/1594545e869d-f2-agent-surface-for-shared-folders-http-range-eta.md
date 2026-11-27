---
id: 1594545e869d
kind: feature
title: 'F2 agent surface for shared folders: HTTP Range/ETag/sha256, bashy:// URIs, bashy files ls/stat/cat/get/link, site MCP files_*'
seq: 835
status: todo
priority: p1
created: 2026-11-27T15:44:28.894254Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §3 Shared folders, §4 F2. Agents read team artifacts in place instead of copying (big video outputs): JSON listing, GET/HEAD with Range, ETag and sha256; stable bashy://HOST/files/N/PATH resolved via satellite (members, member token + stamp) or mesh (owned hosts); CLI bashy files ls/stat/cat/get/link; site MCP files_list/stat/read(bounded range)/link. Not in MVP: sync, caching, locking, versioning, FUSE/NFS/SMB mount, quotas. Code inspected 2026-11-27: outpost cmd/outpost capability_files.go; bashy internal/agentos mcp_site.go.
