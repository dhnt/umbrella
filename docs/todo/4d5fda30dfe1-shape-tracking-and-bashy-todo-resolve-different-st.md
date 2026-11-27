---
id: 4d5fda30dfe1
kind: bug
title: shape tracking and bashy todo resolve different stores outside a git repo
seq: 817
status: todo
priority: p2
labels:
    - shapeware
created: 2026-11-27T01:12:58.883415Z
---

Found by the Sprint 730 field-loop e2e (2026-11-26). Outside a git repo, bashy todo add writes the steward list (todo.DefaultOwner, yoke/pkg/todo/cli.go:175) while shape wish --todo resolves the caller's own list via shapeTrackingRoot(actor) (bashy internal/agentos/shape_local.go:47; actor from bus.ResolveAuthoredActor). So shape wish --todo ID fails with 'no issue in the register' for a todo filed by bashy todo add. In a repo both use docs/todo. Workaround: run the feed from an operations repo (documented in shape-feed). Record the root cause decision before any fix.
