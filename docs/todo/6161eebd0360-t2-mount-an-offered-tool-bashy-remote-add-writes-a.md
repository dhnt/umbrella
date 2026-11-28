---
id: 6161eebd0360
kind: feature
title: 'T2 mount an offered tool: bashy remote add writes a local registered record, typed in the agent tool list, digest-pinned'
seq: 852
status: todo
priority: p1
created: 2026-11-27T23:59:34.66897Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 T2. An offered tool goes into the agent's own tool list (moved here from Sprint 740 S2 store add; the store then only looks the listing up and calls this).

bashy remote add HOST NAME [--as LOCAL] reads the typed definition and digest from the offer app (K4 route, member token or mesh) and writes a local registered command record whose exec is bashy remote HOST -- NAME {args}, with the offered args schema, effects and the pinned definition digest. Registered records with an args schema already become typed MCP tools and refresh live (yoke mcp direct.go:56-64,179-309; pkg/fleet command_schema.go:40-63), so the tool shows in bashy mcp tools with no new mount mechanism. On a call the caller compares the pinned digest with the door's; a changed digest refuses, naming bashy remote add as the fix. bashy remote remove NAME deletes the record; bashy remote list shows mounted tools with host, class, unit and digest. All verbs with --json.

Works for all three classes: a mounted model is the typed call llm, a mounted agent the typed call {task} under the offer's token cap. Calls through a mounted tool are metered by T1 like any other.

Accept: unit tests: add writes a valid record (fleet Command.Validate) and the tool appears in the MCP tool list with a typed schema; remove; digest-change refusal; --as rename; a reserved or shadowing local name is refused. Not in MVP: discovery or search of offers (the offerer posts the bashy remote add line with bashy mb; the listing is Sprint 740 S2).

Code inspected 2026-11-27: yoke mcp direct.go policy.go, pkg/fleet commands.go command_schema.go; bashy internal/agentos registered.go mcp.go. Depends on K2, K4. Filed at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).
