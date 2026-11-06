---
id: 6e4bb2e13140
kind: refactor
title: 'S4 L4+: coreutils Classic-only (agentic/optional code to yoke)'
seq: 27
status: todo
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:31.940648Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Problem: coreutils/pkg/weavecli imports sh/polyglot and reaches cmd/coreutils via pkg/schedule and pkg/nudge; pkg/nudge, tool/mcpdoc, schedule LLM-budget hook and posixproviders are non-Classic. Change: move them to yoke leaving opaque hooks in coreutils; posixproviders manifest to yoke. Exit: cmd/coreutils links no sh Bash# package and no yoke; coreutils name-set ratchet (POSIX u GNU coreutils u gencat + gate tooling); coreutils go test ./... and S0 green. Plan: docs/plan-s575-master-execution.md
