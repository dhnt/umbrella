---
id: 794b3caebb10
kind: bug
title: 'F12 bashy ps: -o time and -o command are refused or print nothing'
seq: 705
status: todo
priority: p3
labels:
    - coreutils
created: 2026-11-24T12:56:16.898682Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Seen 2026-11-24 on the dev box, where the shell's ps is bashy's: 'ps -o pid,etime,time,command -p PID' fails with 'unknown output format "command"', and 'ps -o time= -p PID' printed nothing for a live process, which made a supervision check report a running manager as exited. time is a POSIX ps -o keyword; command is the common BSD alias of args. Fix in the ps applet with a unit test for each keyword; host ps was used as the workaround. 2 points.
