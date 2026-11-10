---
id: 0ada8418d6e6
kind: doc
title: S6 Consolidate outpost and bashy CLI surfaces, MCP metadata, and satellite runbooks
seq: 74
status: todo
priority: p2
labels:
    - satellite
    - cli
    - docs
created: 2026-11-10T01:43:06.799342Z
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S1, S2, S3, S4, S5.

Scope
- Consolidate the two-layer CLI model: local host daemon verbs on outpost (register, unpair, satellite attach|detach|list, peers) and account/fleet verbs on bashy (login, satellite, paired-host).
- Reconcile help text, JSON schemas, and MCP tool metadata across yoke and bashy.
- Update docs/satellite-operations-workflow.md and KB pages to reflect single-daemon multi-satellite attachments and member sharing without master-token or outpost-profile workarounds.

Acceptance
- Help, schema, and docs match the consolidated CLI surface; end-to-end HTTP fixture tests verify primary pairing, multi-satellite attachment, and member sharing.
