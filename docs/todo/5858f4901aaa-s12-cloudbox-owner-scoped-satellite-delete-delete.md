---
id: 5858f4901aaa
kind: feature
title: 'S12 cloudbox: owner-scoped satellite delete (DELETE /api/v1/satellites/:id) + bashy satellite rm'
seq: 259
status: done
priority: p1
created: 2026-11-13T21:29:27.311217Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-13T22:13:09.354381Z
closed_by: claude-fable5.1-s630
---

Gap: the master has no route that removes a satellite row. destroy-lost only destroys a provider VM when a provisioning record + stored provider token exist; rows made outside the master (bashy infra provision, hand-made) can never be removed, and 'enabled' rows with dead endpoints cannot be marked lost over Bearer (POST /api/satellites/:id/lost is session-only). Deliver: Bearer satellites:write DELETE /api/v1/satellites/:id; refuses an enabled satellite whose last contact is recent unless ?force=1; cascades assignments, enrollments, config, admit rules, host index, checkpoints; audit row. yoke: bashy satellite rm ID [--force] [--dry-run] [--json]. Tests: handler + cascade + refusal. Release as v0.18.70 (master only).
