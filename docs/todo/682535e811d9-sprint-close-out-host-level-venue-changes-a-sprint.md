---
id: 682535e811d9
kind: task
title: 'sprint close-out: host-level venue changes a sprint makes must be recorded and undone (or explicitly kept) before ''sprint end'''
seq: 427
status: todo
priority: p2
created: 2026-11-17T19:40:29.579211Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Found 2026-11-17 by story 43d7f0b2: Sprint 563 Phase 0 put three OTel variables into the gate host's user registry environment so outpost exported to the local otel stack. S563 ended [done] without removing them, and every outpost-spawned shell on that host has printed OTel parse/export errors since, which broke tier probes and looked like a product bug. Proposal: sprint stories that change a shared host's persistent config (registry/env, services, scheduled tasks, firewall, WSL/podman machines) record the change on the card as a venue-change entry with an undo command; 'sprint end' lists open entries and refuses until each is undone or marked 'keep' with an owner and a reason (explicit, logged override per the guards-need-an-escape-hatch rule). Scope the design with the operator before implementing; bashy change, so not before rc.37 is promoted.
