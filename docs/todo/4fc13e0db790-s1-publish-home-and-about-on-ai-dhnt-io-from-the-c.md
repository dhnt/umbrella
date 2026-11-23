---
id: 4fc13e0db790
kind: feature
title: 'S1 Publish home and /about on ai.dhnt.io from the content module: server-rendered sections, Accept negotiation, .md/.json twins, robots.txt, llms.txt'
seq: 638
status: todo
priority: p1
created: 2026-11-23T02:44:58.585616Z
sprint: 693
sprint_id: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a
sprint_title: dhnt.io navigation and shaping for people and agents
---

Depends on S0 (content module). The hosted plane imports the module at a pinned version and serves / and /about with the page's content and shared navigation rendered server-side (one no-JavaScript block per page, declared section ids), negotiates Accept (text/markdown -> Markdown, application/json -> JSON, else HTML), serves the twins /index.md /index.json /about.md /about.json, sets Vary: Accept and a strong ETag equal to the page revision, emits Link and <link rel=alternate> for both twins, <link rel=canonical>, <meta name=revision>, and serves /robots.txt and /llms.txt. The browser application renders the module's JSON instead of its own copy of the prose. Ships in an ordinary hosted-plane release with the operator's go. Acceptance through the live edge: curl with each Accept returns the right body with Vary: Accept and the same ETag; a Markdown fetch then an HTML fetch of the same URL returns HTML (no variant bleed); the no-JavaScript HTML and the rendered page of /about list the same sections and ids; from /about a headless browser (bashy browser --mode solo) and bashy fetch both reach /, return, and cite about#team @ <revision> identically. Evidence: raw headers and bodies in docs/evidence/sprint-693-dhnt-io-navigation.md (wire-level only). Plan: docs/sprint-693-master-execution-plan.md.
