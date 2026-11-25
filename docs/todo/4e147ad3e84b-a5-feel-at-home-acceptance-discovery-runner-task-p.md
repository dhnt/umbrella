---
id: 4e147ad3e84b
kind: test
title: 'A5 Feel-at-home acceptance: discovery runner task-prompt leg; matrix on the live site for the fleet CLIs, a browser and a chat fetcher; record who read the block, fetched skill/index, connected to MCP or used bashy, cited correctly'
seq: 676
status: todo
priority: p1
created: 2026-11-23T13:51:46.219172Z
assignee: muse-wonder
sprint: 718
sprint_id: 9984cebc-ae0e-52ba-bf24-ee859733b740
sprint_title: 'Train 1 live follow-ups (revisit): H5 share/revoke + re-invite real mail with test accounts, A5 on dhnt.io, satellite shell title'
---

Extend bashy examples/shaping/discover/discover.bsh with a task leg. Each client gets only the page URL and the instruction 'find out how to work with this site and do what it says'. The runner captures the server log (request headers and paths fetched, including /skill.md and /.well-known/*) and the client transcript. The table records, per client: whether it read the agent block, fetched the index/skill, cited a section correctly, and its time to first correct action. Run on the live dhnt.io after train 1 is deployed, and on the template sample; browser legs on the gate host. Findings recorded as observed.

SCOPE (release manager, 2026-11-24, operator complete-and-usable rule): train 1 ships the agent-ready pages WITHOUT the /mcp and 'bashy site attach' advertising (story A2a 141bc34d). The MCP and site-attach legs of this matrix moved to Sprint 711 (F1 daf6adc9, F2 507e2cab). Here, record that neither is advertised.

GATED: starts only after T1 76eac0ea is live; a priority-first conductor must not pull it forward.

WORKER RULES: branch off the repo's integration branch. Commit with trailers Sprint: #699 / Sprint-ID: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a / Story: #676 / Story-ID: 4e147ad3e84b / Agent: <your name>. Targeted tests only; builds on the gate host. Do not bump umbrella pins or push umbrella. Submit with bashy sprint submit 699 4e147ad3e84b --as <your name> -m '<verify commands, results, commit SHA>'. Plan: docs/sprint-699-master-execution-plan.md.
