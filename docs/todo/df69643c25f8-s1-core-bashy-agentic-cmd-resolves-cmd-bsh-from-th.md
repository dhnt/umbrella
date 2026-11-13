---
id: df69643c25f8
kind: feature
title: 'S1 core: bashy agentic CMD resolves CMD.bsh from the skill-script ring, applies the worth-it gate, hands off to agentic-forge (--no-forge keeps today''s path)'
seq: 245
status: todo
priority: p0
labels:
    - agentic
created: 2026-11-13T19:17:58.795289Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Rod-thin change in bashy/internal/agentos/agentic.go (agenticCommand): before the existing rungs resolve CMD.bsh, first match wins: $BASHY_AGENTIC_SKILLS/CMD.bsh; the host overlay $BASHY_HOME/agentic/CMD/CMD.bsh (default ~/.bashy/agentic); a registered command whose exec ends in CMD.bsh; embedded skills/bashy/recipes/CMD.bsh. Found: exec bashy --bashsharp CMD.bsh ARGS with BASHY_AGENTIC=1 (the existing script rung). Not found: worth-it gate spends no model call: builtin (interp.IsBuiltin), applet (tool.Lookup) or verb whose atlas.Lookup effects are only read/write/exec run as today, no forge, no yield (agentic cd ~/ just changes directory); a verb with net/cred/destroy/spend effects, a registered command with a long help listing subcommands, or an unknown external (ssh) hands off to the registered command agentic-forge run CMD ARGS. --no-forge keeps today's behaviour for every name. Help text updated. Unit test of the ring order and the gate (agentic_test.go); the e2e dispatch gate stays green on the 3-OS matrix; CGO_ENABLED=0 GOOS=windows build. No generation in Go. Plan: docs/sprint-633-master-execution-plan.md.
