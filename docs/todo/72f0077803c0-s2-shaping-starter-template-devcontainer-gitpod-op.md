---
id: 72f0077803c0
kind: feature
title: 'S2 shaping starter template: devcontainer + gitpod, opens into a shaping session'
seq: 111
status: todo
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-11T04:32:53.311241Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
---

Planned vendor: glm. bashy/examples/shaping-host/template/: .devcontainer/devcontainer.json (bashy OCI base or Ubuntu + installer) with postStartCommand 'bashy shaping-host up'; .gitpod.yml tasks equivalent; hello-world shaping example registered and live at /h/<host>/app/hello-world/; README with Open-in button and the one secret. Requirement (a): the user's private repo created from the template is the backstore. Depends on S1. Verify: plan steps 1, 2, 4, 7.
