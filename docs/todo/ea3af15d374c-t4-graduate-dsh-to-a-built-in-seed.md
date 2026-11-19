---
id: ea3af15d374c
kind: feature
title: T4 Graduate dsh to a built-in seed
seq: 538
status: assigned
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:45.822265Z
assignee: claude-opus5.5-s671
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
---

Move bashy/examples/fleet/tools/dsh.yaml into yoke/pkg/fleet/baseline/tools/dsh.yaml (keep the Node >= 24.9 requirement declared); drop it from the examples README and examples test; add an offline seed test like zcode_setup_test.go. Accept: tool show dsh from a fresh store; targeted unit tests green.
