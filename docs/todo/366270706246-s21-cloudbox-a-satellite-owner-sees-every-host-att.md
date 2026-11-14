---
id: "366270706246"
kind: feature
title: 'S21 cloudbox: a satellite owner sees every host attached to their satellite, including other accounts'' hosts'
seq: 269
status: assigned
priority: p1
created: 2026-11-14T04:10:59.084808Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

Operator 2026-11-14: on alien's card the novigens owner does not see the dev box (gmail-owned, attached via mutual membership). Root cause: ListIndexedHosts keeps index rows only where the row owner is the caller or shared_with names the caller, AND the satellite owner equals the row owner or a login grant exists; decorateDirectoryEntry lists assignment host_names owned by the satellite owner only. Fix: for satellites the caller OWNS, include every index row and every assignment regardless of row owner, with owner on the entry (the UI already prints owner when it differs); other accounts' views unchanged. Tests: owner sees foreign attached host; the foreign host owner sees it on their own list; a third mutual member does not.
