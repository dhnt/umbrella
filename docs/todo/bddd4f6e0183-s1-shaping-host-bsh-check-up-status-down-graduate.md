---
id: bddd4f6e0183
kind: feature
title: 'S1 shaping-host.bsh: check/up/status/down/graduate on a free workspace or an owner outpost'
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

Planned vendor: codex. bashy/examples/shaping-host/shaping-host.bsh (mirror examples/onboard/onboard.bsh). check: detect platform (CODESPACES, GITPOD_WORKSPACE_ID) or owner outpost; report platform/idle_timeout/bashy/outpost/paired. up: install.sh --no-service if needed; idempotent outpost register under a stable host name with the pair code from a platform or host secret; outpost supervisord in background (no systemd); bashy app serve on loopback; idempotent on a home host. graduate APP: move the registration free host <-> owner outpost. Verify: plan steps 6-7. Spec: docs/sprint-615-master-execution-plan.md
