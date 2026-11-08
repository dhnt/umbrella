---
id: d8df96f14240
kind: enhancement
title: S3 Make satellite transfer JSON-capable and noninteractive
seq: 60
status: done
priority: p1
labels:
    - satellite
    - cli
    - agentic
created: 2026-11-08T18:28:23.264088Z
weave: 5
assignee: agy-gemini3.8-flash
sprint: 598
sprint_id: 3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3
sprint_title: 'Agent-friendly satellite CLI: minimal daily operations'
closed: 2026-11-08T19:28:59.074832Z
closed_by: s598-manager
---

Sprint 598 (3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3). Agreed MVP: KISS, rod not fish, software shaping.

Goal: agents can invoke the existing transfer operation with explicit confirmation and consume its result.
Implementation: add --json and --no-input to satellite transfer. JSON serializes the existing TransferResult fields; reuse existing exit-code conventions. With --no-input or noninteractive stdin, absence of --yes fails before POST transfer. Preserve interactive confirmation for attended callers and existing --yes behavior. Print prompts/progress outside JSON stdout.
Resolve exact ID first; otherwise require a unique exact name. Reject missing/ambiguous targets before mutation. Keep server authorization and ownership checks authoritative.
Acceptance: fixture tests cover JSON success, interactive accept/cancel, --yes, --no-input without --yes, noninteractive stdin, ambiguous target and server refusal. Assert zero transfer POSTs when confirmation or target resolution fails. Do not automatically retry the transfer mutation.
No new transfer workflow, approval service or lifecycle engine.
The operator subsequently authorized implementation, managed assignment, verification, and delivery of Sprint 598. The creation-only restriction is superseded.
