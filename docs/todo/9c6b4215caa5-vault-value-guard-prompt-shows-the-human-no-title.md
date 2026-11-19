---
id: 9c6b4215caa5
kind: bug
title: Vault-value guard prompt shows the human no title or question
seq: 520
status: todo
priority: p3
labels:
    - browser
    - secrets
    - ux
created: 2026-11-19T09:38:01.499864Z
---

Seen 2026-11-19: 'bashy browser eval' with a value from 'bashy secret exec' was refused by the guard ('value:vault refused ... stopped (ask-refused) — the form needs a human'). The operator got a prompt asking for a secret with no title and no question, so they could not tell who asked or why. Expected: the guard either refuses outright with the agent-facing message, or, if it asks, names the requesting command, the target page or origin, and what is being asked. Never a bare secret prompt. Done when the ask carries a title and question naming the command and origin, and a test covers it.
