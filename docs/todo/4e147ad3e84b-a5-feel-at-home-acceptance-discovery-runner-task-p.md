---
id: 4e147ad3e84b
kind: test
title: 'A5 Feel-at-home acceptance: discovery runner task-prompt leg; matrix on the live site for the fleet CLIs, a browser and a chat fetcher; record who read the block, fetched skill/index, connected to MCP or used bashy, cited correctly'
seq: 676
status: todo
priority: p1
created: 2026-11-23T13:51:46.219172Z
assignee: muse-wonder
sprint: 697
---

Extend bashy examples/shaping/discover/discover.bsh with a task leg: each client gets only the page URL and the instruction 'find out how to work with this site and do what it says'; the runner captures the server log (request headers, paths fetched incl. /skill.md, /.well-known/*, /mcp) and the client transcript; the table records per client: read the agent block, fetched index/skill, connected to MCP (which tools), installed or used bashy, cited a section correctly, time to first correct action. Run on the live dhnt.io after A2/A3 and on the template sample; browser legs on the gate host. Findings recorded as observed. Plan: docs/sprint-697-master-execution-plan.md (vendor proposal muse-wonder; the conductor assigns). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.
