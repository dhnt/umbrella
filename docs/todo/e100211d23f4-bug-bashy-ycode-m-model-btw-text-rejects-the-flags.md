---
id: e100211d23f4
kind: bug
title: 'bug: bashy ycode -m MODEL btw TEXT rejects the flags (''invalid command flags''); the forge needs a tool-free one-shot on a chosen model'
seq: 252
status: todo
priority: p2
labels:
    - agentic
created: 2026-11-13T19:17:59.865621Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Observed 2026-11-13 on the dev box (bashy from ~/.local/bin, genie bundle builtin d74d597289f5): bashy ycode -m door-claude-opus5 btw 'Reply with the single word PONG.' exits 2 with 'error: invalid command flags'; the same with -- before the text; bashy ycode btw TEXT without -m goes to the local pick and stops because gpt-oss:20b is not pulled. bashy ycode btw --help shows only --session and --yolo. Expected: the documented bashy ycode [-m MODEL] btw TEXT form answers tool-free on the named model (agent.yaml btwPrompt). Root cause before any fix: find whether the genie recipe (ycode/examples/genie/dag.md chat target) strips -m for btw or ycode's cli parser refuses the flag for that command. Blocks the door tier of S4 (vendor tier is unaffected).
