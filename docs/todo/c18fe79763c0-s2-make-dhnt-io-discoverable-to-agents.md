---
id: c18fe79763c0
kind: feature
title: S2 Make dhnt.io discoverable to agents
seq: 639
status: todo
priority: p1
created: 2026-11-23T02:45:04.417414Z
sprint: 693
sprint_id: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a
sprint_title: dhnt.io navigation and shaping for people and agents
---

Depends on S1 (4fc13e0db790). Advertise app home and direct formats in page metadata and response links. Publish a short /llms.txt listing both pages. Register a cataloged Bashy site skill to read the published representations and expose one WebMCP read_page tool in a supported browser. On the live site, start each client with only a page URL and record whether it discovers a structured format or needs a direct link or supported setup. Include Bashy and a WebMCP-capable browser in the live gate.
