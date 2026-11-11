---
id: 20ce3526b52a
kind: enhancement
title: S6 outpost start path without systemd (conditional)
seq: 115
status: todo
priority: p3
labels:
    - outpost
created: 2026-11-11T04:32:53.820942Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
---

Planned vendor: codex. Only if S1 proves the skill-script workaround insufficient. outpost service install on Linux without systemctl should print the exact 'outpost supervisord' line or support a foreground-supervisor mode instead of only erroring (outpost/cmd/outpost/service_linux.go). Separate commit; targeted unit tests only.
