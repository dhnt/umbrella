---
id: 3cca0ba419a0
kind: feature
title: 'A3b bashy consumer verbs: site explore / attach / cite / shape; skills add from a URL; fetch surfaces the agent block'
seq: 674
status: todo
priority: p1
created: 2026-11-23T13:51:45.918828Z
assignee: agy-gemini4-carbon
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 2 (CLI) and the channels table. bashy is the first consumer of /agents.txt: site explore URL fetches /agents.txt first (fallback: the Bashy-Shaped header, the Link relations, the agent block in the Markdown twin, /AGENTS.md, /llms.txt), prints the agent block, then index, twins, source, edit, MCP endpoint, skill, revision (--json = parsed agents.txt + agent: object + header values); site attach URL admits the skill from /.well-known/agent-skills/index.json or /skill.md through the verified-admission gate (bashy skills add gains URL input) and records the site in the kb; site cite URL#id returns the citation record; site shape URL registers the source repository as a shaped app on this host and prints the shaping sequence; site recipe URL prints the page's text/bashsharp recipe and runs it ONLY on an explicit --run, inside the verifier sandbox with effects capped to read,net and targets restricted to the page's origin and the URLs the recipe names (a recipe asking for more is shown, never run); bashy fetch prints the agent block first and reports Bashy-Shaped and the Link relations. Script tests against the template's fixture server and against a site without any of the channels (graceful: 'not an agent-ready site'). Plan: docs/sprint-697-master-execution-plan.md (vendor proposal agy-gemini4-carbon; the conductor assigns). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.
