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
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Found by the group-shaping coverage matrix (docs/group-shaping-coverage-matrix.md). Evidence: bashy/examples/brainstorm/server/shaped.json exists (main '.', args -addr $ADDR -data $DATA, no genie block) and desk/shaped_test.go:34 lists brainstorm as shaped-capable, but brainstorm/register.sh:53 runs app add brainstorm --port ... (a plain port tile), not --type shaped. Shaped registration is only a manual README step (README.md:155-161). Default bind is 0.0.0.0:18091 (server/main.go:30). Fix needs the shaped build path (own go.mod, kit published to the module proxy) and a decision on the LAN default; verify on a host before relying. Existing story 842b7bcc (circle participants) is the roster side.
