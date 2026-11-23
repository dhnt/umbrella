---
id: d80f551b7d18
kind: feature
title: 'A2 Hosted plane: serve the agent-ready paths, headers and serving rule for dhnt.io (absorbs the Accept tie-break follow-up); one release; live verification'
seq: 672
status: todo
priority: p1
created: 2026-11-23T13:51:45.613792Z
assignee: codex-gpt6-astra
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 1 on the hosted plane. Consume dhnt/site v0.2.0; serve /AGENTS.md, /skill.md, /.well-known/agent-skills/index.json, /.well-known/mcp/server-card.json, the llms.txt preamble, the new link relations, the UA list and the tie-break (cloudbox follow-up 60b2b1007498 is absorbed here); keep every existing route unchanged; HTML ETag through the edge investigated (Cache-Control: no-transform or accept the meta revision). Release per the cloudbox playbook with operator go; live verification by curl through the edge for every rule. Owned on the private hosted plane; wire-level evidence only in public docs. Plan: docs/sprint-697-master-execution-plan.md (vendor proposal codex-gpt6-astra; the conductor assigns). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'. SCOPE ADDED (story review 2026-11-23, finding 4): A2 also ships the same-origin /mcp route on the hosted plane: POST plus SSE GET proxied through the pages' auth middleware to the owner's engine (bashy mcp serve profile site), and /.well-known/oauth-protected-resource pointing at the site sign-in; it may ship before A3 is accepted (it returns the upstream's error until the owner's engine serves the profile). Points 5 -> 8.
