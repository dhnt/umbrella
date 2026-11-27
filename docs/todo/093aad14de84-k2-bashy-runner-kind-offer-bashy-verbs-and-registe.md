---
id: 093aad14de84
kind: feature
title: 'K2 bashy runner kind: offer bashy verbs and registered commands (schema-bound args, scratch dir, env allow-list)'
seq: 830
status: todo
priority: p1
created: 2026-11-27T15:34:19.121048Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K2. New ToolCommand runner kind 'bashy' execs a bashy verb or registered command with args bound against the declared schema (BindHTTPArgs style; never raw shell), in a fresh scratch dir, with an env allow-list like shape/delegate.go delegateEnv. Code inspected 2026-11-27: yoke pkg/toolcmd toolcmd.go http.go, pkg/fleet ToolCommand, pkg/shape delegate.go.
