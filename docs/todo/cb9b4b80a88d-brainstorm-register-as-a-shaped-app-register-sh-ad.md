---
id: cb9b4b80a88d
kind: bug
title: 'brainstorm: register as a shaped app (register.sh adds a port tile, not --type shaped)'
seq: 693
status: todo
priority: p3
labels:
    - group-shaping
created: 2026-11-24T11:57:47.321749Z
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Owner publishing for a shapeable page and its shapeable components (any website)
---

Found by the group-shaping coverage matrix (docs/group-shaping-coverage-matrix.md). Evidence: bashy/examples/brainstorm/server/shaped.json exists (main '.', args -addr $ADDR -data $DATA, no genie block) and desk/shaped_test.go:34 lists brainstorm as shaped-capable, but brainstorm/register.sh:53 runs app add brainstorm --port ... (a plain port tile), not --type shaped. Shaped registration is only a manual README step (README.md:155-161). Default bind is 0.0.0.0:18091 (server/main.go:30). Fix needs the shaped build path (own go.mod, kit published to the module proxy) and a decision on the LAN default; verify on a host before relying. Existing story 842b7bcc (circle participants) is the roster side.

## Moved to Sprint 683 (2026-11-24, operator: close Sprint 703)

Owner publishing (offer, adopt) is Sprint 683's workflow, held on 705 S3; this story travels with it instead of being dropped.
