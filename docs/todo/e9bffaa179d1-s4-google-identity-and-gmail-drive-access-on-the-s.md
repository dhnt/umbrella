---
id: e9bffaa179d1
kind: feature
title: S4 Google identity and Gmail/Drive access on the shaping host
seq: 113
status: todo
priority: p2
labels:
    - shaping
    - google
created: 2026-11-11T04:32:53.567276Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
---

Planned vendor: claude. Requirement (b), preferred. Reuse examples/google (BYOP). First establish whether the gws loopback OAuth redirect completes inside a cloud workspace (desktop IDE forwards localhost; web IDE does not); fallback auth-import of a token minted elsewhere; record the working route per platform. up runs google auth-status and restores credentials from a platform user secret, never from the repo. No core changes. Verify: plan step 5.
