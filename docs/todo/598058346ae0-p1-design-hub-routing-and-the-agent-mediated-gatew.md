---
id: 598058346ae0
kind: feature
title: P1 Design hub routing and the agent-mediated gateway tool set mapped to bashy verbs
seq: 330
status: todo
priority: p1
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:32.698801Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Scope
Design hub routing and the gateway tool set; design only.

## Requirements to design
- Routing: the hub resolves the caller's satellites and outposts by membership and forwards over the existing hub-outpost link; bashy verbs execute on the host; host MCP stays loopback.
- Tools: list_hosts; delegate (client idempotency key -> one task id; repeated submission never duplicates execution); status; clarify; approve (bound to the reviewed candidate digest); cancel (recorded outcome); result; bounded read-only bashy queries under the yoke/mcp/direct.go effect policy.
- Execution ownership: one owner per task (steward, conductor or an explicitly delegated coding agent); ownership transfer is explicit and never leaves two coordinators driving one task.
- Honest states: offline host, unknown, asserted vs verified success. Conversational context stays separate from the authoritative execution record.
- Map each tool onto existing steward, `bashy sprint` and weave verbs; list gaps.

## Done when
Tool schemas, state machine, idempotency and ownership rules and the verb mapping are documented with gaps. No implementation.
