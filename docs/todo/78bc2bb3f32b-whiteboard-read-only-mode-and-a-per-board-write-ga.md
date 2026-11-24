---
id: 78bc2bb3f32b
kind: feature
title: 'whiteboard: read-only mode and a per-board write gate (one collab server per principal)'
seq: 691
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-24T11:57:46.96175Z
---

Found by the group-shaping coverage matrix (docs/group-shaping-coverage-matrix.md). Evidence (bashy/examples/whiteboard): no read-only mode and no access check. OwnerKey is generated on add (server/desk.go:197-203) but never compared; Locked is set by close (desk.go:270) but set (desk.go:247-253) does not check it; the collab server sends Access-Control-Allow-Origin: * and accepts any session (server/collab.go:92). README.md:38-40: no per-board credential, loopback reachability plus the paired console is the boundary. One collab server per process (server/main.go:76, sessions in memory collab.go:15-17), and the console runs one server and data dir per paired principal (README.md:5,107). Not small: a viewer needs a server-side read-only join in the collab protocol and a way for several principals to reach one board. Revision today is only an integer counter (desk.go:~245,271); the kit store could hold the scene blob. Related existing stories: c4bbeb92 (co-edit with a live viewer), 3aa3e25a (same-origin framing).
