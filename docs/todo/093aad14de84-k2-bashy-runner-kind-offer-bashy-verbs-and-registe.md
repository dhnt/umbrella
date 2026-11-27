---
id: 093aad14de84
kind: feature
title: 'K2 offerable registered commands and bashy verbs (ToolCommand overlay, no new runner kind)'
seq: 830
status: todo
priority: p1
created: 2026-11-27T15:34:19.121048Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K2. No new runner kind: generate a user-overlay ToolCommand (tool binary bashy, mode print, exec: bashy NAME {args}, effects + timeout from the registered record; herald.yaml pattern); bashy binds the record's own schema (registered.go:390). FIRST verify the door routes a model-less bashy tool row (cligw catalog.go:280-315 deriveInventory needs a tool+model binding); if not, that catalog change is the story. Code inspected 2026-11-27 (revised after review): yoke pkg/fleet commands.go command_schema.go types.go toolcommand.go, pkg/toolcmd print.go:84-90, pkg/cligw catalog.go; bashy internal/agentos registered.go.
