---
id: 14323dfcce0a
kind: bug
title: bashy run as sh with an empty PATH cannot run echo (exit 127); fails bash53 execscript in the official image
seq: 412
status: todo
priority: p3
created: 2026-11-17T18:44:00.764051Z
---

Found 2026-11-17 running the Bash 5.3 gate in the official build image, where /opt/bashy/bin/sh -> bashy. Repro: ln -s $(command -v bashy) DIR/sh; env PATH= DIR/sh -c 'echo hi' -> 'sh: line 1: echo: command not found', rc=127, while 'type echo' in the same shell says 'echo is a shell builtin'. Works as /bashy with PATH empty, and as sh with PATH unset. Pre-existing: rc.35 fails the same way, so not an rc.37 regression. How the fixture reaches it: execscript sets PATH= then 'command -p sh -c "echo this is $0"'; command -p searches /opt/bashy/bin first by design (sh d4e1231c), so in any image with bashy installed as sh the fixture runs bashy-as-sh with an empty PATH. On plain Ubuntu /opt/bashy/bin is absent and it ran dash, which is why the gate was 86/86 there. Result in the official image: 85/86 in both modes, only execscript (line 52, want 'this is sh'). Root cause of the echo lookup not yet located: suspect the sh persona routes echo through a PATH-dependent dispatch instead of the builtin.

## Reclassified 2026-11-17 (operator): venue, not a code fix

The shell code passed every gate; a failure in a new venue is the venue's
configuration first. The gate failure was the gate image inheriting the
build tooling's /opt/bashy/bin/sh and PATH (fixed in the venue, bashy
5544f40c). No code change for rc.37. The bashy-as-sh behavior with an
empty PATH stays recorded here as an observation for later review against
GNU bash, not as a release blocker.
