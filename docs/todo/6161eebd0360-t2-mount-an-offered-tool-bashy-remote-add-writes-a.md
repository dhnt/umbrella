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

Tags (operator 2026-11-27, plan §3.1): the mounted record keeps the offer's tags; bashy remote list --tag filters.

Seam (conductor, 2026-11-27; base = yoke main with K4):
- In pkg/offer (K4's RemoteSubcommands): remote add HOST NAME [--as LOCAL] reads GET /offers/NAME?definition over the same transport as bashy remote call (peer door or satellite member route) and writes a registered command record via the existing pkg/fleet commands writer: exec = bashy remote call HOST NAME {args}, args schema from the definition input, effects from the definition, plus pinned digest, host, class, unit, tags (store them in the record's existing metadata/notes fields if no field fits; do not add a new record kind). The record validates with fleet Command.Validate and so appears as a typed tool in bashy mcp tools (yoke mcp direct.go).
- bashy remote call HOST NAME (K4) gains: when invoked through a mounted record, send the pinned digest (header X-Bashy-Offer-Digest); the door refuses 409 when it differs, naming `bashy remote add HOST NAME` as the fix.
- remote remove NAME deletes the record; remote list [--tag T] [--json] shows mounted tools with host, class, unit, digest.
- A reserved or shadowing local name (an existing bashy verb or registered command) is refused unless --as is given.
- Tests: GOWORK=off go test ./pkg/offer/ ./pkg/fleet/.

Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-t2, based on current origin main (`git fetch origin && git checkout -B s739-t2 origin/main` first: the workspace pin is older). Change only what this story needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests only: `cd yoke && GOWORK=off go test ./pkg/offer/ ./pkg/fleet/`. No full suites, no e2e, no network, no podman.
- Commit in yoke with trailers: Sprint: #739 / Story: #852 / Story-ID: 6161eebd0360 / Agent: claude-fable5.2. Do not push main, do not bump any pin, do not edit bashy (the conductor mounts the verbs).
- Finish by appending a "Delivery" paragraph to docs/todo/6161eebd0360-t2-mount-an-offered-tool-bashy-remote-add-writes-a.md (files changed, test command and result) and commit it in the umbrella workspace with the same trailers.
- Budget about 45 minutes. If blocked, write the blocker in the story, commit, and stop.

Conductor note: run the FULL test of every package you touch (no -run filter) before committing; K2 regressed four tests a filtered run missed. Base on yoke main after K4 (fetch origin first).
