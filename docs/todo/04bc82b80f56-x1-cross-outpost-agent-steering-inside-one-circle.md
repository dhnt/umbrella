---
id: 04bc82b80f56
kind: feature
title: 'X1 Cross-outpost agent steering inside one circle: inventory, protocol choice, smallest missing link'
seq: 581
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:43:12.65411Z
---

Inventory the existing steering surfaces against one scenario: chat steer|attach|grant|interrupt (host room, one machine), sprint session steer|approve|share (cloudbox shared session, multi-host), herald and herald add as a fleet binding (A2A, peer elsewhere), herald acp (this machine as an ACP agent, also over outpost ssh), bashy mcp serve (tools, not steering), outpost ssh exec|connect|tunnel (paired hosts, tunnel or mesh-direct). Record which path is integrated end to end and which is not (for example whether a shared-session directive reaches a live chat session on the other host). Choose the protocol per case: ACP for a client driving one agent, A2A for agent to agent, MCP for tools, the shared session for human approvals. Integrate only the smallest missing link so a circle member on one outpost can steer a teammate's agent member on another, admitted through the circle. Public wire contract only; no private source in public builds. Contract: docs/plan-group-participation.md.
