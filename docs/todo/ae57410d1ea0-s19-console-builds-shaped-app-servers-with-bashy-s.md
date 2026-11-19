---
id: ae57410d1ea0
kind: bug
title: S19 console builds shaped-app servers with bashy's own Go toolchain when no go is on PATH
seq: 498
status: done
priority: p1
labels:
    - shaping
    - yoke
    - windows
created: 2026-11-19T00:21:41.811374Z
assignee: claude-opus5.5-s615
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
closed: 2026-11-19T06:34:30.687804Z
closed_by: claude-opus5.5-s615
---

Found 2026-11-18 enabling owner shaping on the operator's Windows host: the console builds a shaped app's server with exec 'go' (ShapeOptions.GoTool, never set), and a host with only bashy installed has no go on PATH, although 'bashy go' provisions Go 1.27.2. Classification: product defect (bashy is all you need). Fix: defaultGoTool falls back to '<bashy> go env GOROOT'/bin/go[.exe] when go is not on PATH; TestResolveGoTool.
