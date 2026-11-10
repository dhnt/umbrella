---
id: 01a1c722-a507-754f-959f-19055e23d99b
seq: 1
form: page
type: gotcha
title: bashy otel verbs see no bashy exec spans; use graph history for post-session failures
description: 'WHEN an agent wants to introspect its own failed commands after a session on a host with the file spool exporter (the default): bashy otel failed/bounds/guessed/cost query the OTel stack only, and bashy exec spans never leave ~/.agents/otel/spool/spans.jsonl (hours of retention), so every verb returns 0 matches. Use bashy graph history --failed --since D --episode E (execlog, 91 days) or jq over the spool. Tracked: Sprint 611 stories 0d43fd1f9d65 (fallback) and 12e9009d3244 (drain). Learned 2026-11-10.'
status: candidate
source:
    tool: claude
created: "2026-11-10T20:24:58Z"
---
