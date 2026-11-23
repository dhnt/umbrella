---
id: 4e147ad3e84b
kind: test
title: 'A5 Feel-at-home acceptance: discovery runner task-prompt leg; matrix on the live site for the fleet CLIs, a browser and a chat fetcher; record who read the block, fetched skill/index, connected to MCP or used bashy, cited correctly'
seq: 676
status: todo
priority: p1
created: 2026-11-23T13:51:46.219172Z
sprint: 697
---

Extend bashy examples/shaping/discover/discover.bsh with a task leg: each client gets only the page URL and the instruction 'find out how to work with this site and do what it says'; the runner captures the server log (request headers, paths fetched incl. /skill.md, /.well-known/*, /mcp) and the client transcript; the table records per client: read the agent block, fetched index/skill, connected to MCP (which tools), installed or used bashy, cited a section correctly, time to first correct action. Run on the live dhnt.io after A2/A3 and on the template sample; browser legs on the gate host. Findings recorded as observed.
