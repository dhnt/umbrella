---
id: 3895d1c38be7
kind: bug
title: Site MCP candidate reply returns host paths to members
seq: 808
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-26T19:45:26.116178Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

The full Candidate JSON returned by shape_wish/verify/preview over the site MCP includes workspace, tracking_root and artifact_path. Members and contractors should not receive host paths. Code inspected (2026-11-26): bashy/internal/agentos/mcp_site.go:595-603; yoke/pkg/shape/service.go:98-136. Found by reading; not reproduced live.

Triage (2026-11-26): linked to Sprint 732; rides with L4.
