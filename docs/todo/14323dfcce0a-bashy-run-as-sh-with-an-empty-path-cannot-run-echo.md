---
id: 14323dfcce0a
kind: bug
title: bashy run as sh with an empty PATH cannot run echo (exit 127); fails bash53 execscript in the official image
seq: 412
status: todo
priority: p1
created: 2026-11-17T18:44:00.764051Z
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
---

Found 2026-11-17 running the Bash 5.3 gate in the official build image, where /opt/bashy/bin/sh -> bashy. Repro: ln -s $(command -v bashy) DIR/sh; env PATH= DIR/sh -c 'echo hi' -> 'sh: line 1: echo: command not found', rc=127, while 'type echo' in the same shell says 'echo is a shell builtin'. Works as /bashy with PATH empty, and as sh with PATH unset. Pre-existing: rc.35 fails the same way, so not an rc.37 regression. How the fixture reaches it: execscript sets PATH= then 'command -p sh -c "echo this is $0"'; command -p searches /opt/bashy/bin first by design (sh d4e1231c), so in any image with bashy installed as sh the fixture runs bashy-as-sh with an empty PATH. On plain Ubuntu /opt/bashy/bin is absent and it ran dash, which is why the gate was 86/86 there. Result in the official image: 85/86 in both modes, only execscript (line 52, want 'this is sh'). Root cause of the echo lookup not yet located: suspect the sh persona routes echo through a PATH-dependent dispatch instead of the builtin.
