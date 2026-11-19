---
id: bddd4f6e0183
kind: feature
title: S1 shaping-host.bsh check/up/status on a Codespace
seq: 110
status: done
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-11T04:32:53.178343Z
assignee: claude-opus5.5-s615
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
closed: 2026-11-19T06:34:26.668981Z
closed_by: claude-opus5.5-s615
---

Planned vendor: codex. MVP (down/graduate and the owner-outpost path are in Sprint 665). bashy/examples/shaping-host/shaping-host.bsh, mirroring examples/onboard/onboard.bsh. check: detect Codespaces; report bashy, outpost and paired. up: install.sh --no-service if needed; idempotent outpost register under a stable host name, with the pair code from a Codespaces secret; outpost supervisord in the background (no systemd); bashy app serve on loopback. status: the same report. Spec: docs/sprint-615-master-execution-plan.md
