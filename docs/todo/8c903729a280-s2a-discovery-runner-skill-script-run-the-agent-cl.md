---
id: 8c903729a280
kind: feature
title: 'S2a Discovery runner skill-script: run the agent/client discovery matrix against any site origin or a local site server with request logging'
seq: 644
status: done
priority: p1
created: 2026-11-23T04:22:18.857877Z
weave: 160
assignee: muse-wonder
sprint: 693
closed: 2026-11-23T04:34:20.31574Z
closed_by: claude-fable5.1
---

Prepares S2 (c18fe79763c0, the live run after S1) so the live evidence is one command. Deliver bashy/examples/shaping/discover/discover.bsh (own directory; do NOT touch examples/shaping/site/, which S0 is building in parallel) with an embedded skill and script tests, following the conventions of examples/shaping/website/website.bsh. Verbs: matrix ORIGIN [--clients LIST] [--json|--md] runs each client with ONLY the page URL (ORIGIN/about) and records per client: the request it sent (method, Accept, User-Agent when observable), the representation received (content-type, ETag, Vary), the section ids and links it extracted, whether it found a structured format by itself, needed the direct .md/.json twin, or needed the skill; whether it fetched /llms.txt or followed rel=alternate (recorded, never assumed). Clients: curl default (*/*); curl with the Claude Code header 'text/markdown, text/html, */*'; bashy fetch; bashy fetch --md; bashy browser --mode solo (rendered text and links); optional agent CLIs via their own fetch tools (claude, codex, gemini/agy, opencode: ask each, non-interactively, to read the URL and report the content-type, section ids and links it saw; skip cleanly when a CLI is absent). serve DIR --log FILE starts a local request-logging server (reverse proxy to a site server, or a static fixture of the three representations under testdata/) so the matrix produces real facts about what each agent sends BEFORE the live release; the fixture follows the plan's contract (HTML with <section id>, PATH.md, PATH.json, Vary: Accept, ETag = revision, Link rel=alternate, robots.txt, llms.txt). Output: a Markdown table ready for docs/evidence/sprint-693-dhnt-io-navigation.md plus --json. Acceptance: script tests green; a run against the fixture server records every non-agent client correctly; the agent-CLI leg runs for at least one installed CLI and records its request headers from the log. Browser legs are small here (a few headless navigations); no full bashy build, no gate suites on this host. WORKER RULES: bashy submodule, branch off origin/main; trailers Sprint: #693 / Sprint-ID: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a / Story: #<seq> / Story-ID: <id> / Agent: muse-wonder; do not bump umbrella pins; on completion run bashy sprint submit 693 <id> --as muse-wonder -m '<evidence>'. Plan: docs/sprint-693-master-execution-plan.md.
