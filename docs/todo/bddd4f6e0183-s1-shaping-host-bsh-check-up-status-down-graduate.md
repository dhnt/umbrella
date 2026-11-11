---
id: bddd4f6e0183
kind: feature
title: 'S1 shaping-host.bsh: check/up/status/down/graduate on free cloud workspaces'
seq: 110
status: todo
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-11T04:32:53.178343Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
---

Planned vendor: codex. New Bash# custom command bashy/examples/shaping-host/shaping-host.bsh mirroring examples/onboard/onboard.bsh. check: detect platform (CODESPACES, GITPOD_WORKSPACE_ID, Firebase Studio markers, CLOUD_SHELL), report platform/persistent_home/idle_timeout/bashy/outpost/paired. up: install.sh --no-service if needed; idempotent outpost register under a stable host name (shape-<platform>-<repo>) with BASHY_PAIR_CODE from a platform user secret; start outpost supervisord in background (no systemd); bashy app serve --bind 127.0.0.1. graduate APP prints the satellite path only. Verify: plan steps 1-3. Spec: docs/sprint-615-master-execution-plan.md
