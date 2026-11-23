---
id: d80f551b7d18
kind: feature
title: 'A2 Hosted plane: serve the agent-ready paths, headers and serving rule for dhnt.io (absorbs the Accept tie-break follow-up); one release; live verification'
seq: 672
status: todo
priority: p1
created: 2026-11-23T13:51:45.613792Z
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 1 on the hosted plane. Consume dhnt/site v0.2.0; serve /AGENTS.md, /skill.md, /.well-known/agent-skills/index.json, /.well-known/mcp/server-card.json, the llms.txt preamble, the new link relations, the UA list and the tie-break (cloudbox follow-up 60b2b1007498 is absorbed here); keep every existing route unchanged; HTML ETag through the edge investigated (Cache-Control: no-transform or accept the meta revision). Release per the cloudbox playbook with operator go; live verification by curl through the edge for every rule. Owned on the private hosted plane; wire-level evidence only in public docs.
