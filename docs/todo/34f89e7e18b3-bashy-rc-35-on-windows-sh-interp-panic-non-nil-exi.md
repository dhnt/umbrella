---
id: 34f89e7e18b3
kind: bug
title: 'bashy rc.35 on Windows: sh interp panic ''non-nil exitStatus.err but a zero exitStatus.code'' running a multi-line argv over outpost ssh'
seq: 435
status: todo
priority: p2
labels:
    - bashy
created: 2026-11-17T20:39:11.949526Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

2026-11-17 on the second Windows host (bashy v1.0.0-rc.35 as the outpost ssh remote shell): 'outpost ssh <host> -- powershell -NoProfile -EncodedCommand <base64 with embedded newlines>' made bashy panic in mvdan.cc/sh/v3 interp.(*Runner).Run (api.go:3869) via internal/cli.run (main.go:3091). Root cause first: reproduce on rc.37 (argv joined unquoted into a script with newline-split base64 lines, powershell failing on the first line), name the exit-status path that sets err with code 0. Engine change = migration policy applies (baseline-proven C commit). Verification: unit/regression test in sh interp + build.
