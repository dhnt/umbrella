---
id: f99b5693f5b7
kind: feature
title: S2 Reuse invocation-scoped account selection for satellite operations
seq: 59
status: done
priority: p1
labels:
    - satellite
    - cli
    - agentic
created: 2026-11-08T18:28:23.111863Z
weave: 4
assignee: muse-conductor
sprint: 598
sprint_id: 3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3
sprint_title: 'Agent-friendly satellite CLI: minimal daily operations'
closed: 2026-11-08T19:14:19.328015Z
closed_by: s598-manager
---

Sprint 598 (3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3). Agreed MVP: KISS, rod not fish, software shaping.

Depends on S1 for the new read commands.
Goal: satellite list/show/invite/transfer select endpoint and credential consistently without a new context/profile system.
Implementation: bind --account using the existing fleet accountFlag/cloudOverrides/ResolveCloudAccount seam and existing category/conflict rules. Reuse small client adapters as needed; do not introduce another resolver or change global environment/profile state.
For invite, --account supplies the satellite endpoint and credential, so --satellite is optional when --account is present. --account together with --satellite or --token is a conflict. For list/show/transfer, explicit --master/--token together with --account conflicts under the existing rules. Without --account, preserve current credential resolution and invite requirements.
Acceptance: fixtures with two endpoints and separate credentials prove correct routing, no cross-endpoint credential use, no ambient fallback after explicit selection fails, no active-profile changes, supported category handling and explicit-option conflict refusals before network mutation. Secret sentinels absent from records, errors and normal output; intentional invite-code output retains existing compatibility.
The operator subsequently authorized implementation, managed assignment, verification, and delivery of Sprint 598. The creation-only restriction is superseded.
