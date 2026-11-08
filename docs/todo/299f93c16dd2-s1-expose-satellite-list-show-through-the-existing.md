---
id: 299f93c16dd2
kind: feature
title: S1 Expose satellite list/show through the existing public client
seq: 58
status: done
priority: p1
labels:
    - satellite
    - cli
    - agentic
created: 2026-11-08T18:28:22.979112Z
weave: 2
assignee: muse-conductor
sprint: 598
sprint_id: 3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3
sprint_title: 'Agent-friendly satellite CLI: minimal daily operations'
closed: 2026-11-08T18:57:23.853041Z
closed_by: s598-manager
---

Sprint 598 (3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3). Agreed MVP: KISS, rod not fish, software shaping.

Goal: reusable read primitives for daily agent operations.
Implementation: extend the existing satellite verb in yoke/pkg/fleet and bashy wiring. Add list (ls alias) and show <id|name>, using OwnerClient.Satellites and its existing public GET /api/v1/satellites contract. Show selects from the list response; expose ID, name, endpoint and state only. Exact ID wins; otherwise require a unique exact name. Missing or ambiguous matches fail explicitly.
Interface: list --json returns {"satellites":[...]}; show --json returns {"satellite":{...}}. Empty list succeeds. Human output remains concise. Reuse existing JSON and error conventions; do not add a detail/status API or infer host assignment.
Acceptance: fixture coverage for populated/empty lists, ID/name lookup, duplicate names, missing records, authorization failure, malformed response and unavailable endpoint. Reads issue no mutation requests.
Compatibility: client support is not evidence of deployed service support; report unavailable endpoints honestly.
The operator subsequently authorized implementation, managed assignment, verification, and delivery of Sprint 598. The creation-only restriction is superseded.
