---
id: d9b9f56c88c6
kind: test
title: C5 e2e with a fake cligw backend (contained genie; canary; no credentials)
seq: 825
status: todo
priority: p1
created: 2026-11-27T14:25:10.497601Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C5. bashy tests/: a fake cligw backend returns scripted completions with tool calls. Contained genie writes the expected file in DIR, cannot read a canary outside DIR, sees no credential in env or files; expired and out-of-scope tokens refused. Green twice on the gate host in the official image, raw logs kept, minutes per run.
