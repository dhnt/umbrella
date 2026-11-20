---
id: d3989b118dd7
kind: feature
title: 'S7: Companion Yoke CLI executable and shapeable command-slot dispatch (shapedRegisteredArgv)'
seq: 557
status: todo
priority: p2
labels:
    - bashy
    - yoke
    - shape
    - architecture
created: 2026-11-20T10:01:54.093407Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repos: bashy, yoke. Build the AgentOS/Yoke command surface as a companion CLI executable installed alongside the ~29 MB bashy core binary (preserving a monolith build tag for FROM scratch container images). Route externalized Yoke commands and CLI apps through registeredHandler + shapedRegisteredArgv + slot.Store (~/.bashy/shape-host/<cmd>/), enabling per-command/app software shaping (bashy shape wish/verify/preview/approve/undo <cmd>) in seconds without rebuilding or re-execing the core shell. Acceptance: installbashy verification, TestE2EAllListedCommandsDispatch, make test-bash-gate, and CLI-kind shape lifecycle tests pass with 100% UX parity. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
