---
id: c9f0a2d5343c
kind: bug
title: 'cligw slash= splits the chat message into argv: flag injection into vendor CLIs'
seq: 192
status: done
priority: p1
labels:
    - vendor-services
created: 2026-11-13T02:18:41.294409Z
closed: 2026-11-13T02:27:16.379834Z
---

Found by S626 S7 (docs/sprint-626-acceptance.md F1). yoke/pkg/cligw/slash.go:360 passes lastUserText(req) as the toolcmd args string and never sets Options.Argv, so toolcmd shell-splits it and {args} in every seed expands to many tokens. Observed: a plain plan request containing '--version' ran claude --version and returned outcome success; a multi-word request reached claude as its first word only. Seeds were measured on the shell door where {args} is one operand. Fix: Options.Argv = []string{args} in the slash path, plus a unit test with a leading-dash message (via the runToolCommand seam).
