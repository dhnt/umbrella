---
id: 9ab0921633a8
kind: feature
title: 'S2 examples/agentic/lib.bsh: copy-on-write script store, gates (bashy check, allowlist, effects within the command''s atlas row), graph ledger, bashy-agentic-v1 envelope'
seq: 246
status: todo
priority: p0
labels:
    - agentic
created: 2026-11-13T19:17:58.948326Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

New bashy/examples/agentic/lib.bsh sourced by forge.bsh. Store: $BASHY_HOME/agentic/CMD/CMD.bsh with versions CMD.1.bsh, CMD.2.bsh kept (copy-on-write), pending.json for a caller-tier request, undo restores the previous version. Gates before any save: bashy check --agent on the candidate (bashy-check-v1 inventory), every command the inventory names is in the allowlist (CMD's own subcommands from bashy CMD --help --format mcp plus the verbs the help names), the @guard/@effects declared are within CMD's atlas effects, no secret values (only refs via bashy secret exec NAME=VAR --), the ~~~skill fence parses (--skill prints) and --help exits 0. Ledger: bashy graph observe forge|refine|execution cmd:CMD --outcome success|failure --data version=N ... --json under BASHY_KB_DIR (host-local; verified this session that observe/recall/pitfalls work under a temp dir). Envelope bashy-agentic-v1: schema_version, command, request/argv, source (script|refined|forged|caller), version, duration_ms, model, exit, answer. Own module examples/agentic/go.mod + forge_bsh_test.go (harness copied from examples/cast/cast_bsh_test.go; no model, stubs only). Verified: @guard(effects: read,exec) on a function running its argv denies touch (126) and sh -c (unknown effects), so generated scripts must declare outpost/ssh effects explicitly.
