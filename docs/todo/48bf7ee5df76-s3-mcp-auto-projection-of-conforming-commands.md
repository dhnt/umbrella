---
id: 48bf7ee5df76
kind: feature
title: S3 MCP auto-projection of conforming commands
seq: 416
status: todo
priority: p2
labels:
    - yoke
created: 2026-11-17T18:49:46.451061Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: shell, agent and MCP surfaces are maintained separately.
Behavior: every contract-conforming command is exposed as an MCP tool automatically: input schema derived from its flags, output from the envelope, effects metadata surfaced. Builds on yoke/mcp and pkg/cligw; non-conforming commands are not projected.
Depends on: S0.
Verification: projected tool list equals the conforming set from the gate; round-trip fixture per featured command.
