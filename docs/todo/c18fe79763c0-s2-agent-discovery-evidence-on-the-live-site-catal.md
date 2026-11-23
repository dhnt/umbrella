---
id: c18fe79763c0
kind: feature
title: S2 Agent discovery evidence on the live site + cataloged dhnt-site skill
seq: 639
status: todo
priority: p1
created: 2026-11-23T02:45:04.417414Z
sprint: 693
sprint_id: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a
sprint_title: dhnt.io navigation and shaping for people and agents
---

Depends on S1 (live). (1) A cataloged Bashy skill dhnt-site (SKILL.md: how to read the pages: Accept header, the .md/.json twins, the citation record {url, section_id, revision, section_sha256, quote}) admitted with bashy skills add and exported; the template (S0) emits it for any <owner>/site. (2) The discovery matrix on the live site, each client started with ONLY the page URL. Clients, at least those bashy works with (operator 2026-11-22): the agent CLIs of the bashy fleet (claude, codex, gemini/agy, opencode) asked to read the page with their own fetch tool; curl default (*/*); bashy fetch with and without --md; bashy browser --mode solo (rendered text and links); one third-party fetcher we can observe. Record per client: representation received; whether it found a structured format by itself, or needed the direct twin, or the skill; whether anything fetched /llms.txt or followed rel=alternate (recorded, never assumed; the research expectation is that only Accept negotiation is used). WebMCP dropped (operator decision 2). Browser legs run on the gate host, never the dev box. Plan: docs/sprint-693-master-execution-plan.md.
